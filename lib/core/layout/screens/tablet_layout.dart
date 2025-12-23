import 'package:chess_game/presentation/game_menu/game_menu.dart';
import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: GameMenu(
      ),
    );
  }
}
