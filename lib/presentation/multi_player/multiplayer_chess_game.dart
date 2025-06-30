import 'package:chess_game/main.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MultiPlayerChessGame extends StatefulWidget {
  final String roomId;
  final int playerColor;
  final String my_name;
  const MultiPlayerChessGame({
    super.key,
    required this.roomId,
    required this.playerColor,
    required this.my_name,
  });

  @override
  State<MultiPlayerChessGame> createState() => _MultiPlayerChessGameState();
}

class _MultiPlayerChessGameState extends State<MultiPlayerChessGame> {
  late bishop.Game game;
  late SquaresState state;
  bool isLoading = true;
  bool flipBoard = false;
  String? opponentName;
  bool waitingForOpponent = true;
  bool _hasShownDialog = false;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    flipBoard = widget.playerColor == Squares.black;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _loadGame();
    _subscribeToGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadGame() async {
    try {
      final data = await Supabase.instance.client
          .from('games')
          .select('fen, white_player, black_player')
          .eq('id', widget.roomId)
          .maybeSingle();
      if (data != null) {
        game = bishop.Game(
          fen: data['fen'],
          variant: bishop.Variant.standard(),
        );
        state = game.squaresState(widget.playerColor);

        final possibleOpponent = widget.playerColor == Squares.white
            ? data['black_player']
            : data['white_player'];

        if (possibleOpponent != null && possibleOpponent.isNotEmpty) {
          opponentName = possibleOpponent;
          waitingForOpponent = false;
        }

        setState(() => isLoading = false);
      } else {
        throw Exception('Game not found.');
      }
    } catch (e) {
      print('Error loading game: $e');
    }
  }

  void _subscribeToGame() {
    Supabase.instance.client
        .from('games')
        .stream(primaryKey: ['id'])
        .eq('id', widget.roomId)
        .listen((event) {
      if (event.isNotEmpty) {
        final data = event.first;
        final newFen = data['fen'];

        game = bishop.Game(fen: newFen, variant: bishop.Variant.standard());
        setState(() {
          state = game.squaresState(widget.playerColor);
        });

        final result = game.result;
        if (result != null && !_hasShownDialog) {
          _hasShownDialog = true;
          final isWinner = (widget.playerColor == Squares.white &&
                  result.readable.contains("White won")) ||
              (widget.playerColor == Squares.black &&
                  result.readable.contains("Black won"));

          if (isWinner) _confettiController.play();

          Future.delayed(Duration(seconds: isWinner ? 4 : 0), () {
            _showGameResultDialog(result.readable);
          });
        }

        final possibleOpponent = widget.playerColor == Squares.white
            ? data['black_player']
            : data['white_player'];

        if (possibleOpponent != null && possibleOpponent.isNotEmpty) {
          setState(() {
            opponentName = possibleOpponent;
            waitingForOpponent = false;
          });
        }
      }
    });
  }

  Future<void> _onMove(Move move) async {
    if (waitingForOpponent) {
      print('Opponent has not joined yet!');
      return;
    }

    final isWhitesTurn = game.turn == 0;
    if ((isWhitesTurn && widget.playerColor == Squares.black) ||
        (!isWhitesTurn && widget.playerColor == Squares.white)) {
      print("It's not your turn!");
      return;
    }

    final moved = game.makeSquaresMove(move);
    if (moved) {
      setState(() => state = game.squaresState(widget.playerColor));

      try {
        await Supabase.instance.client
            .from('games')
            .update({'fen': game.fen}).eq('id', widget.roomId);
      } catch (e) {
        print('❌ Error updating move: $e');
      }
    }
  }

  void _showGameResultDialog(String resultText) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(resultText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room: ${widget.roomId}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                waitingForOpponent
                    ? const Text("Waiting for opponent to join...")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(opponentName!),
                          const CircleAvatar(),
                        ],
                      ),
                Text(
                  game.turn == bishop.Bishop.white
                      ? "White's Turn"
                      : "Black's Turn",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  child: BoardController(
                    state: state.board,
                    playState: state.state,
                    pieceSet: PieceSet.merida(),
                    theme: BoardTheme.pink,
                    moves: state.moves,
                    onMove: _onMove,
                    onPremove: _onMove,
                    markerTheme: MarkerTheme(
                      empty: MarkerTheme.dot,
                      piece: MarkerTheme.corners(),
                    ),
                    promotionBehaviour: PromotionBehaviour.autoPremove,
                  ),
                ),
                Row(
                  children: [
                    const CircleAvatar(),
                    Text(widget.my_name),
                  ],
                ),
              ],
            ),
    );
  }
}
