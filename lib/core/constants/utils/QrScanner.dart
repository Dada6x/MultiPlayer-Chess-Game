import 'package:chess_game/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrIconButton extends StatelessWidget {
  final String roomId;

  const QrIconButton({super.key, required this.roomId});

  void _showQrBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Share this with your friend",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: roomId,
                version: QrVersions.auto,
                size: 250,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 20),
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
