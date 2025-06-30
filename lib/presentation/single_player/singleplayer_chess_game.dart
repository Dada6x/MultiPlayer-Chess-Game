import 'package:bishop/bishop.dart' as bishop;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:chess_game/main.dart';

class SinglePlayerChessGame extends StatefulWidget {
  const SinglePlayerChessGame({super.key});

  @override
  State<SinglePlayerChessGame> createState() => _SinglePlayerChessGameState();
}

class _SinglePlayerChessGameState extends State<SinglePlayerChessGame> {
  late bishop.Game game;
  late SquaresState state;
  bool aiThinking = false;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _startNewGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startNewGame() {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(Squares.white);
    setState(() {});
  }

  Future<void> _onMove(Move move) async {
    if (aiThinking || game.result != null) return;

    final moved = game.makeSquaresMove(move);
    if (moved) {
      setState(() {
        state = game.squaresState(Squares.white);
      });

      if (game.result != null) {
        _showGameResultDialog();
        return;
      }

      if (game.turn == bishop.Bishop.black) {
        aiThinking = true;
        await Future.delayed(const Duration(milliseconds: 600));
        game.makeRandomMove();
        setState(() {
          state = game.squaresState(Squares.white);
          aiThinking = false;
        });
        if (game.result != null) {
          _showGameResultDialog();
        }
      }
    }
  }

  void _undoMove() {
    if (game.history.length >= 2) {
      game.undo();
      game.undo();
      setState(() {
        state = game.squaresState(Squares.white);
      });
    }
  }

  void _showGameResultDialog() {
    final result = game.result;
    if (result == null) return;
    debug.i(result.readable);
    if (result.readable == "White won by checkmate") {
      _confettiController.play();
    }
    const Duration(seconds: 4);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(result.readable),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text("New Game"),
          ),
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
        title: const Text("Single Player"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undoMove,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                RepaintBoundary(
                  child: BoardController(
                    animatePieces: true,
                    state: state.board,
                    playState: state.state,
                    pieceSet: PieceSet.fine(),
                    theme: BoardTheme.fine,
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
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 50,
                  colors: Colors.primaries,
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
