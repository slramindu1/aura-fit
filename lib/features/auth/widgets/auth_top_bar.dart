import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Top navigation bar for auth screens with a back button and optional action pill.
class AuthTopBar extends StatelessWidget {
  const AuthTopBar({
    super.key,
    this.actionLabel,
    this.onActionTap,
    this.onBackTap,
  });

  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF17171E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF282832)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppAssets.arrowLeftIcon,
              width: 16,
              height: 16,
              color: AppColors.textPrimary,
              errorBuilder: (_, _, _) => const Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
        if (actionLabel != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF17171E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF282832)),
              ),
              alignment: Alignment.center,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
