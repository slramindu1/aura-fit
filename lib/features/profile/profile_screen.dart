import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import 'settings_screen.dart';

class _CompletedWorkoutEntry {
  const _CompletedWorkoutEntry({
    required this.title,
    required this.imagePath,
    required this.dateText,
    required this.durationText,
    required this.caloriesText,
  });

  final String title;
  final String imagePath;
  final String dateText;
  final String durationText;
  final String caloriesText;
}

class _BadgeEntry {
  const _BadgeEntry({
    required this.title,
    required this.imagePath,
    this.isUnlocked = true,
  });

  final String title;
  final String imagePath;
  final bool isUnlocked;
}

/// Profile tab screen with Workouts history, Badges progress, and Settings access.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.isEmpty = false,
    this.onBrowseWorkouts,
  });

  final bool isEmpty;
  final VoidCallback? onBrowseWorkouts;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<String> _months = [
    'February 2026',
    'January 2026',
    'December 2025',
  ];

  static const List<_CompletedWorkoutEntry> _history = [
    _CompletedWorkoutEntry(
      title: 'Push Day',
      imagePath: AppAssets.searchResultPushDay,
      dateText: 'Feb 26, 2026 • 19:18 PM',
      durationText: '1h 10m completed',
      caloriesText: '418 kcal burned',
    ),
    _CompletedWorkoutEntry(
      title: 'Lower Body Power',
      imagePath: AppAssets.workout2,
      dateText: 'Feb 22, 2026 • 17:36 PM',
      durationText: '53 min completed',
      caloriesText: '352 kcal burned',
    ),
    _CompletedWorkoutEntry(
      title: 'Leg Day',
      imagePath: AppAssets.historyLegDay,
      dateText: 'Feb 18, 2026 • 07:05 AM',
      durationText: '46 min completed',
      caloriesText: '325 kcal burned',
    ),
    _CompletedWorkoutEntry(
      title: 'Chest Day',
      imagePath: AppAssets.historyChestDay,
      dateText: 'Feb 14, 2026 • 18:12 PM',
      durationText: '51 min completed',
      caloriesText: '395 kcal burned',
    ),
    _CompletedWorkoutEntry(
      title: 'Back Day',
      imagePath: AppAssets.historyBackDay,
      dateText: 'Feb 10, 2026 • 06:58 AM',
      durationText: '48 min completed',
      caloriesText: '360 kcal burned',
    ),
  ];

  static const List<_BadgeEntry> _badges = [
    _BadgeEntry(title: 'First Rep', imagePath: AppAssets.badge1),
    _BadgeEntry(title: 'Consistency Builder', imagePath: AppAssets.badge2),
    _BadgeEntry(title: 'Strength Milestone', imagePath: AppAssets.badge3),
    _BadgeEntry(
      title: 'Iron Dedication',
      imagePath: AppAssets.badge4,
      isUnlocked: false,
    ),
  ];

  int _selectedTab = 0; // 0 = Workouts, 1 = Badges
  String _selectedMonth = 'February 2026';

  @override
  Widget build(BuildContext context) {
    final hasNoMonthWorkouts =
        widget.isEmpty || _selectedMonth == 'December 2025';
    final totalWorkouts = widget.isEmpty ? '0' : '63';
    final totalWeeks = widget.isEmpty ? '0' : '12';
    final hoursTrained = widget.isEmpty ? '0' : '48 h 43m';

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF262626)),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.profileSetting,
                          width: 20,
                          height: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AppAssets.profileAvatar,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sam Porter',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ProfileStat(
                                label: 'Total Workouts',
                                value: totalWorkouts,
                              ),
                              _ProfileStat(
                                label: 'Total Week',
                                value: totalWeeks,
                              ),
                              _ProfileStat(
                                label: 'Hours Trained',
                                value: hoursTrained,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _ProfileTabButton(
                      label: 'Workouts',
                      isSelected: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    _ProfileTabButton(
                      label: 'Badges',
                      isSelected: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedTab == 0
                ? _buildWorkoutsTab(hasNoMonthWorkouts)
                : _buildBadgesTab(widget.isEmpty),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutsTab(bool isEmpty) {
    final monthCount = isEmpty ? 0 : 17;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$monthCount ',
                      style: TextStyle(
                        color: isEmpty
                            ? AppColors.textPrimary
                            : AppColors.primaryYellow,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: 'Workouts',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => setState(() => _selectedMonth = value),
                color: const Color(0xFF1A1A1A),
                itemBuilder: (_) => _months
                    .map(
                      (m) => PopupMenuItem<String>(
                        value: m,
                        child: Text(
                          m,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF262626)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.statCalendar,
                        width: 15,
                        height: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedMonth,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEmpty) ...[
            const SizedBox(height: 52),
            Image.asset(
              AppAssets.statWorkouts,
              width: 96,
              height: 96,
            ),
            const SizedBox(height: 18),
            const Text(
              'No Workouts Yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven’t completed any workouts this month.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: widget.onBrowseWorkouts,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 46),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Browse Now'),
              ),
            ),
          ] else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _history[index];
                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF242424)),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 96,
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.statCalendar,
                                      width: 13,
                                      height: 13,
                                      color: AppColors.textSecondary
                                          .withValues(alpha: 0.72),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.dateText,
                                      style: TextStyle(
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.clockIcon,
                                      width: 13,
                                      height: 13,
                                      color: AppColors.textSecondary
                                          .withValues(alpha: 0.72),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item.durationText,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.75),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      AppAssets.caloriesIcon,
                                      width: 13,
                                      height: 13,
                                      color: AppColors.textSecondary
                                          .withValues(alpha: 0.72),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item.caloriesText,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.75),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(bool isEmpty) {
    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.goalMedal,
                width: 128,
                height: 128,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Achievements Yet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete workouts to start unlocking your milestones.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.72),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: widget.onBrowseWorkouts,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 46),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Browse Now'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Badges',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Image.asset(
              AppAssets.goalMedal,
              width: 144,
              height: 144,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '3',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '63',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.14,
              minHeight: 7,
              backgroundColor: Color(0xFF2C2C2C),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryYellow,
              ),
            ),
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final badge = _badges[index];
              return Opacity(
                opacity: badge.isUnlocked ? 1.0 : 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      badge.imagePath,
                      width: 118,
                      height: 118,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      badge.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.65),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  const _ProfileTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryYellow
                      : AppColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 2,
              color: isSelected
                  ? AppColors.primaryYellow
                  : const Color(0xFF242424),
            ),
          ],
        ),
      ),
    );
  }
}
