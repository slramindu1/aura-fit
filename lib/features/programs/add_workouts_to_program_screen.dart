import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../home/models/workout_item.dart';

/// Full-screen workout picker for adding workouts to a custom program.
class AddWorkoutsToProgramScreen extends StatefulWidget {
  const AddWorkoutsToProgramScreen({
    super.key,
    required this.programTitle,
    required this.initialSelectedIds,
  });

  final String programTitle;
  final Set<String> initialSelectedIds;

  @override
  State<AddWorkoutsToProgramScreen> createState() =>
      _AddWorkoutsToProgramScreenState();
}

class _AddWorkoutsToProgramScreenState
    extends State<AddWorkoutsToProgramScreen> {
  static const List<WorkoutItem> _suggestedWorkouts = [
    WorkoutItem(
      id: 'leg_day',
      title: 'Leg Day',
      imagePath: AppAssets.bookmarkLegDay,
      category: 'Legs',
      durationMinutes: 45,
      calories: 320,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'push_day',
      title: 'Push Day',
      imagePath: AppAssets.bookmarkPushDay,
      category: 'Chest',
      durationMinutes: 45,
      calories: 340,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'lower_body',
      title: 'Lower Body Power',
      imagePath: AppAssets.bookmarkLowerBody,
      category: 'Legs',
      durationMinutes: 50,
      calories: 380,
      exercisesCount: 5,
      startLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'chest_day',
      title: 'Chest Day',
      imagePath: AppAssets.bookmarkChestDay,
      category: 'Chest',
      durationMinutes: 52,
      calories: 320,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'pull_day',
      title: 'Pull Day',
      imagePath: AppAssets.bookmarkPullDay,
      category: 'Back',
      durationMinutes: 48,
      calories: 360,
      exercisesCount: 5,
      startLevel: 'Medium',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  late final Set<String> _selectedIds;
  String? _toastText;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.initialSelectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleWorkout(WorkoutItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
        _toastText = null;
      } else {
        _selectedIds.add(item.id);
        _toastText = 'Added to “${widget.programTitle}”';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _suggestedWorkouts
        .where((w) => query.isEmpty || w.title.toLowerCase().contains(query))
        .toList();
    final selectedCount = _selectedIds.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AuthTopBar(),
                      const Text(
                        'Add to Programs',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17171E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF282832)),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.goalMenuIcon,
                          width: 18,
                          height: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17171E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF24242D)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      cursorColor: AppColors.primaryYellow,
                      decoration: InputDecoration(
                        hintText: 'Search Workouts',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Image.asset(
                            AppAssets.searchIcon,
                            width: 18,
                            height: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141418),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF24242D)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Suggested Workouts',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = _selectedIds.contains(
                                  item.id,
                                );
                                return InkWell(
                                  onTap: () => _toggleWorkout(item),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF17171E),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF282832),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.asset(
                                            item.imagePath,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${item.startLevel}${item.endLevel != null ? ' → ${item.endLevel}' : ''}',
                                                style: TextStyle(
                                                  color: AppColors.textSecondary
                                                      .withValues(alpha: 0.8),
                                                  fontSize: 11,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${item.durationMinutes} min • ${item.calories} kcal • ${item.exercisesCount} exercises',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.textSecondary
                                                      .withValues(alpha: 0.72),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          isSelected
                                              ? AppAssets.workoutSuccess
                                              : AppAssets.workoutPlus,
                                          width: 24,
                                          height: 24,
                                          color: isSelected
                                              ? null
                                              : AppColors.textPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selected Workouts',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$selectedCount ',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: '/ 7',
                              style: TextStyle(
                                color: AppColors.primaryYellow,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: selectedCount > 0
                        ? () {
                            final chosen = _suggestedWorkouts
                                .where((w) => _selectedIds.contains(w.id))
                                .toList();
                            Navigator.of(context).pop(chosen);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: AppColors.primaryYellow
                          .withValues(alpha: 0.65),
                      disabledForegroundColor: AppColors.textDark.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
            if (_toastText != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 118,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _toastText!,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
