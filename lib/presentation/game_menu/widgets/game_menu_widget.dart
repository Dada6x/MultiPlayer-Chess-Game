import 'package:bounce/bounce.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameMenuWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const GameMenuWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.h,
        bottom: 5.h,
        left: isSelected ? 1 : 10.w,
        right: 5,
      ),
      child: Bounce(
        child: SizedBox(
          width: 190.w,
          child: Card(
            elevation: 5,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(45.sp)),
            color: Colors.pink,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 20.h),
                  icon,
                  SizedBox(height: 8.h),
                  Text(
                    title,
                    style: AppTextStyles.h20bold,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.h16regular,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: isSelected ? onPressed : () {},
                      child: Text(
                        "Play Now",
                        style: AppTextStyles.h16semi,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
