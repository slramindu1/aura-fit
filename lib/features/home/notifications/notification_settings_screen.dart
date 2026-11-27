import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/auth_top_bar.dart';

/// Notification preferences screen with 7 toggleable alert categories.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final List<({String title, bool enabled})> _items = [
    (title: 'Training Reminders', enabled: true),
    (title: 'Streak Alerts', enabled: true),
    (title: 'AI Coach Insights', enabled: false),
    (title: 'Progress & PR Updates', enabled: false),
    (title: 'Challenges & Achievements', enabled: false),
    (title: 'Recovery Recommendations', enabled: true),
    (title: 'New Programs & Features', enabled: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
                    'Notification Settings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF17171E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF282832)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: item.enabled,
                            onChanged: (value) {
                              setState(() {
                                _items[index] = (
                                  title: item.title,
                                  enabled: value,
                                );
                              });
                            },
                            activeThumbColor: AppColors.white,
                            activeTrackColor: AppColors.primaryYellow,
                            inactiveThumbColor: AppColors.white,
                            inactiveTrackColor: const Color(0xFF2E2E38),
                            trackOutlineColor: const WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
