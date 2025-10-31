import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class BoardThemeCustom {
  static BoardTheme fine = const BoardTheme(
    lightSquare: Color(0xFFE8EDF9),
    darkSquare: Color(0xFFB7C0D8),
    check: Color(0xFFFF3CAC),
    checkmate: Colors.red,
    previous: Color(0xFFB1A5EC),
    selected: Color(0xFFB1A6FC),
    premove: Color(0x6600FFFF),
  );
}
