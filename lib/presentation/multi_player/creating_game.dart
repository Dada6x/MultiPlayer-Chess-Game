import 'package:chess_game/presentation/multi_player/multiplayer_chess_game.dart';
import 'package:chess_game/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bishop/bishop.dart' as bishop;

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
            roomId: _roomId!,
            playerColor: Squares.white,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Game')),
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
                        SelectableText(
                          _roomId!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _startGame,
                          child: const Text("Start Game"),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}
