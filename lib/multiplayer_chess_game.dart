import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MultplayerChessGame extends StatefulWidget {
  final String roomId;
  final int playerColor; // Squares.white or Squares.black

  const MultplayerChessGame({
    super.key,
    required this.roomId,
    required this.playerColor,
  });

  @override
  State<MultplayerChessGame> createState() => _MultplayerChessGameState();
}

class _MultplayerChessGameState extends State<MultplayerChessGame> {
  late bishop.Game game;
  late SquaresState state;
  bool isLoading = true;
  bool flipBoard = false;

  @override
  void initState() {
    super.initState();
    flipBoard = widget.playerColor == Squares.black;
    _loadGame();
    _subscribeToGame();
  }

  Future<void> _loadGame() async {
    try {
      final data = await Supabase.instance.client
          .from('games')
          .select('fen')
          .eq('id', widget.roomId)
          .maybeSingle();

      if (data != null) {
        game = bishop.Game(
          fen: data['fen'],
          variant: bishop.Variant.standard(),
        );
        state = game.squaresState(widget.playerColor);
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
            final newFen = event.first['fen'];
            if (newFen != game.fen) {
              print('[📥 Realtime] New FEN received: $newFen');
              game = bishop.Game(
                fen: newFen,
                variant: bishop.Variant.standard(),
              );
              setState(() {
                state = game.squaresState(widget.playerColor);
              });
            }
          }
        });
  }

  Future<void> _onMove(Move move) async {
    // Check turn correctly
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ],
            ),
    );
  }
}
