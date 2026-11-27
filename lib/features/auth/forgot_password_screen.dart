import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'otp_verification_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_top_bar.dart';

/// Password recovery screen requesting user email to send an OTP code.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendCode() {
    final email = _emailController.text.trim();
    final targetEmail = email.isEmpty ? 'samporter@gmail.com' : email;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OtpVerificationScreen(
          email: targetEmail,
          flow: OtpFlow.forgotPassword,
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
              const AuthTopBar(),
              const SizedBox(height: 28),
              const Text(
                'Forgot Password?',
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
                onPressed: _onSendCode,
                child: const Text('Send Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
