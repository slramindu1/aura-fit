import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/models/workout_item.dart';
import 'add_to_programs_sheet.dart';
import 'share_workout_sheet.dart';

class _ExerciseItem {
  const _ExerciseItem({
    required this.name,
    required this.imagePath,
    required this.setsReps,
    required this.rest,
  });

  final String name;
  final String imagePath;
  final String setsReps;
  final String rest;
}

/// Modal bottom sheet showing workout overview, target muscles, exercises,
/// and Bookmark / Add to Programs / Share / Start Workout actions.
class WorkoutDetailSheet extends StatefulWidget {
  const WorkoutDetailSheet({
    super.key,
    required this.workout,
    required this.programs,
    this.initialBookmarked = false,
    this.onStartWorkout,
  });

  final WorkoutItem workout;
  final List<UserProgram> programs;
  final bool initialBookmarked;
  final VoidCallback? onStartWorkout;

  @override
  State<WorkoutDetailSheet> createState() => _WorkoutDetailSheetState();
}

class _WorkoutDetailSheetState extends State<WorkoutDetailSheet> {
  static const List<_ExerciseItem> _exercises = [
    _ExerciseItem(
      name: 'Bench Press',
      imagePath: AppAssets.exerciseBenchPress,
      setsReps: '3 sets • 8–10 reps',
      rest: 'Rest: 60–90 sec',
    ),
    _ExerciseItem(
      name: 'Lat Pulldown',
      imagePath: AppAssets.exerciseLatPulldown,
      setsReps: '3 sets • 8–12 reps',
      rest: 'Rest: 60 sec',
    ),
    _ExerciseItem(
      name: 'Tricep Pushdown',
      imagePath: AppAssets.exerciseTricepPushdown,
      setsReps: '3 sets • 12 reps',
      rest: 'Rest: 45 sec',
    ),
  ];

  late bool _isBookmarked;
  String? _savedProgramName;
  String? _toastMessage;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.initialBookmarked;
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _showToast(String message) {
    _toastTimer?.cancel();
    setState(() => _toastMessage = message);
    _toastTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _toastMessage = null);
      }
    });
  }

  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    _showToast(
      _isBookmarked ? 'Save to Bookmark' : 'Removed from Bookmark',
    );
  }

  Future<void> _openAddToPrograms() async {
    final selected = await showModalBottomSheet<UserProgram>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToProgramsSheet(programs: widget.programs),
    );
    if (selected != null && mounted) {
      setState(() => _savedProgramName = selected.title);
      _showToast('Save to “${selected.title}”');
    }
  }

  void _openShareSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareWorkoutSheet(workout: widget.workout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          workout.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            AppAssets.closeIcon,
                            width: 20,
                            height: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                workout.imagePath,
                                width: 112,
                                height: 112,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Target Muscle :',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 8,
                                    children: const [
                                      _MuscleTag(
                                        iconPath: AppAssets.catChest,
                                        label: 'Chest',
                                      ),
                                      _MuscleTag(
                                        iconPath: AppAssets.catChest,
                                        label: 'Back',
                                      ),
                                      _MuscleTag(
                                        iconPath: AppAssets.catChest,
                                        label: 'Shoulder',
                                      ),
                                      _MuscleTag(
                                        iconPath: AppAssets.catTriceps,
                                        label: 'Arms',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF22C55E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        workout.startLevel,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (workout.endLevel != null) ...[
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            workout.endLevel!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _MetricPill(
                              iconPath: AppAssets.clockIcon,
                              label: 'est. ${workout.durationMinutes} min',
                            ),
                            _MetricPill(
                              iconPath: AppAssets.caloriesIcon,
                              label: 'est. ${workout.calories} kcal',
                            ),
                            _MetricPill(
                              iconPath: AppAssets.dumbbellIcon,
                              label: '${workout.exercisesCount} exercises',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFF24242D), height: 1),
                        const SizedBox(height: 18),
                        const Text(
                          'About This Workout',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build foundational upper body strength using controlled compound movements. Perfect for developing stability and form.',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.78,
                            ),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Exercises',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (var i = 0; i < _exercises.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 22,
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: AppColors.white,
                                    child: Image.asset(
                                      _exercises[i].imagePath,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _exercises[i].name,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppAssets.dumbbellIcon,
                                            width: 13,
                                            height: 13,
                                            color: AppColors.textSecondary
                                                .withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _exercises[i].setsReps,
                                            style: TextStyle(
                                              color: AppColors.textSecondary
                                                  .withValues(alpha: 0.75),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppAssets.clockIcon,
                                            width: 13,
                                            height: 13,
                                            color: AppColors.textSecondary
                                                .withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _exercises[i].rest,
                                            style: TextStyle(
                                              color: AppColors.textSecondary
                                                  .withValues(alpha: 0.75),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Color(0xFF24242D), height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _toggleBookmark,
                        icon: Image.asset(
                          _isBookmarked
                              ? AppAssets.workoutBookmarkSaved
                              : AppAssets.workoutBookmark,
                          width: 24,
                          height: 24,
                          color: _isBookmarked ? null : AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: _openAddToPrograms,
                        icon: _savedProgramName != null
                            ? Image.asset(
                                AppAssets.workoutSuccess,
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                AppAssets.workoutPlaylistPlus,
                                width: 24,
                                height: 24,
                                color: AppColors.textPrimary,
                              ),
                      ),
                      IconButton(
                        onPressed: _openShareSheet,
                        icon: Image.asset(
                          AppAssets.workoutShare,
                          width: 24,
                          height: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onStartWorkout?.call();
                    },
                    child: const Text('Start Workout'),
                  ),
                ),
              ],
            ),
            if (_toastMessage != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 138,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
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
                          _toastMessage!,
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

class _MuscleTag extends StatelessWidget {
  const _MuscleTag({
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath,
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.85),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryYellow,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            iconPath,
            width: 16,
            height: 16,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
