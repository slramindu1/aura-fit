import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../home/main_shell_screen.dart';
import '../personalize/personalize_intro_screen.dart';
import 'login_screen.dart';

/// Destination after tapping the CTA on [AuthSuccessScreen].
enum SuccessNextRoute { login, personalize, explore }

/// Reusable confirmation screen for auth and personalization completion.
class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    this.nextRouteType = SuccessNextRoute.login,
  });

  const AuthSuccessScreen.emailVerified({super.key})
      : title = 'Email verified',
        subtitle =
            'Your email has been successfully verified. You can now continue to your account.',
        buttonLabel = 'Continue',
        nextRouteType = SuccessNextRoute.personalize;

  const AuthSuccessScreen.passwordUpdated({super.key})
      : title = 'Password updated',
        subtitle =
            'Your password has been successfully reset. You can now sign in with your new password.',
        buttonLabel = 'Explore Now',
        nextRouteType = SuccessNextRoute.login;

  const AuthSuccessScreen.personalizeComplete({super.key})
      : title = 'You’re all set',
        subtitle =
            'We’ll personalize your experience based on what you shared.',
        buttonLabel = 'Explore Now',
        nextRouteType = SuccessNextRoute.explore;

  final String title;
  final String subtitle;
  final String buttonLabel;
  final SuccessNextRoute nextRouteType;

  void _handleContinue(BuildContext context) {
    switch (nextRouteType) {
      case SuccessNextRoute.personalize:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => const PersonalizeIntroScreen(),
          ),
          (route) => route.isFirst,
        );
      case SuccessNextRoute.login:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => const LoginScreen(),
          ),
          (route) => route.isFirst,
        );
      case SuccessNextRoute.explore:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => const MainShellScreen(),
          ),
          (route) => false,
        );
    }
  }

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Image.asset(
                    AppAssets.successBadge,
                    width: 108,
                    height: 108,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.78),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const Spacer(flex: 3),
                  ElevatedButton(
                    onPressed: () => _handleContinue(context),
                    child: Text(buttonLabel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

