import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_top_bar.dart';

/// Email registration screen that initiates 5-digit OTP verification.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final email = _emailController.text.trim();
    final targetEmail = email.isEmpty ? 'samporter@gmail.com' : email;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OtpVerificationScreen(
          email: targetEmail,
          flow: OtpFlow.register,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTopBar(
                actionLabel: 'Login',
                onActionTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Register',
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
              const Spacer(),
              ElevatedButton(
                onPressed: _onRegister,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
