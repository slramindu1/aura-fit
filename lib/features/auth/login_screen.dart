import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../personalize/personalize_intro_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_top_bar.dart';
import 'widgets/social_auth_button.dart';

/// Email/password & social login screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _staySignedIn = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    if (email.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please enter your email and password');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const PersonalizeIntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTopBar(
                actionLabel: 'Register',
                onActionTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Login',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                label: 'Email',
                hintText: 'samporter@gmail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              AuthTextField(
                label: 'Password',
                hintText: '••••••••••••',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() => _staySignedIn = !_staySignedIn);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _staySignedIn
                                ? AppColors.primaryYellow
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _staySignedIn
                                  ? AppColors.primaryYellow
                                  : const Color(0xFF4B4B57),
                              width: 1.5,
                            ),
                          ),
                          child: _staySignedIn
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: AppColors.textDark,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Stay signed in',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: _onLogin,
                child: const Text('Log in'),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFF282832), thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Color(0xFF282832), thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SocialAuthButton(
                iconPath: AppAssets.googleIcon,
                label: 'Continue With Google',
                onPressed: () => _showMessage('Continue With Google selected'),
              ),
              const SizedBox(height: 12),
              SocialAuthButton(
                iconPath: AppAssets.appleIcon,
                label: 'Continue With Apple',
                onPressed: () => _showMessage('Continue With Apple selected'),
              ),
              const SizedBox(height: 12),
              SocialAuthButton(
                iconPath: AppAssets.facebookIcon,
                label: 'Continue With Facebook',
                onPressed: () =>
                    _showMessage('Continue With Facebook selected'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
