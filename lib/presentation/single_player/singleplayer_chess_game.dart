import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_game/core/constants/utils/piece_set_custom.dart';
import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:chess_game/core/constants/colors.dart';

import '../../core/constants/utils/pages/board_theme_custom.dart';

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
      setState(() => state = game.squaresState(Squares.white));

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
      setState(() => state = game.squaresState(Squares.white));
    }
  }

  void _showGameResultDialog() {
    final result = game.result;
    if (result == null) return;

    if (result.readable.contains("White won")) {
      _confettiController.play();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Game Over",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          result.readable,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text(
              "New Game",
              style: TextStyle(color: accentAmber),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [ThemeSwitchButton()],
        leading: BackButton(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        centerTitle: true,
        title: Text(
          "You vs AI",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Card(
                color: Theme.of(context).cardColor,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "ChatGPT",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        child: Iconify(
                          Mdi.robot,
                          size: 28,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RepaintBoundary(
                          child: BoardController(
                            animatePieces: true,
                            state: state.board,
                            playState: state.state,
                            pieceSet: PieceSetCustom.fine(),
                            theme: BoardThemeCustom.fine.copyWith(
                              lightSquare: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.3),
                              darkSquare: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.6),
                            ),
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
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.orange,
                            Colors.purple,
                            Colors.yellow,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                aiThinking ? "AI is thinking..." : "Your turn",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.small(
                    heroTag: "undo",
                    tooltip: "Undo Move",
                    onPressed: _undoMove,
                    backgroundColor: Theme.of(context).cardColor,
                    child: const Icon(Icons.undo, color: accentAmber),
                  ),
                  SizedBox(width: 16.w),
                  FloatingActionButton.small(
                    heroTag: "restart",
                    tooltip: "New Game",
                    onPressed: _startNewGame,
                    backgroundColor: Theme.of(context).cardColor,
                    child: const Icon(Icons.refresh, color: accentAmber),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
