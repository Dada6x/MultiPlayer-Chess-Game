import 'package:chess_game/core/constants/colors.dart';
import 'package:chess_game/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: SizedBox(
        width: 200,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: icon,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: AppTextStyles.h20bold.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: AppTextStyles.h16regular.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSelected ? onPressed : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentAmber,
                              foregroundColor: darkBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
