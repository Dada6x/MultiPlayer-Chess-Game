import 'dart:math';
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
  bool flipBoard = false;
  bool aiThinking = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(Squares.white);
    setState(() {});
  }

  Future<void> _onMove(Move move) async {
    if (aiThinking) return;

    final moved = game.makeSquaresMove(move);
    if (moved) {
      setState(() => state = game.squaresState(Squares.white));

      // AI makes a random move
      if (game.turn == bishop.Bishop.black) {
        aiThinking = true;
        await Future.delayed(const Duration(milliseconds: 700));

        game.makeRandomMove();
        setState(() {
          state = game.squaresState(Squares.white);
          aiThinking = false;
        });
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoardController(
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
