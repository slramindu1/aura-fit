import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_success_screen.dart';
import 'widgets/personalize_scaffold.dart';

/// Notification permission prompt shown after the 7-step questionnaire.
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  void _finish(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AuthSuccessScreen.personalizeComplete(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersonalizeScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              AppAssets.reminderBadge,
              width: 108,
              height: 108,
            ),
            const SizedBox(height: 24),
            const Text(
              'Would you like gentle reminders?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We can send you soft check , to support your daily well-being.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.78),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const Spacer(flex: 3),
            PersonalizeBottomButtons(
              secondaryLabel: 'Not Now',
              primaryLabel: 'Allow Notification',
              onSecondaryPressed: () => _finish(context),
              onPrimaryPressed: () => _finish(context),
            ),
          ],
        ),
      ),
    );
  }
}
