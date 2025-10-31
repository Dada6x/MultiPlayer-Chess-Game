import 'package:animations/animations.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:chess_game/presentation/about_us/AboutUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/la.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/whh.dart';
import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:chess_game/presentation/game_menu/widgets/game_menu_widget.dart';
import 'package:chess_game/presentation/multi_player/boarding.dart';
import 'package:chess_game/presentation/options/options.dart';
import 'package:chess_game/presentation/single_player/singleplayer_chess_game.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  int currentIndex = 0;
  bool isScrollingDown = true;

  final List<Widget> optionWidgets = const [
    ImageWidget(imagePath: "assets/images/chess.png"),
    ImageWidget(
        imagePath:
            "assets/images/vecteezy_black-queen-chess-piece-3d_45686418.png"),
    ImageWidget(imagePath: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    "Be The \nking Of \nChess ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 28),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 100.h),
                  // Keep the animated transition here:
                  Expanded(
                    child: PageTransitionSwitcher(
                      transitionBuilder: (
                        Widget child,
                        Animation<double> primaryAnimation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: white,
                          child: child,
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(currentIndex),
                        child: optionWidgets[currentIndex],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(() => const AboutUsPage());
                            },
                            icon: Iconify(
                              color: Theme.of(context).colorScheme.primary,
                              La.chess_queen,
                              size: 29.sp,
                            ),
                          ),
                          //! theme Switching button
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Iconify(
                          //     color: white,
                          //     La.sun,
                          //     size: 29.sp,
                          //   ),
                          // ),
                          const ThemeSwitchButton()
                        ],
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
                itemCount: optionWidgets.length,
                onIndexChanged: (index) {
                  setState(() {
                    isScrollingDown = index > currentIndex ||
                        (index == 0 &&
                            currentIndex == optionWidgets.length - 1);
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  late final String title;
                  late final String subtitle;
                  late final Iconify icon;
                  late final VoidCallback onPressed;

                  if (index == 0) {
                    title = "Play Multi Player";
                    subtitle = "Invite Your Friends and start playing";
                    icon =  Iconify(
                      Whh.friends,
                      size: 40,
                      color: Theme.of(context).cardColor,
                    );
                    onPressed = () {
                      Get.to(const Boarding());
                    };
                  } else if (index == 1) {
                    title = "Play Single Player";
                    subtitle = "Challenge the AI bot and improve your skills";
                    icon =  Iconify(
                      Mdi.robot_excited_outline,
                      size: 40,
                      color: Theme.of(context).cardColor,
                    );
                    onPressed = () {
                      Get.to(const SinglePlayerChessGame());
                    };
                  } else {
                    title = "Game Options";
                    subtitle = "Customize board, theme, and settings";
                    icon = Iconify(
                      Mi.settings,
                      size: 40,
                      color: Theme.of(context).cardColor,
                    );
                    onPressed = () {
                      Get.to(const Options());
                    };
                  }
                  return AnimatedScale(
                    scale: index == currentIndex ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 200),
                    child: GameMenuWidget(
                      isSelected: index == currentIndex,
                      title: title,
                      subtitle: subtitle,
                      icon: icon,
                      onPressed: onPressed,
                    ),
                  );
                },
                viewportFraction: 0.35,
                scale: 0.9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String imagePath;
  const ImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
