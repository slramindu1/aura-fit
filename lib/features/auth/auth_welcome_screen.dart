import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import 'login_screen.dart';
import 'widgets/social_auth_button.dart';

/// Authentication landing screen with social & email sign-in options.
class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  void _onAuthMethodTap(BuildContext context, String method) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$method selected'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.onboarding4,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.55, 1.0],
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.72),
                  Colors.black.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Image.asset(
                    AppAssets.logo,
                    width: 84,
                    height: 84,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'THIS IS YOUR\nNEXT LEVEL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SocialAuthButton(
                    iconPath: AppAssets.googleIcon,
                    label: 'Continue With Google',
                    onPressed: () =>
                        _onAuthMethodTap(context, 'Continue With Google'),
                  ),
                  const SizedBox(height: 12),
                  SocialAuthButton(
                    iconPath: AppAssets.appleIcon,
                    label: 'Continue With Apple',
                    onPressed: () =>
                        _onAuthMethodTap(context, 'Continue With Apple'),
                  ),
                  const SizedBox(height: 12),
                  SocialAuthButton(
                    iconPath: AppAssets.facebookIcon,
                    label: 'Continue With Facebook',
                    onPressed: () =>
                        _onAuthMethodTap(context, 'Continue With Facebook'),
                  ),
                  const SizedBox(height: 12),
                  SocialAuthButton(
                    iconPath: AppAssets.emailIcon,
                    label: 'Continue With Email',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.45,
                      ),
                      children: const [
                        TextSpan(text: 'By Continuing you agree to our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(text: ' &\n'),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
