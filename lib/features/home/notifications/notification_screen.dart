import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/auth_top_bar.dart';
import 'notification_settings_screen.dart';

class _NotificationEntry {
  const _NotificationEntry({
    required this.section,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.timeTop,
    this.timeBottom,
  });

  final String section;
  final String iconPath;
  final String title;
  final String subtitle;
  final String timeTop;
  final String? timeBottom;
}

/// Notifications feed screen supporting both populated and empty states.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
    this.isEmpty = false,
  });

  final bool isEmpty;

  static const List<_NotificationEntry> _entries = [
    _NotificationEntry(
      section: 'Today',
      iconPath: AppAssets.notifClock,
      title: 'Time to train.',
      subtitle: 'Your Upper Body session is waiting.\nLet’s move.',
      timeTop: '1h ago',
    ),
    _NotificationEntry(
      section: 'Today',
      iconPath: AppAssets.notifDumbbell,
      title: 'It’s Push Day.',
      subtitle: 'Ready to improve your form and add\n+2.5kg today?',
      timeTop: '4h ago',
    ),
    _NotificationEntry(
      section: 'Today',
      iconPath: AppAssets.notifFlame,
      title: '🔥 5-Day Streak!',
      subtitle: 'Consistency is becoming your\nidentity.',
      timeTop: '12h ago',
    ),
    _NotificationEntry(
      section: 'Yesterday',
      iconPath: AppAssets.notifChart,
      title: '🔥 Strength Level Up.',
      subtitle: 'You just outperformed last week.',
      timeTop: 'Saturday',
      timeBottom: '21.12',
    ),
    _NotificationEntry(
      section: 'Yesterday',
      iconPath: AppAssets.notifChart,
      title: 'New PR Unlocked!',
      subtitle: 'Bench Press +5kg. That’s progress.',
      timeTop: 'Saturday',
      timeBottom: '12.44',
    ),
    _NotificationEntry(
      section: 'Last Week',
      iconPath: AppAssets.notifChart,
      title: '🎯 Form Improvement +8%',
      subtitle: 'Your elbow alignment is better today.',
      timeTop: 'Saturday',
      timeBottom: '13.33',
    ),
    _NotificationEntry(
      section: 'Last Week',
      iconPath: AppAssets.notifTorso,
      title: 'You haven’t trained in 3 days.',
      subtitle: 'Let’s get back on track with a quick session.',
      timeTop: 'Saturday',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = ['Today', 'Yesterday', 'Last Week'];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthTopBar(),
                  const Text(
                    'Notification',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF17171E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF282832)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        AppAssets.notificationSettings,
                        width: 20,
                        height: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppAssets.notification3d,
                                width: 108,
                                height: 108,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No notifications yet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'When there’s something important,\nyou’ll see it here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.72,
                                  ),
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          for (final section in sections) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 14),
                              child: Text(
                                section,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ..._entries
                                .where((e) => e.section == section)
                                .map(_NotificationRow.new),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow(this.entry);

  final _NotificationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              entry.iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.72),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.timeTop,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
              ),
              if (entry.timeBottom != null) ...[
                const SizedBox(height: 6),
                Text(
                  entry.timeBottom!,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
