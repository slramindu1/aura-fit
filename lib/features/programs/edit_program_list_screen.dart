import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../home/models/workout_item.dart';

/// Confirmation dialog shown before removing a workout from a program.
Future<bool> showDeleteWorkoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: const Color(0xFF141418),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF282832)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.progDeleteWorkout,
                width: 96,
                height: 96,
              ),
              const SizedBox(height: 18),
              const Text(
                'Delete Workout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This workout will be removed from your program. You can add it again anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.78),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.textDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}

/// Reorderable & removable workout list screen ("Edit Program List").
class EditProgramListScreen extends StatefulWidget {
  const EditProgramListScreen({
    super.key,
    required this.workouts,
  });

  final List<WorkoutItem> workouts;

  @override
  State<EditProgramListScreen> createState() => _EditProgramListScreenState();
}

class _EditProgramListScreenState extends State<EditProgramListScreen> {
  late List<WorkoutItem> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = List<WorkoutItem>.from(widget.workouts);
  }

  Future<void> _confirmRemove(WorkoutItem item) async {
    final confirmed = await showDeleteWorkoutDialog(context);
    if (confirmed && mounted) {
      setState(() => _workouts.removeWhere((w) => w.id == item.id));
    }
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
                    'Edit Program List',
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141418),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF24242D)),
                  ),
                  child: ReorderableListView.builder(
                    itemCount: _workouts.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _workouts.removeAt(oldIndex);
                        _workouts.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _workouts[index];
                      return Container(
                        key: ValueKey<String>(item.id),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17171E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF282832)),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => _confirmRemove(item),
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xFFEF4444),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            ReorderableDragStartListener(
                              index: index,
                              child: Icon(
                                Icons.menu,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.72,
                                ),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_workouts),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
