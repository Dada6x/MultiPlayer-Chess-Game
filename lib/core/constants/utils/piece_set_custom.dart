import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

class PieceSetCustom {
  static const List<String> extendedSymbols = [
    'P',
    'N',
    'B',
    'R',
    'Q',
    'K',
    'A',
    'C',
    'H',
    'E',
    'S',
    'X',
  ];

  static PieceSet fine() => PieceSet.fromImageAssets(
        folder: 'assets/fine/',
        symbols: extendedSymbols,
      );

  static PieceSet cyber() {
    Map<String, String> symbols = {
      'P': '♙',
      'p': '♟',
      'N': '♘',
      'n': '♞',
      'B': '♗',
      'b': '♝',
      'R': '♖',
      'r': '♜',
      'Q': '♕',
      'q': '♛',
      'K': '♔',
      'k': '♚',
    };
    return PieceSet(pieces: {
      for (var entry in symbols.entries)
        entry.key: (context) => Text(
              entry.value,
              style: TextStyle(
                fontSize: 32,
                color: entry.key == entry.key.toUpperCase()
                    ? Colors.cyanAccent
                    : Colors.pinkAccent,
              ),
            )
    });
  }
}
