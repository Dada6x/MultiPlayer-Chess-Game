import 'package:chess_game/presentation/multi_player/multiplayer_chess_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<bool> _checkRoomExists(String roomId) async {
    try {
      final data = await Supabase.instance.client
          .from('games')
          .select()
          .eq('id', roomId)
          .maybeSingle();

      return data != null;
    } catch (e) {
      setState(() => _error = 'Error: $e');
      return false;
    }
  }

  void _onSubmit() async {
    final roomId = _controller.text.trim();

    if (roomId.isEmpty) {
      setState(() => _error = 'Please enter a Room ID');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final exists = await _checkRoomExists(roomId);

    setState(() => _loading = false);

    if (exists) {
      Get.to(() => MultiPlayerChessGame(
            roomId: roomId,
            playerColor: Squares.black,
          ));
    } else {
      setState(() => _error = 'Room ID not found');
    }
  }

// ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Game")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Enter the Room ID your friend gave you:"),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              onSubmitted: (_) => _onSubmit(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "e.g. a1b2c3d4",
                errorText: _error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _onSubmit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Join Game"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      width: 300,
                      height: 300,
                      child: MobileScanner(
                        onDetect: (barcodes) {
                          final code = barcodes.barcodes.first.displayValue;
                          if (code != null) {
                            Navigator.pop(context);
                            _controller.text = code.toString();
                            _onSubmit();
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
              child: const Text("Scan QR Code"),
            ),
          ]),
        ),
      ),
    );
  }
}
