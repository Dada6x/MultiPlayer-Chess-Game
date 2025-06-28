import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Game Options",
          style: TextStyle(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Board Theme",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {
                // TODO: implement change board theme
              },
              child:
                  Text("Change Board Theme", style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 24.h),
            Text(
              "Piece Style",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {
                // TODO: implement change piece style
              },
              child:
                  Text("Change Piece Style", style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 24.h),
            Text(
              "Sounds",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text("Enable Sounds", style: TextStyle(fontSize: 16.sp)),
              value: true,
              onChanged: (value) {
                // TODO: implement toggle sounds
              },
            ),
          ],
        ),
      ),
    );
  }
}
