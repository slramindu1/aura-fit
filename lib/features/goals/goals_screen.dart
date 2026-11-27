import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';

class _GoalWorkout {
  const _GoalWorkout({
    required this.title,
    required this.imagePath,
    required this.durationMinutes,
    required this.calories,
    required this.exercisesCount,
    this.isCompleted = false,
  });

  final String title;
  final String imagePath;
  final int durationMinutes;
  final int calories;
  final int exercisesCount;
  final bool isCompleted;

  _GoalWorkout copyWith({bool? isCompleted}) {
    return _GoalWorkout(
      title: title,
      imagePath: imagePath,
      durationMinutes: durationMinutes,
      calories: calories,
      exercisesCount: exercisesCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class _ProgramTemplate {
  const _ProgramTemplate({
    required this.title,
    required this.imagePath,
    required this.workoutsCount,
    this.isCreated = false,
  });

  final String title;
  final String imagePath;
  final int workoutsCount;
  final bool isCreated;
}

/// Goals screen displaying weekly progress ring, active program workouts,
/// options sheet, and "No Goals Set Yet" program picker state.
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
    this.initialHasGoal = true,
    this.initialCompletedFirst = false,
  });

  final bool initialHasGoal;
  final bool initialCompletedFirst;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const List<_ProgramTemplate> _programTemplates = [
    _ProgramTemplate(
      title: 'Build the Basics 💪',
      imagePath: AppAssets.goalBuildBasics,
      workoutsCount: 3,
    ),
    _ProgramTemplate(
      title: 'Upper Focus',
      imagePath: AppAssets.goalUpperFocus,
      workoutsCount: 4,
    ),
    _ProgramTemplate(
      title: 'Back Builder 🦍',
      imagePath: AppAssets.historyBackDay,
      workoutsCount: 3,
    ),
    _ProgramTemplate(
      title: 'Glute Power 🍑',
      imagePath: AppAssets.goalGlutePower,
      workoutsCount: 4,
    ),
    _ProgramTemplate(
      title: 'Show up & Lift',
      imagePath: AppAssets.historyChestDay,
      workoutsCount: 3,
    ),
    _ProgramTemplate(
      title: 'Built Different',
      imagePath: AppAssets.goalProgramIcon,
      workoutsCount: 3,
      isCreated: true,
    ),
  ];

  late bool _hasGoal;
  String _programTitle = 'Built Different';
  String _programImage = AppAssets.goalProgramIcon;
  int _selectedEmptyTab = 0; // 0 = Programs, 1 = Created Programs
  late List<_GoalWorkout> _workouts;

  @override
  void initState() {
    super.initState();
    _hasGoal = widget.initialHasGoal;
    _workouts = [
      _GoalWorkout(
        title: 'Leg Day',
        imagePath: AppAssets.historyLegDay,
        durationMinutes: 45,
        calories: 320,
        exercisesCount: 4,
        isCompleted: widget.initialCompletedFirst,
      ),
      const _GoalWorkout(
        title: 'Chest Day',
        imagePath: AppAssets.historyChestDay,
        durationMinutes: 52,
        calories: 340,
        exercisesCount: 4,
      ),
      const _GoalWorkout(
        title: 'Back Day',
        imagePath: AppAssets.historyBackDay,
        durationMinutes: 48,
        calories: 360,
        exercisesCount: 4,
      ),
    ];
  }

