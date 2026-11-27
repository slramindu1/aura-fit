import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../bookmark/my_bookmark_screen.dart';
import '../goals/goals_screen.dart';
import '../home/models/workout_item.dart';
import '../home/notifications/notification_screen.dart';
import '../home/search/filter_bottom_sheet.dart';
import '../home/search/search_modal_sheet.dart';
import '../home/search/search_results_screen.dart';
import '../home/widgets/home_workout_cards.dart';
import '../programs/detail_programs_screen.dart';
import '../workout_session/exercise_intro_screen.dart';
import 'sheets/add_to_programs_sheet.dart';
import 'sheets/workout_detail_sheet.dart';

/// Workout tab screen featuring Workouts / Programs tabs, search, and detail sheets.
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
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

  static const List<UserProgram> _programs = [
    UserProgram(
      id: 'prog_1',
      title: 'No Excuse Plan 💪',
      imagePath: AppAssets.programme1,
      workoutsCount: 3,
    ),
    UserProgram(
      id: 'prog_2',
      title: 'Built Different',
      imagePath: AppAssets.programme2,
      workoutsCount: 3,
    ),
  ];

  static const List<
      ({
        String title,
        String imagePath,
        String schedule,
        String description,
      })> _programGridItems = [
    (
      title: 'Build the Basics 💪',
      imagePath: AppAssets.goalBuildBasics,
      schedule: '3 Workout / Week',
      description: 'Simple split. No distraction. Just show up and train.',
    ),
    (
      title: 'Upper Focus',
      imagePath: AppAssets.goalUpperFocus,
      schedule: '4 Workouts / Week',
      description: 'Increase upper body strength and muscle definition.',
    ),
    (
      title: 'Back Builder 🦍',
      imagePath: AppAssets.historyBackDay,
      schedule: '3 Workouts / Week',
      description: 'Build width and thickness with controlled pulling.',
    ),
    (
      title: 'Glute Power 🍑',
      imagePath: AppAssets.goalGlutePower,
      schedule: '4 Workouts / Week',
      description: 'Lower-body power and sculpted glute progression.',
    ),
  ];

  final List<String> _recentSearches = ['Upper', 'Chest', 'Legs'];
  int _selectedTab = 0; // 0 = Workouts, 1 = Programs
  int _selectedCategoryIndex = 0;

  void _openWorkoutDetail(WorkoutItem workout) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WorkoutDetailSheet(
        workout: workout,
        programs: _programs,
        onStartWorkout: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseIntroScreen(workoutTitle: workout.title),
            ),
          );
        },
      ),
    );
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
                onWorkoutSelected: _openWorkoutDetail,
              ),
            ),
          );
        },
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
    final filtered = _filteredOtherWorkouts;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const GoalsScreen(
                          initialCompletedFirst: true,
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
                          AppAssets.targetColorIcon,
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '01',
                          style: TextStyle(
                            color: AppColors.primaryYellow,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' / 03',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.65,
                            ),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const MyBookmarkScreen(),
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
                      AppAssets.workoutBookmark,
                      width: 20,
                      height: 20,
                      color: AppColors.textPrimary,
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
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _openSearchModal,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 50,
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
                      width: 20,
                      height: 20,
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
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _WorkoutTabButton(
                  label: 'Workouts',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _WorkoutTabButton(
                  label: 'Programs',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedTab == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Featured Workouts',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'See more',
                    style: TextStyle(
                      color: AppColors.primaryYellow,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredWorkouts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final workout = _featuredWorkouts[index];
                    return FeaturedWorkoutCard(
                      workout: workout,
                      onTap: () => _openWorkoutDetail(workout),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Other Workouts',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 44,
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
                        padding: const EdgeInsets.symmetric(horizontal: 14),
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
                              width: 22,
                              height: 22,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cat.label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryYellow
                                    : AppColors.textPrimary,
                                fontSize: 14,
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
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final workout = filtered[index];
                  return OtherWorkoutCard(
                    workout: workout,
                    onTap: () => _openWorkoutDetail(workout),
                  );
                },
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      final name = await Navigator.of(context).push<String>(
                        MaterialPageRoute<String>(
                          builder: (_) => const GiveProgramNameScreen(),
                        ),
                      );
                      if (name != null && context.mounted) {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetailProgramsScreen(
                              title: name,
                              imagePath: AppAssets.bookmarkProg2,
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF17171E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF282832)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'New Program',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<WorkoutFilter>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const FilterBottomSheet(
                          initialFilter: WorkoutFilter(),
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
                        AppAssets.filterIcon,
                        width: 18,
                        height: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _programGridItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final prog = _programGridItems[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DetailProgramsScreen(
                            title: prog.title,
                            imagePath: prog.imagePath,
                            initialWorkouts: _otherWorkouts.take(2).toList(),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            prog.imagePath,
                            width: double.infinity,
                            height: 144,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          prog.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Image.asset(
                              AppAssets.clockIcon,
                              width: 12,
                              height: 12,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.72),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                prog.schedule,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.75),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prog.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.72),
                            fontSize: 11.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WorkoutTabButton extends StatelessWidget {
  const _WorkoutTabButton({
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
                  : const Color(0xFF24242D),
            ),
          ],
        ),
      ),
    );
  }
}
