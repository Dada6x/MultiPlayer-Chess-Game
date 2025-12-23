import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_game/core/constants/utils/QrScanner.dart';
import 'package:chess_game/presentation/game_menu/game_menu.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ci.dart';
import 'package:share_plus/share_plus.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:chess_game/main.dart';

import '../../core/constants/utils/pages/board_theme_custom.dart';
import '../../core/constants/utils/piece_set_custom.dart';

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

  late ConfettiController _confettiController;

  bool _resultDialogShown = false;

  @override
  void initState() {
    super.initState();
    flipBoard = widget.playerColor == Squares.black;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    debug.i("💡 initState: Starting to load game and subscribe");
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
        debug.i("💡 _loadGame: Loaded game data");
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

        setState(() {
          isLoading = false;
          debug.i(
              "💡 build: Building UI, isLoading: $isLoading, waitingForOpponent: $waitingForOpponent");
        });
      } else {
        throw Exception('Game not found.');
      }
    } catch (e) {
      debug.i("❌ Error loading game: $e");
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

            if (newFen != game.fen) {
              debug.i('[ Realtime] New FEN received: $newFen');
              game = bishop.Game(
                fen: newFen,
                variant: bishop.Variant.standard(),
              );
              state = game.squaresState(widget.playerColor);
              setState(() {});
            } else {
              game = bishop.Game(
                fen: newFen,
                variant: bishop.Variant.standard(),
              );
              state = game.squaresState(widget.playerColor);
              setState(() {});
            }

            if (!_resultDialogShown && game.result != null) {
              _resultDialogShown = true;
              _showGameResultDialog();
            }

            final possibleOpponent = widget.playerColor == Squares.white
                ? data['black_player']
                : data['white_player'];

            if (possibleOpponent != null &&
                possibleOpponent.isNotEmpty &&
                waitingForOpponent) {
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
      debug.i(' Opponent has not joined yet!');
      return;
    }

    final isWhitesTurn = game.turn == 0;
    if ((isWhitesTurn && widget.playerColor == Squares.black) ||
        (!isWhitesTurn && widget.playerColor == Squares.white)) {
      debug.i(" It's not your turn!");
      return;
    }

    final moved = game.makeSquaresMove(move);
    if (moved) {
      setState(() => state = game.squaresState(widget.playerColor));

      try {
        await Supabase.instance.client
            .from('games')
            .update({'fen': game.fen}).eq('id', widget.roomId);
        debug.i("💡 _onMove: FEN updated successfully");
      } catch (e) {
        debug.i(' Error updating move: $e');
      }
    }
  }

  void _showGameResultDialog() async {
    final result = game.result;
    if (result == null) return;
    debug.i("💡 Game Result: ${result.readable}");

    final playerWon = (widget.playerColor == Squares.white &&
            result.readable.contains("White won")) ||
        (widget.playerColor == Squares.black &&
            result.readable.contains("Black won"));

    if (playerWon) {
      _confettiController.play();
      debug.i(" Confetti started for winning player");
    }

    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Game Over"),
          content: Text(result.readable),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("New Game?"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [
          ThemeSwitchButton(),
          SizedBox(width: 10,),
        ],
        leading: BackButton(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: Center(
          child: Row(
            children: [
              Text(
                widget.roomId,
                style: const TextStyle(color: accentAmber),
              ),
              IconButton(
                onPressed: () async {
                  String shareText =
                      'Join Me in this Game! Room Code: ${widget.roomId}';
                  await Share.share(shareText);
                },
                icon: Iconify(
                  Ci.copy,
                  size: 28,
                  color: Colors.grey[350],
                ),
              ),
              QrIconButton(
                roomId: widget.roomId,
              )
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: accentAmber,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //! who's Turn
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              game.turn == bishop.Bishop.white
                                  ? "White's Turn"
                                  : "Black's Turn",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //! the opponent Name
                        Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                waitingForOpponent
                                    ? Text(
                                        "Waiting for opponent to join...",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 15),
                                      )
                                    : Text(
                                        opponentName ?? '',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 16),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  child: Iconify(
                                    Bi.person_circle,
                                    size: 40,
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //!the Game
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              child: RepaintBoundary(
                                child: BoardController(
                                  animatePieces: true,
                                  labelConfig:
                                      const LabelConfig(showLabels: false),
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
                                  promotionBehaviour:
                                      PromotionBehaviour.autoPremove,
                                ),
                              ),
                            ),
                          ),
                        ),

                        //! the player Name
                        Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Iconify(
                                    Bi.person_circle,
                                    size: 40,
                                    color: Colors.grey[200],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.my_name,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showSurrenderDialog(context, () {
                                      // Close the dialog (using rootNavigator)
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      // Navigate to GameMenu
                                      // Get.offAll(() => const GameMenu());
                                    });
                                  },
                                  icon: const Icon(Icons.flag),
                                  label: const Text("Surrender"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                  icon: const Icon(Icons.replay),
                                  label: const Text("Rematch"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        numberOfParticles: 50,
                        colors: Colors.primaries,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void showSurrenderDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to surrender?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "This will end the game and your opponent will win.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      onPressed: onConfirm,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Surrender",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
