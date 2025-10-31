import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ci.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:chess_game/main.dart';
import 'package:chess_game/presentation/multi_player/multiplayer_chess_game.dart';

class CreatingGame extends StatefulWidget {
  const CreatingGame({super.key});

  @override
  State<CreatingGame> createState() => _CreatingGameState();
}

class _CreatingGameState extends State<CreatingGame> {
  String? _roomId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _createRoom();
  }

  Future<void> _createRoom() async {
    try {
      const uuid = Uuid();
      final roomId = uuid.v4().substring(0, 8);

      final newGame = bishop.Game(variant: bishop.Variant.standard());

      await Supabase.instance.client.from('games').insert(
          {'id': roomId, 'fen': newGame.fen, 'white_player': "Yahea_Create"});

      setState(() {
        _roomId = roomId;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        debug.i(_error);
        _loading = false;
      });
    }
  }

  void _startGame() {
    if (_roomId != null) {
      Get.to(() => MultiPlayerChessGame(
            my_name: "Yahea_Create",
            roomId: _roomId!,
            playerColor: Squares.white,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [ThemeSwitchButton()],
        leading: BackButton(color: Theme.of(context).colorScheme.tertiary),
        title: Text(
          "Creating an Room ",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator(
                color: accentAmber,
              )
            : _error != null
                ? Text(
                    "Error: $_error",
                    style: const TextStyle(color: Colors.red),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black54,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Invite Your Friend",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Share the Room ID below to start a multiplayer game.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectableText(
                                  _roomId!,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: accentAmber,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                IconButton(
                                  onPressed: () async {
                                    String shareText =
                                        'Join Me in this Game! Room Code: $_roomId';
                                    await Share.share(shareText);
                                  },
                                  icon: Iconify(
                                    Ci.copy,
                                    size: 28.sp,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: QrImageView(
                                data: _roomId!,
                                size: 170,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _startGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentAmber,
                                  padding: EdgeInsets.symmetric(vertical: 15.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Text(
                                  "Start Game",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
