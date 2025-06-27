import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GameMenu> {
  int currentIndex = 0;

  final List<Widget> optionWidgets = [
    const MultiplayerWidget(),
    const SingleplayerWidget(),
    const OptionsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Be The \nking Of \nChess",
                style: AppTextStyles.h32semi,
              ),
              const SizedBox(
                height: 200,
              ),
              optionWidgets[currentIndex],
            ],
          )),
          SizedBox(
            height: 680,
            width: 185,
            child: Swiper(
              scrollDirection: Axis.vertical,
              itemCount: 3,
              onIndexChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                double angle = 0;
                int total = optionWidgets.length;
                int prevIndex = (currentIndex - 1 + total) % total;
                int nextIndex = (currentIndex + 1) % total;
                if (index == currentIndex) {
                  angle = 0;
                } else if (index == prevIndex) {
                  angle = 13.5 * pi / 180;
                } else if (index == nextIndex) {
                  angle = -13.5 * pi / 180;
                } else {
                  return const SizedBox.shrink();
                }

                return AnimatedRotation(
                  turns: angle / (2 * pi),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: Colors.pink,
                      child: Center(
                        child: Text(
                          'Option ${index + 1}',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
              viewportFraction: 0.38,
              scale: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class MultiplayerWidget extends StatelessWidget {
  const MultiplayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Multiplayer Widget'));
  }
}

class SingleplayerWidget extends StatelessWidget {
  const SingleplayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Singleplayer Widget'));
  }
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Options Widget'));
  }
}