  void _openOptionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141418),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SheetOptionRow(
                    iconPath: AppAssets.goalChangeIcon,
                    label: 'Change Program Goals',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      setState(() => _hasGoal = false);
                    },
                  ),
                  _SheetOptionRow(
                    iconPath: AppAssets.goalShareIcon,
                    label: 'Share',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('Shared $_programTitle goal'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                  ),
                  _SheetOptionRow(
                    iconPath: AppAssets.goalEditListIcon,
                    label: 'Edit Program List',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Tap any workout to toggle complete'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addManualWorkout() {
    setState(() {
      _workouts.add(
        const _GoalWorkout(
          title: 'Push Day',
          imagePath: AppAssets.searchResultPushDay,
          durationMinutes: 45,
          calories: 340,
          exercisesCount: 4,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthTopBar(),
                  const Text(
                    'Goals',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: _openOptionsSheet,
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
                      child: Image.asset(
                        AppAssets.goalMenuIcon,
                        width: 18,
                        height: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _hasGoal ? _buildActiveGoalBody() : _buildNoGoalBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveGoalBody() {
    final completedCount = _workouts.where((w) => w.isCompleted).length;
    final totalCount = _workouts.length;
    final completedText = completedCount.toString().padLeft(2, '0');
    final totalText = totalCount.toString().padLeft(2, '0');
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 170,
            height: 170,
            child: CustomPaint(
              painter: _GoalRingPainter(progress: progress),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: completedText,
                        style: TextStyle(
                          color: completedCount > 0
                              ? AppColors.primaryYellow
                              : AppColors.textSecondary.withValues(alpha: 0.55),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '/$totalText',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.55),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  _programImage,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _programTitle,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.dumbbellIcon,
                        width: 14,
                        height: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalCount Workouts',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.78,
                          ),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset(
                        AppAssets.statCalendar,
                        width: 14,
                        height: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.72),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalCount Days / Week',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.78,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF141418),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF24242D)),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: _addManualWorkout,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17171E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF282832)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.goalPlusIcon,
                            width: 20,
                            height: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Add Manually',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < _workouts.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i < _workouts.length - 1 ? 12 : 0,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _workouts[i] = _workouts[i].copyWith(
                            isCompleted: !_workouts[i].isCompleted,
                          );
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17171E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF282832)),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    _workouts[i].imagePath,
                                    width: 68,
                                    height: 68,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (_workouts[i].isCompleted)
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Image.asset(
                                      AppAssets.goalCompletedRibbon,
                                      width: 38,
                                      height: 38,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _workouts[i].title,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF22C55E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Beginner',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Intermediate',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.clockIcon,
                                        width: 12,
                                        height: 12,
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_workouts[i].durationMinutes} min',
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.75),
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        AppAssets.caloriesIcon,
                                        width: 12,
                                        height: 12,
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_workouts[i].calories} kcal',
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.75),
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        AppAssets.dumbbellIcon,
                                        width: 12,
                                        height: 12,
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_workouts[i].exercisesCount} exercises',
                                        style: TextStyle(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.75),
                                          fontSize: 11,
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
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoGoalBody() {
    final wantCreated = _selectedEmptyTab == 1;
    final filtered = _programTemplates
        .where((p) => p.isCreated == wantCreated)
        .toList();

    return Column(
      children: [
        const SizedBox(height: 14),
        Image.asset(
          AppAssets.targetColorIcon,
          width: 84,
          height: 84,
        ),
        const SizedBox(height: 16),
        const Text(
          'No Goals Set Yet',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Set your fitness goal to start training\nwith purpose.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.72),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _GoalTabButton(
              label: 'Programs',
              isSelected: _selectedEmptyTab == 0,
              onTap: () => setState(() => _selectedEmptyTab = 0),
            ),
            _GoalTabButton(
              label: 'Created Programs',
              isSelected: _selectedEmptyTab == 1,
              onTap: () => setState(() => _selectedEmptyTab = 1),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF141418),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF24242D)),
            ),
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final program = filtered[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _hasGoal = true;
                      _programTitle = program.title;
                      _programImage = program.imagePath;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          program.imagePath,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${program.workoutsCount} Workouts',
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
                      Image.asset(
                        AppAssets.goalMenuIcon,
                        width: 18,
                        height: 18,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalRingPainter extends CustomPainter {
  const _GoalRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = const Color(0xFF222228)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        -math.pi * 2 * progress.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = AppColors.primaryYellow
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GoalRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SheetOptionRow extends StatelessWidget {
  const _SheetOptionRow({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalTabButton extends StatelessWidget {
  const _GoalTabButton({
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
                  fontSize: 13,
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
