import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'auth_success_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_top_bar.dart';

/// Password reset screen with live strength meter and match validation.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  int _computeStrength(String value) {
    if (value.isEmpty) return 0;
    var score = 1;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[0-9]').hasMatch(value)) {
      score++;
    }
    if (value.length >= 12 || RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      score++;
    }
    return score.clamp(0, 4);
  }

  String _strengthLabel(int score) {
    switch (score) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Strong';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Color _strengthColor(int score) {
    if (score >= 3) return const Color(0xFF22C55E);
    if (score == 2) return AppColors.primaryYellow;
    return const Color(0xFFEF4444);
  }

  void _onConfirm() {
    final pass = _passwordController.text;
    final confirm = _confirmController.text;
    if (pass.isEmpty || pass != confirm) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please ensure both passwords match'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AuthSuccessScreen.passwordUpdated(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final strength = _computeStrength(password);
    final strengthColor = _strengthColor(strength);
    final passwordsMatch = password.isNotEmpty && password == confirm;
    final showMismatch = confirm.isNotEmpty && password != confirm;

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
                'Reset your password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                label: 'Enter New Password',
                hintText: 'Enter new password',
                controller: _passwordController,
                isPassword: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              if (passwordsMatch)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _MatchStatusRow(isMatch: true),
                ),
              Row(
                children: List.generate(4, (index) {
                  final active = index < strength;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index < 3 ? 6 : 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 3,
                        decoration: BoxDecoration(
                          color: active
                              ? strengthColor
                              : const Color(0xFF3A3A44),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fill your new password',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.65),
                      fontSize: 12,
                    ),
                  ),
                  if (strength > 0)
                    Text(
                      _strengthLabel(strength),
                      style: TextStyle(
                        color: strengthColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: 'Re - Enter Password',
                hintText: 'Re-enter password',
                controller: _confirmController,
                isPassword: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              if (passwordsMatch || showMismatch)
                _MatchStatusRow(isMatch: passwordsMatch),
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

class _MatchStatusRow extends StatelessWidget {
  const _MatchStatusRow({required this.isMatch});

  final bool isMatch;

  @override
  Widget build(BuildContext context) {
    final color = isMatch ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Row(
      children: [
        Icon(
          isMatch ? Icons.check_circle_outline : Icons.error_outline,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          isMatch ? 'Password Match' : 'Passwords do not match',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
