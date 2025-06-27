import 'package:chess_game/presentation/multi_player/creating_game.dart';
import 'package:chess_game/presentation/multi_player/join_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/la.dart';

class Boarding extends StatelessWidget {
  const Boarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Iconify(
              La.chess_bishop,
              size: 200,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => const JoinGame());
                },
                child: const Text("Join an Game ")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => const CreatingGame());
                },
                child: const Text("Create an Game  "))
          ],
        ),
      ),
    );
  }
}
