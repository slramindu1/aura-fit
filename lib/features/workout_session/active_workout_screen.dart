import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import 'ai_form_check_flow.dart';
import 'workout_complete_screen.dart';

/// Active workout execution screen with set checkboxes, rest timer, and AI Form Check.
class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({
    super.key,
    this.workoutTitle = 'Upper Body Strength',
    this.exerciseName = 'Dumbbell Shoulder Press',
  });

  final String workoutTitle;
  final String exerciseName;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final List<bool> _completedSets = [true, false, false];
  bool _isResting = false;
  bool _isPaused = false;

  void _endSet() {
    final nextIncomplete = _completedSets.indexWhere((done) => !done);
    setState(() {
      if (nextIncomplete != -1) {
        _completedSets[nextIncomplete] = true;
      }
      if (_completedSets.every((done) => done)) {
        _isResting = false;
      } else {
        _isResting = true;
      }
    });
  }

  void _skipRest() {
    setState(() => _isResting = false);
  }

  @override
  Widget build(BuildContext context) {
    final allSetsDone = _completedSets.every((done) => done);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
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
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  const Text(
                    'Exercise 4 of 4',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
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
                      AppAssets.sessionDotsMenu,
                      width: 18,
                      height: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.workoutTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.exerciseName,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.78),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      AppAssets.sessionExercise,
                      width: double.infinity,
                      height: 235,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: InkWell(
                        onTap: () => setState(() => _isPaused = !_isPaused),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: _isPaused
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: AppColors.white,
                                  size: 26,
                                )
                              : Image.asset(
                                  AppAssets.sessionPause,
                                  width: 20,
                                  height: 20,
                                  color: AppColors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SetUpPhoneScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.sessionBot,
                              width: 18,
                              height: 18,
                              color: AppColors.textDark,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Form Check',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 13,
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
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: _completedSets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isDone = _completedSets[index];
                    return InkWell(
                      onTap: () {
                        setState(() => _completedSets[index] = !isDone);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppColors.primaryYellow
                                  : const Color(0xFF282834),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: isDone
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: AppColors.textDark,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Set',
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.72,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '10',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Reps',
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.72,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (allSetsDone)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const WorkoutCompleteCaptureScreen(),
                      ),
                    );
                  },
                  child: const Text('Workout Done'),
                )
              else if (_isResting)
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          'Rest',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.72,
                            ),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '01:43',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _skipRest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.textDark,
                              minimumSize: const Size(82, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Skip'),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isPaused = !_isPaused),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.sessionPause,
                          width: 20,
                          height: 20,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Image.asset(
                      AppAssets.clockIcon,
                      width: 16,
                      height: 16,
                      color: AppColors.primaryYellow,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '01:43',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _endSet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.textDark,
                          minimumSize: const Size(124, 46),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.sessionCheckCircle,
                              width: 18,
                              height: 18,
                              color: AppColors.textDark,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'End Set',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
