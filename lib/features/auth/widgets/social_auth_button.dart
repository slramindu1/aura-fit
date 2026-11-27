import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Full-width white button with leading provider icon used for auth options.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onPressed,
  });

  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
