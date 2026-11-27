import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_welcome_screen.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../home/notifications/notification_settings_screen.dart';
import 'personal_info_screen.dart';

/// Settings screen with Pro upgrade card and account preference items.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showPlaceholder(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label selected'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              const Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTopBar(),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF242424)),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.profileGymProduct,
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unlock Your Full Potential',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upgrade to Pro and access advanced insights, AI adjustments, and exclusive programs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () =>
                          _showPlaceholder(context, 'Upgrade to Pro'),
                      child: const Text('Upgrade Now'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SettingsRow(
                iconPath: AppAssets.profilePersonalInfo,
                label: 'Personal Information',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PersonalInfoScreen(),
                    ),
                  );
                },
              ),
              _SettingsRow(
                iconPath: AppAssets.profileSecurity,
                label: 'Login & Security',
                onTap: () => _showPlaceholder(context, 'Login & Security'),
              ),
              _SettingsRow(
                iconPath: AppAssets.profilePrivacy,
                label: 'Privacy',
                onTap: () => _showPlaceholder(context, 'Privacy'),
              ),
              _SettingsRow(
                iconPath: AppAssets.profileNotifications,
                label: 'Notifications',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
              _SettingsRow(
                iconPath: AppAssets.profileLanguage,
                label: 'Languages',
                onTap: () => _showPlaceholder(context, 'Languages'),
              ),
              _SettingsRow(
                iconPath: AppAssets.profileAccessibility,
                label: 'Accessibility',
                onTap: () => _showPlaceholder(context, 'Accessibility'),
              ),
              _SettingsRow(
                iconPath: AppAssets.profileLogout,
                label: 'Logout',
                isDestructive: true,
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const AuthWelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? const Color(0xFFEF4444) : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: color,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDestructive
                  ? const Color(0xFFEF4444)
                  : AppColors.textSecondary.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}
