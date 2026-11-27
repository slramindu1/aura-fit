import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/statistics_charts.dart';

class _WeekStatsData {
  const _WeekStatsData({
    required this.workouts,
    required this.trainingTime,
    required this.calories,
    required this.consistency,
  });

  final int workouts;
  final String trainingTime;
  final int calories;
  final int consistency;
}

/// Statistics tab screen with Weekly Overview, AI Insight, Performance Index,
/// Training Volume charts, and empty state.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
    this.isEmpty = false,
    this.onBrowseWorkouts,
  });

  final bool isEmpty;
  final VoidCallback? onBrowseWorkouts;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const List<String> _months = [
    'February 2026',
    'January 2026',
    'December 2025',
  ];

  static const List<String> _weeks = [
    'This Week',
    'Last Week',
    '2 Weeks Ago',
    '3 Weeks Ago',
  ];

  static const Map<int, _WeekStatsData> _weekData = {
    0: _WeekStatsData(
      workouts: 5,
      trainingTime: '2h 45m',
      calories: 2230,
      consistency: 82,
    ),
    1: _WeekStatsData(
      workouts: 4,
      trainingTime: '2h 10m',
      calories: 1890,
      consistency: 76,
    ),
    2: _WeekStatsData(
      workouts: 3,
      trainingTime: '1h 45m',
      calories: 1420,
      consistency: 68,
    ),
    3: _WeekStatsData(
      workouts: 0,
      trainingTime: '0m',
      calories: 0,
      consistency: 0,
    ),
  };

  static const List<WeeklyChartPoint> _performancePoints = [
    WeeklyChartPoint(
      weekLabel: 'Week 1',
      dateRange: 'Feb 1 – Feb 7',
      value: 60,
      statusLabel: 'Good',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 2',
      dateRange: 'Feb 8 – Feb 14',
      value: 52,
      statusLabel: 'Steady',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 3',
      dateRange: 'Feb 15 – Feb 21',
      value: 74,
      statusLabel: 'Strong',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 4',
      dateRange: 'Feb 22 – Feb 28',
      value: 86,
      statusLabel: 'Peak',
    ),
  ];

  static const List<WeeklyChartPoint> _volumePoints = [
    WeeklyChartPoint(
      weekLabel: 'Week 1',
      dateRange: 'Feb 1 – Feb 7',
      value: 3,
      statusLabel: 'Workouts',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 2',
      dateRange: 'Feb 8 – Feb 14',
      value: 5,
      statusLabel: 'Workouts',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 3',
      dateRange: 'Feb 15 – Feb 21',
      value: 4,
      statusLabel: 'Workouts',
    ),
    WeeklyChartPoint(
      weekLabel: 'Week 4',
      dateRange: 'Feb 22 – Feb 28',
      value: 5,
      statusLabel: 'Workouts',
    ),
  ];

  String _selectedMonth = 'February 2026';
  int _selectedWeekIndex = 0;
  int? _selectedPerformanceIndex;
  int? _selectedVolumeIndex;

  @override
  Widget build(BuildContext context) {
    final stats = widget.isEmpty
        ? _weekData[3]!
        : (_weekData[_selectedWeekIndex] ?? _weekData[0]!);
    final showEmpty = widget.isEmpty || stats.workouts == 0;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statistics',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-powered performance insights',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _MonthDropdownPill(
                  selectedMonth: _selectedMonth,
                  months: _months,
                  onSelected: (value) => setState(() => _selectedMonth = value),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _weeks.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = index == _selectedWeekIndex;
                  return InkWell(
                    onTap: () => setState(() => _selectedWeekIndex = index),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF161616),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.primaryYellow
                              : const Color(0xFF262626),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        _weeks[index],
                        style: TextStyle(
                          color: selected
                              ? AppColors.primaryYellow
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Weekly Overview',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _OverviewStatTile(
                            iconPath: AppAssets.statWorkouts,
                            label: 'Workouts',
                            value: '${stats.workouts}',
                            highlight: !showEmpty,
                          ),
                        ),
                        Expanded(
                          child: _OverviewStatTile(
                            iconPath: AppAssets.statTime,
                            label: 'Training Time',
                            value: stats.trainingTime,
                            highlight: !showEmpty,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _OverviewStatTile(
                            iconPath: AppAssets.statCalories,
                            label: 'Calories',
                            value: '${stats.calories}',
                            highlight: !showEmpty,
                          ),
                        ),
                        Expanded(
                          child: _OverviewStatTile(
                            iconPath: AppAssets.statConsistency,
                            label: 'Consistency',
                            value: '${stats.consistency}%',
                            highlight: !showEmpty,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (showEmpty) ...[
              const SizedBox(height: 44),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.trainingStrength,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No Statistics Yet',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your first workout to start tracking your performance.',
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
            ] else ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: 'AI Insight',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Your performance improved due to higher training intensity and better session completion consistency.',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.85),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Performance Index',
                trailing: _MonthDropdownPill(
                  selectedMonth: _selectedMonth,
                  months: _months,
                  onSelected: (value) => setState(() => _selectedMonth = value),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '82',
                          style: TextStyle(
                            color: AppColors.primaryYellow,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '+6%',
                          style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'High performance',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PerformanceIndexChart(
                      points: _performancePoints,
                      selectedIndex: _selectedPerformanceIndex,
                      onSelectIndex: (index) {
                        setState(() => _selectedPerformanceIndex = index);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Training Volume',
                trailing: _MonthDropdownPill(
                  selectedMonth: _selectedMonth,
                  months: _months,
                  onSelected: (value) => setState(() => _selectedMonth = value),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Workout',
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '17',
                      style: TextStyle(
                        color: AppColors.primaryYellow,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TrainingVolumeChart(
                      points: _volumePoints,
                      selectedIndex: _selectedVolumeIndex,
                      onSelectIndex: (index) {
                        setState(() => _selectedVolumeIndex = index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthDropdownPill extends StatelessWidget {
  const _MonthDropdownPill({
    required this.selectedMonth,
    required this.months,
    required this.onSelected,
  });

  final String selectedMonth;
  final List<String> months;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: const Color(0xFF1A1A1A),
      itemBuilder: (_) => months
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
              selectedMonth,
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
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF242424)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _OverviewStatTile extends StatelessWidget {
  const _OverviewStatTile({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.highlight,
  });

  final String iconPath;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.72),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primaryYellow : AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
