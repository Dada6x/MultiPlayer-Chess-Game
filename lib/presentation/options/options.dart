import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chess_game/core/constants/colors.dart'; // darkBackground, darkCard, accentAmber

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text(
          "Game Options",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: darkCard,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionCard(
              title: "Board Theme",
              child: ElevatedButton(
                onPressed: () {
                  // TODO: implement change board theme
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  "Change Board Theme",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              title: "Piece Style",
              child: ElevatedButton(
                onPressed: () {
                  // TODO: implement change piece style
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  "Change Piece Style",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              title: "Sounds",
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: accentAmber,
                title: Text(
                  "Enable Sounds",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
                value: true,
                onChanged: (value) {
                  // TODO: implement toggle sounds
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to create a dark card for each option
  Widget _buildOptionCard({required String title, required Widget child}) {
    return Card(
      color: darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }
}
