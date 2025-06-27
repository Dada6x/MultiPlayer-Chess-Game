import 'package:chess_game/boarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.to(const Boarding());
                },
                child: const Text("MultiPlayer")),
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text("SinglePlayer ")),
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Options"))
          ],
        ),
      ),
    );
  }
}
