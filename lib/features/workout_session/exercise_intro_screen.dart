import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import 'active_workout_screen.dart';

/// Exercise intro screen shown when starting a workout (`Start` -> `Countdown`).
class ExerciseIntroScreen extends StatelessWidget {
  const ExerciseIntroScreen({
    super.key,
    this.workoutTitle = 'Upper Body Strength',
    this.exerciseName = 'Dumbbell Shoulder Press',
  });

  final String workoutTitle;
  final String exerciseName;

  @override
  Widget build(BuildContext context) {
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
                  const AuthTopBar(),
                  Text(
                    workoutTitle,
                    style: const TextStyle(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppAssets.sessionExercise,
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Exercise 3 of 4',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.72,
                          ),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exerciseName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Build shoulder strength and stability with a controlled vertical press.',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Focus on steady movement and full range of motion.',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.dumbbellIcon,
                            width: 14,
                            height: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '3 sets • 10 reps',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.clockIcon,
                            width: 14,
                            height: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'est. 6–8 min',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => WorkoutCountdownScreen(
                        workoutTitle: workoutTitle,
                        exerciseName: exerciseName,
                      ),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3-2-1-"Let's go!" countdown screen with animated yellow arc.
class WorkoutCountdownScreen extends StatefulWidget {
  const WorkoutCountdownScreen({
    super.key,
    required this.workoutTitle,
    required this.exerciseName,
    this.stepDuration = const Duration(milliseconds: 700),
  });

  final String workoutTitle;
  final String exerciseName;
  final Duration stepDuration;

  @override
  State<WorkoutCountdownScreen> createState() => _WorkoutCountdownScreenState();
}

class _WorkoutCountdownScreenState extends State<WorkoutCountdownScreen> {
  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.stepDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_count > 0) {
        setState(() => _count--);
      } else {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ActiveWorkoutScreen(
              workoutTitle: widget.workoutTitle,
              exerciseName: widget.exerciseName,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = _count > 0 ? '$_count' : 'Let’s go!';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: SizedBox(
          width: 240,
          height: 240,
          child: CustomPaint(
            painter: _CountdownArcPainter(step: _count),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: _count > 0 ? 52 : 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownArcPainter extends CustomPainter {
  const _CountdownArcPainter({required this.step});

  final int step;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 18.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startAngle = step > 0 ? math.pi * 0.9 : -math.pi * 0.4;
    final sweepAngle = step > 0 ? -math.pi * 0.85 : math.pi * 0.75;

    final paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          AppColors.primaryYellow.withValues(alpha: 0.1),
          AppColors.primaryYellow,
        ],
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _CountdownArcPainter oldDelegate) =>
      oldDelegate.step != step;
}
