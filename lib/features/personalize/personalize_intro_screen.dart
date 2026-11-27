import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import 'personalize_flow_screen.dart';
import 'widgets/personalize_scaffold.dart';

/// Intro screen before the 7-step personalization questionnaire.
class PersonalizeIntroScreen extends StatelessWidget {
  const PersonalizeIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonalizeScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              AppAssets.personalizeBadge,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            const Text(
              'Let’s build something personal.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Answer a few quick questions, and your AI coach will design your program.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.78),
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const Spacer(flex: 3),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PersonalizeFlowScreen(),
                  ),
                );
              },
              child: const Text('Lets Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
