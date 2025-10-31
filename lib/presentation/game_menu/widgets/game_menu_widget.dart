import 'package:chess_game/core/constants/colors.dart';
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
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
      child: SizedBox(
        width: 200.w,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon in a circular container
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: icon,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: AppTextStyles.h20bold.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: AppTextStyles.h16regular.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSelected ? onPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentAmber,
                      foregroundColor: darkBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
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
    );
  }
}
