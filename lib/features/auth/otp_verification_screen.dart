import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import 'auth_success_screen.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';
import 'widgets/auth_top_bar.dart';

/// Determines where [OtpVerificationScreen] navigates after confirmation.
enum OtpFlow { register, forgotPassword }

/// 5-digit OTP verification screen shared by registration and password reset.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.flow,
  });

  final String email;
  final OtpFlow flow;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 5;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onResend() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Verification code resent to ${widget.email}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _onConfirm() {
    final Widget nextScreen = widget.flow == OtpFlow.register
        ? const AuthSuccessScreen.emailVerified()
        : const ResetPasswordScreen();

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => nextScreen),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Enter OTP Code',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We’ve sent a 5 -digit verification code to',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.78),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.email,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: List.generate(_otpLength, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < _otpLength - 1 ? 12 : 0,
                      ),
                      child: SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]'),
                            ),
                          ],
                          onChanged: (value) => _onDigitChanged(index, value),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          cursorColor: AppColors.primaryYellow,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFF17171E),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF282832),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryYellow,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: _onResend,
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        color: AppColors.primaryYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onConfirm,
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
