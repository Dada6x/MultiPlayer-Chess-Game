import 'package:chess_game/core/app/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      return IconButton(
        icon: Icon(
          appController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => appController.toggleTheme(),
        tooltip: appController.isDarkMode.value
            ? 'Switch to Light Mode'
            : 'Switch to Dark Mode',
      );
    });
  }
}
