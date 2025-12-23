import 'package:chess_game/presentation/game_menu/game_menu.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1170,
        maxHeight: 2532,
      ),
   
      child: const GameMenu(),
    );
  }
}
