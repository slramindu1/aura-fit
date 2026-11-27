import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Shared dark scaffold with the subtle dumbbell pattern backdrop.
class PersonalizeScaffold extends StatelessWidget {
  const PersonalizeScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF282828),
            colorBlendMode: BlendMode.srcIn,
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

/// Shared two-button bottom action row (secondary white + primary yellow).
class PersonalizeBottomButtons extends StatelessWidget {
  const PersonalizeBottomButtons({
    super.key,
    required this.secondaryLabel,
    required this.primaryLabel,
    required this.onSecondaryPressed,
    required this.onPrimaryPressed,
  });

  final String secondaryLabel;
  final String primaryLabel;
  final VoidCallback onSecondaryPressed;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onSecondaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.textDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                secondaryLabel,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onPrimaryPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.textDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                primaryLabel,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
