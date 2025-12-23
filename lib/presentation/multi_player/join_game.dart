import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:chess_game/presentation/multi_player/multiplayer_chess_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squares/squares.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chess_game/core/constants/colors.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  final _controller = TextEditingController();
  bool _loading = false;
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
      // Redirect to Profile page if name not set
      Get.offNamed('/profile'); // Replace with your Profile page route
      return;
    }

    setState(() {
      _playerName = name;
    });
  }

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
    if (_playerName == null || _playerName!.isEmpty) {
      Get.snackbar(
        'Name Required',
        'Please set your name in your profile first.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

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
      await Supabase.instance.client
          .from('games')
          .update({'black_player': _playerName}).eq('id', roomId);

      Get.to(() => MultiPlayerChessGame(
            my_name: _playerName!,
            roomId: roomId,
            playerColor: Squares.black,
          ));
    } else {
      setState(() => _error = 'Room ID not found');
    }
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
        title: Text(
          "Join Game",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Enter the Room ID your friend gave you:",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      onSubmitted: (_) => _onSubmit(),
                      decoration: InputDecoration(
                        hintText: "e.g. a1b2c3d4",
                        hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.5)),
                        filled: true,
                        fillColor:
                            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                        errorText: _error,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentAmber,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(color: accentAmber)
                            : Text(
                                "Join Game",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: darkCard,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: SizedBox(
                                width: 300,
                                height: 300,
                                child: MobileScanner(
                                  onDetect: (barcodes) {
                                    final code =
                                        barcodes.barcodes.first.displayValue;
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
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: accentAmber),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.qr_code, color: accentAmber),  
                        label: Text(
                          "Scan QR Code",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Tip: You can scan your friend's QR code to join quickly!",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
