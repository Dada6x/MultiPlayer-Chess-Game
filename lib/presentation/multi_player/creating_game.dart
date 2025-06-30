import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/presentation/multi_player/multiplayer_chess_game.dart';
import 'package:chess_game/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ci.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

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

      await Supabase.instance.client.from('games').insert({
        'id': roomId,
        'fen': newGame.fen,
        'white_player':"Yahea_Create"
      });

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a Room')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _loading
              ? const CircularProgressIndicator()
              : _error != null
                  ? Text("Error: $_error")
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Send this Room ID to Your Friend:"),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              _roomId!,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Iconify(
                                  Ci.copy,
                                  size: 29.sp,
                                  color: grey,
                                ))
                          ],
                        ),
                        const SizedBox(height: 20),
                        QrImageView(
                          backgroundColor: white,
                          // embeddedImage: AssetImage(""),
                          data: _roomId!,
                          size: 150,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _startGame,
                          child: const Text("Start Game"),
                        ),
                        
                      ],
                    ),
        ),
      ),
    );
  }
}
