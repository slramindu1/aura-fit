import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../models/workout_item.dart';

/// Active workout resume banner shown when a session is in progress.
class ActiveWorkoutBanner extends StatelessWidget {
  const ActiveWorkoutBanner({
    super.key,
    required this.workoutTitle,
    required this.completedExercises,
    required this.totalExercises,
    required this.completedMinutes,
    required this.onResume,
  });

  final String workoutTitle;
  final int completedExercises;
  final int totalExercises;
  final int completedMinutes;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 176,
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF282832)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                AppAssets.activeBanner,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.48, 0.78],
                  colors: [
                    const Color(0xFF121216),
                    const Color(0xFF121216).withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.dumbbellIcon,
                        width: 14,
                        height: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Active Workout',
                        style: TextStyle(
                          color: AppColors.primaryYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workoutTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _MetaRow(
                        iconPath: AppAssets.dumbbellIcon,
                        text: 'Exercise $completedExercises of $totalExercises',
                      ),
                      const SizedBox(height: 3),
                      _MetaRow(
                        iconPath: AppAssets.clockIcon,
                        text: '$completedMinutes min completed',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onResume,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(118, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Resume Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal card used in the "Featured Workouts" carousel.
class FeaturedWorkoutCard extends StatelessWidget {
  const FeaturedWorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
  });

  final WorkoutItem workout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                workout.imagePath,
                width: 200,
                height: 118,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              workout.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            _DifficultyBadgeRow(
              startLevel: workout.startLevel,
              endLevel: workout.endLevel,
            ),
            const SizedBox(height: 6),
            _MetaRow(
              iconPath: AppAssets.clockIcon,
              text: '${workout.durationMinutes} min',
            ),
            const SizedBox(height: 3),
            _MetaRow(
              iconPath: AppAssets.caloriesIcon,
              text: '${workout.calories} kcal',
            ),
            const SizedBox(height: 3),
            _MetaRow(
              iconPath: AppAssets.dumbbellIcon,
              text: '${workout.exercisesCount} exercises',
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width card used in the "Other Workouts" list.
class OtherWorkoutCard extends StatelessWidget {
  const OtherWorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
  });

  final WorkoutItem workout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF17171E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF282832)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 126,
                child: Image.asset(
                  workout.imagePath,
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
                        workout.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _DifficultyBadgeRow(
                        startLevel: workout.startLevel,
                        endLevel: workout.endLevel,
                      ),
                      const SizedBox(height: 6),
                      _MetaRow(
                        iconPath: AppAssets.clockIcon,
                        text: '${workout.durationMinutes} min',
                      ),
                      const SizedBox(height: 4),
                      _MetaRow(
                        iconPath: AppAssets.caloriesIcon,
                        text: '${workout.calories} kcal',
                      ),
                      const SizedBox(height: 4),
                      _MetaRow(
                        iconPath: AppAssets.dumbbellIcon,
                        text: '${workout.exercisesCount} exercises',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyBadgeRow extends StatelessWidget {
  const _DifficultyBadgeRow({
    required this.startLevel,
    this.endLevel,
  });

  final String startLevel;
  final String? endLevel;

  Color _dotColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF22C55E);
      case 'intermediate':
        return const Color(0xFFEF4444);
      default:
        return AppColors.primaryYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: _dotColor(startLevel),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          startLevel,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (endLevel != null) ...[
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
            decoration: BoxDecoration(
              color: _dotColor(endLevel!),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              endLevel!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.iconPath,
    required this.text,
  });

  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 14,
          height: 14,
          color: AppColors.textSecondary.withValues(alpha: 0.72),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.78),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
