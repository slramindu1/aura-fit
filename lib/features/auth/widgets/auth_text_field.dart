import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Labeled dark text input field used across authentication screens.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.primaryYellow,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.45),
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFF17171E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF282832)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryYellow),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    icon: Image.asset(
                      AppAssets.eyeLineIcon,
                      width: 20,
                      height: 20,
                      color: AppColors.textPrimary.withValues(
                        alpha: _obscureText ? 0.9 : 0.5,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
