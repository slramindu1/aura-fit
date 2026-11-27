import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../goals/goals_screen.dart';
import '../workout_session/active_workout_screen.dart';
import 'models/workout_item.dart';
import 'notifications/notification_screen.dart';
import 'search/search_modal_sheet.dart';
import 'search/search_results_screen.dart';
import 'widgets/home_workout_cards.dart';

/// Home dashboard tab matching the AuraFit home screen designs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.initialHasActiveWorkout = true,
  });

  /// Whether to start with the Active Workout banner and `01 / 03` target.
  final bool initialHasActiveWorkout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<WorkoutCategory> _categories = [
    WorkoutCategory(label: 'All Body', iconPath: AppAssets.catAllBody),
    WorkoutCategory(label: 'Legs', iconPath: AppAssets.catLegs),
    WorkoutCategory(label: 'Triceps', iconPath: AppAssets.catTriceps),
    WorkoutCategory(label: 'Chest', iconPath: AppAssets.catChest),
  ];

  static const List<WorkoutItem> _featuredWorkouts = [
    WorkoutItem(
      id: 'upper_body',
      title: 'Upper Body Strength',
      imagePath: AppAssets.workout1,
      category: 'Chest',
      durationMinutes: 45,
      calories: 320,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'lower_body',
      title: 'Lower Body Power',
      imagePath: AppAssets.workout2,
      category: 'Legs',
      durationMinutes: 50,
      calories: 380,
      exercisesCount: 5,
      startLevel: 'Intermediate',
    ),
  ];

  static const List<WorkoutItem> _otherWorkouts = [
    WorkoutItem(
      id: 'push_day',
      title: 'Push Day',
      imagePath: AppAssets.workoutPushDay,
      category: 'Chest',
      durationMinutes: 45,
      calories: 340,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'leg_sculpt',
      title: 'Leg Sculpt & Strength',
      imagePath: AppAssets.workout2,
      category: 'Legs',
      durationMinutes: 40,
      calories: 310,
      exercisesCount: 5,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'triceps_burn',
      title: 'Triceps & Arms Burn',
      imagePath: AppAssets.workout1,
      category: 'Triceps',
      durationMinutes: 30,
      calories: 240,
      exercisesCount: 4,
      startLevel: 'Beginner',
    ),
  ];

  final List<String> _recentSearches = ['Upper', 'Chest', 'Legs'];
  int _selectedCategoryIndex = 0;
  late bool _hasActiveWorkout;
  String _activeWorkoutTitle = 'Upper Body Strength';
  int _activeWorkoutExercises = 4;

  @override
  void initState() {
    super.initState();
    _hasActiveWorkout = widget.initialHasActiveWorkout;
  }

  void _openSearchModal() {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchModalSheet(
        recentSearches: _recentSearches,
        onRemoveRecent: (term) {
          setState(() => _recentSearches.remove(term));
        },
        onSubmitSearch: (query) {
          setState(() {
            _recentSearches.remove(query);
            _recentSearches.insert(0, query);
          });
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SearchResultsScreen(
                initialQuery: query,
                onWorkoutSelected: _startOrSelectWorkout,
              ),
            ),
          );
        },
      ),
    );
  }

  void _startOrSelectWorkout(WorkoutItem workout) {
    setState(() {
      _hasActiveWorkout = true;
      _activeWorkoutTitle = workout.title;
      _activeWorkoutExercises = workout.exercisesCount;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Active workout: ${workout.title}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  List<WorkoutItem> get _filteredOtherWorkouts {
    final selectedCategory = _categories[_selectedCategoryIndex].label;

    return _otherWorkouts.where((item) {
      return selectedCategory == 'All Body' ||
          item.category == selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completedTarget = _hasActiveWorkout ? '01' : '00';
    final filteredWorkouts = _filteredOtherWorkouts;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.splashBg,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF242424),
          colorBlendMode: BlendMode.srcIn,
        ),
        SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(completedTarget),
                const SizedBox(height: 16),
                _buildSearchBar(),
                if (_hasActiveWorkout) ...[
                  const SizedBox(height: 16),
                  ActiveWorkoutBanner(
                    workoutTitle: _activeWorkoutTitle,
                    completedExercises: 2,
                    totalExercises: _activeWorkoutExercises,
                    completedMinutes: 18,
                    onResume: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ActiveWorkoutScreen(
                            workoutTitle: _activeWorkoutTitle,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Workouts',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _hasActiveWorkout = !_hasActiveWorkout);
                      },
                      child: const Text(
                        'See more',
                        style: TextStyle(
                          color: AppColors.primaryYellow,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 234,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _featuredWorkouts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final workout = _featuredWorkouts[index];
                      return FeaturedWorkoutCard(
                        workout: workout,
                        onTap: () => _startOrSelectWorkout(workout),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Other Workouts',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = index == _selectedCategoryIndex;
                      return InkWell(
                        onTap: () {
                          setState(() => _selectedCategoryIndex = index);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17171E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryYellow
                                  : const Color(0xFF282832),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                cat.iconPath,
                                width: 18,
                                height: 18,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryYellow
                                      : AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                if (filteredWorkouts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No workouts match your search',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredWorkouts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return OtherWorkoutCard(
                        workout: workout,
                        onTap: () => _startOrSelectWorkout(workout),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(String completedTarget) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            AppAssets.avatar,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.72),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Sam Porter',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => GoalsScreen(
                  initialCompletedFirst: _hasActiveWorkout,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF17171E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF282832)),
            ),
            child: Row(
              children: [
                Image.asset(
                  _hasActiveWorkout
                      ? AppAssets.targetColorIcon
                      : AppAssets.targetIcon,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  completedTarget,
                  style: TextStyle(
                    color: _hasActiveWorkout
                        ? AppColors.primaryYellow
                        : AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' / 03',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.65),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF17171E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF282832)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppAssets.notificationIcon,
              width: 20,
              height: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: _openSearchModal,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF24242D)),
        ),
        child: Row(
          children: [
            Image.asset(
              AppAssets.searchIcon,
              width: 18,
              height: 18,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              'Search Workouts, Programs etc',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
