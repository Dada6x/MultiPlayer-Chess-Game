import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/la.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/whh.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:chess_game/presentation/game_menu/widgets/game_menu_widget.dart';
import 'package:chess_game/presentation/multi_player/boarding.dart';
import 'package:chess_game/presentation/options/options.dart';
import 'package:chess_game/presentation/single_player/singleplayer_chess_game.dart';

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

  bool isScrollingDown = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.w), // Responsive padding
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    "Be The \nking Of \nChess ",
                    style: AppTextStyles.h32semi.copyWith(fontSize: 32.sp),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 250.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    layoutBuilder: (currentChild, previousChildren) =>
                        currentChild!,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: isScrollingDown
                            ? const Offset(0, 1)
                            : const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                    child: KeyedSubtree(
                      key: ValueKey(currentIndex),
                      child: optionWidgets[currentIndex],
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: IconButton(
                        onPressed: () {},
                        icon: Iconify(
                          color: grey,
                          La.chess_queen,
                          size: 29.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: double.infinity,
              width: 235.w,
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
                  int total = 3;
                  int prevIndex = (currentIndex - 1 + total) % total;
                  int nextIndex = (currentIndex + 1) % total;

                  if (index == currentIndex) {
                    angle = 0;
                  } else if (index == prevIndex) {
                    angle = 1.5 * pi / 180;
                  } else if (index == nextIndex) {
                    angle = -1.5 * pi / 180;
                  } else {
                    return const SizedBox.shrink();
                  }

                  // Provide unique content and actions per index
                  late final String title;
                  late final String subtitle;
                  late final Iconify icon;
                  late final VoidCallback onPressed;

                  if (index == 0) {
                    title = "Play Multi Player";
                    subtitle = "Invite Your Friends and start playing ";
                    icon = Iconify(Whh.friends, size: 40.sp);
                    onPressed = () {
                      Get.to(const Boarding());
                    };
                  } else if (index == 1) {
                    title = "Play Single Player";
                    subtitle = "Challenge the AI bot and improve your skills";
                    icon = Iconify(Mdi.robot_excited_outline, size: 40.sp);
                    onPressed = () {
                      Get.to(const SinglePlayerChessGame());
                    };
                  } else {
                    title = "Game Options";
                    subtitle = "Customize board, theme, and settings";
                    icon = Iconify(Mi.settings, size: 40.sp);
                    onPressed = () {
                      Get.to(const Options());
                    };
                  }

                  return Transform.rotate(
                    angle: angle,
                    child: GameMenuWidget(
                      isSelected: index == currentIndex,
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                      onPressed: onPressed,
                    ),
                  );
                },
                viewportFraction: 0.339,
                scale: 0.71,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiplayerWidget extends StatelessWidget {
  const MultiplayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.amber,
        child: Container(
          height: 200,
          width: 100,
          child: Text(
            'Multiplayer Widget',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
      ),
    );
  }
}

class SingleplayerWidget extends StatelessWidget {
  const SingleplayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Singleplayer Widget',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Options Widget',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }
}
