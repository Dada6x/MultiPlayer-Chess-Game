import 'package:chess_game/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrIconButton extends StatelessWidget {
  final String roomId;

  const QrIconButton({super.key, required this.roomId});

  void _showQrBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Share this with your friend",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              QrImageView(
                data: roomId,
                version: QrVersions.auto,
                size: 250.w,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accentAmber),
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showQrBottomSheet(context),
      icon: Icon(
        Icons.qr_code_2_rounded,
        color: Colors.grey[350],
      ),
      iconSize: 30,
      color: Theme.of(context).colorScheme.primary,
      tooltip: "Show QR Code",
    );
  }
}
