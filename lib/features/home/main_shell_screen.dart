import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../profile/profile_screen.dart';
import '../statistics/statistics_screen.dart';
import '../workout/workout_screen.dart';
import 'home_screen.dart';

/// Main authenticated shell with the 5-tab bottom navigation bar.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    this.initialHasActiveWorkout = true,
  });

  final bool initialHasActiveWorkout;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  static const List<({String label, String icon})> _tabs = [
    (label: 'Home', icon: AppAssets.navHome),
    (label: 'Workout', icon: AppAssets.navWorkout),
    (label: 'AI Assist', icon: AppAssets.navAiAssist),
    (label: 'Statistic', icon: AppAssets.navStatistic),
    (label: 'Profile', icon: AppAssets.navProfile),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(initialHasActiveWorkout: widget.initialHasActiveWorkout),
          const WorkoutScreen(),
          const SizedBox.shrink(),
          StatisticsScreen(
            onBrowseWorkouts: () => setState(() => _currentIndex = 1),
          ),
          ProfileScreen(
            onBrowseWorkouts: () => setState(() => _currentIndex = 1),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131317),
          border: Border(
            top: BorderSide(color: Color(0xFF22222A), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isSelected = index == _currentIndex;
                final color = isSelected
                    ? AppColors.primaryYellow
                    : AppColors.textSecondary.withValues(alpha: 0.7);

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (index == 2) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AiChatScreen(),
                          ),
                        );
                        return;
                      }
                      setState(() => _currentIndex = index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          tab.icon,
                          width: 22,
                          height: 22,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
