import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_game/presentation/options/Profile.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
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
  String? _playerName;

  @override
  void initState() {
    super.initState();
    _loadPlayerName();
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('player_name');

    if (name == null || name.isEmpty) {
      // Redirect to Profile page if name is not set
      Get.off(() => const ProfilePage());
      return;
    }

    setState(() {
      _playerName = name;
    });

    _createRoom();
  }

  Future<void> _createRoom() async {
    if (_playerName == null || _playerName!.isEmpty) return;

    try {
      const uuid = Uuid();
      final roomId = uuid.v4().substring(0, 8);

      final newGame = bishop.Game(variant: bishop.Variant.standard());

      await Supabase.instance.client.from('games').insert(
          {'id': roomId, 'fen': newGame.fen, 'white_player': _playerName});

      setState(() {
        _roomId = roomId;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startGame() {
    if (_roomId != null && _playerName != null && _playerName!.isNotEmpty) {
      Get.to(() => MultiPlayerChessGame(
            my_name: _playerName!,
            roomId: _roomId!,
            playerColor: Squares.white,
          ));
    } else {
      Get.snackbar(
        'Name Required',
        'Please set your name in your profile first.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
          "Creating a Room",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator(color: accentAmber)
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
                                  _roomId ?? '',
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: accentAmber,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                IconButton(
                                  onPressed: () async {
                                    if (_roomId != null) {
                                      String shareText =
                                          'Join Me in this Game! Room Code: $_roomId';
                                      await Share.share(shareText);
                                    }
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
                            if (_roomId != null)
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
