import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Selectable square checkbox used in personalize option cards.
class PersonalizeCheckbox extends StatelessWidget {
  const PersonalizeCheckbox({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryYellow : const Color(0xFF282834),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 16,
              color: AppColors.textDark,
            )
          : null,
    );
  }
}

/// Selectable row card with leading 3D icon, title, optional subtitle, and checkbox.
class PersonalizeOptionCard extends StatelessWidget {
  const PersonalizeOptionCard({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryYellow : const Color(0xFF282832),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            PersonalizeCheckbox(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

/// Selectable 2-column grid card for training location & equipment.
class PersonalizeGridCard extends StatelessWidget {
  const PersonalizeGridCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryYellow : const Color(0xFF282832),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  iconPath,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
                PersonalizeCheckbox(isSelected: isSelected),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gender selection card with top-left radio indicator and centered badge.
class GenderOptionCard extends StatelessWidget {
  const GenderOptionCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryYellow : const Color(0xFF282832),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primaryYellow
                      : const Color(0xFF282834),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Image.asset(
              iconPath,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
