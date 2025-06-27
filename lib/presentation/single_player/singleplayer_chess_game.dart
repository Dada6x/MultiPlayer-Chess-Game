import 'package:chess_game/main.dart';
import 'package:flutter/material.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart';
import 'package:square_bishop/square_bishop.dart';

class SinglePlayerChessGame extends StatefulWidget {
  const SinglePlayerChessGame({super.key});

  @override
  State<SinglePlayerChessGame> createState() => _SinglePlayerChessGameState();
}

class _SinglePlayerChessGameState extends State<SinglePlayerChessGame> {
  late bishop.Game game;
  late SquaresState state;
  bool aiThinking = false;

  Map<String, int> capturedByWhite = {};
  Map<String, int> capturedByBlack = {};

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(Squares.white);
    capturedByWhite = {};
    capturedByBlack = {};
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
      game.undo(); // Undo AI move
      game.undo(); // Undo player move
      setState(() {
        state = game.squaresState(Squares.white);
      });
    }
  }

  void _showGameResultDialog() {
    final result = game.result;
    if (result == null) return;
    debug.i(result.readable);
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
            RepaintBoundary(
              child: BoardController(
                animatePieces: true,
                state: state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: state.moves,
                onMove: _onMove,
                onPremove: _onMove,
                markerTheme: MarkerTheme(

                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(BorderSide.strokeAlignCenter),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// /// Cyberpunk neon pink & blue color scheme for BoardTheme.
// class CyberpunkBoardTheme extends BoardTheme {
//   CyberpunkBoardTheme()
//       : super(
//           lightSquare:
//               Color(0xFF353965), // very dark navy blue for light squares
//           darkSquare: Color(0xFF2F325A), // darker blue for dark squares

//           check: Color(0xFFFF3CAC), // neon pink for check highlight
//           checkmate: Color(0xFF00FFF7), // neon cyan for checkmate highlight

//           previous:
//               Color(0x66FF00FF), // translucent neon magenta for previous move
//           selected:
//               Color(0x66FF69B4), // translucent hot pink for selected squares
//           premove: Color(0x6600FFFF), // translucent bright cyan for premoves
//         );
        
// }
// class BoardThemeCustom extends BoardTheme {
//   BoardThemeCustom()
//       : super(
//           lightSquare:
//               Color(0xFFE8EDF9), // very dark navy blue for light squares
//           darkSquare: Color(0xFFB7C0D8), // darker blue for dark squares

//           check: Color(0xFFFF3CAC), // neon pink for check highlight
//           checkmate: Colors.red, // neon cyan for checkmate highlight

//           previous:
//               Color.fromARGB(102, 210, 92, 210), // translucent neon magenta for previous move
//           selected:
//               Color(0xFFB1A6FC), // translucent hot pink for selected squares
//           premove: Color(0x6600FFFF), // translucent bright cyan for premoves
//         );
        
// }