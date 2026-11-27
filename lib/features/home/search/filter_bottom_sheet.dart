import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../models/workout_item.dart';

/// Modal bottom sheet for filtering workout search results.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
  });

  final WorkoutFilter initialFilter;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const List<WorkoutCategory> _bodyParts = [
    WorkoutCategory(label: 'All Body', iconPath: AppAssets.catAllBody),
    WorkoutCategory(label: 'Legs', iconPath: AppAssets.catLegs),
    WorkoutCategory(label: 'Chest', iconPath: AppAssets.catChest),
    WorkoutCategory(label: 'Triceps', iconPath: AppAssets.catTriceps),
  ];

  static const List<({String label, Color dotColor})> _levels = [
    (label: 'Beginner', dotColor: Color(0xFF22C55E)),
    (label: 'Medium', dotColor: AppColors.primaryYellow),
    (label: 'Intermediate', dotColor: Color(0xFFEF4444)),
  ];

  static const List<String> _durations = [
    'Under 30 min',
    '30–45 min',
    '45–60 min',
    '60+ min',
  ];

  static const List<String> _equipments = [
    'No Equipment',
    'Dumbbells only',
    'Full Equipment',
  ];

  late WorkoutFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  void _reset() {
    setState(() => _filter = const WorkoutFilter());
  }

  @override
  Widget build(BuildContext context) {
    final hasActive = _filter.activeCount > 0;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 28),
                  const Expanded(
                    child: Text(
                      'Filter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
              const SizedBox(height: 20),
              const _SectionLabel('Body Part'),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bodyParts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final part = _bodyParts[index];
                    final selected = _filter.bodyPart == part.label;
                    return _FilterChipContainer(
                      isSelected: selected,
                      onTap: () {
                        setState(() {
                          _filter = _filter.copyWith(
                            bodyPart: () => selected ? null : part.label,
                          );
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            part.iconPath,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            part.label,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.primaryYellow
                                  : AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Level'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _levels.map((level) {
                  final selected = _filter.level == level.label;
                  return _FilterChipContainer(
                    isSelected: selected,
                    onTap: () {
                      setState(() {
                        _filter = _filter.copyWith(
                          level: () => selected ? null : level.label,
                        );
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: level.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          level.label,
                          style: TextStyle(
                            color: selected
                                ? AppColors.primaryYellow
                                : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Duration'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _durations.map((duration) {
                  final selected = _filter.duration == duration;
                  return _FilterChipContainer(
                    isSelected: selected,
                    onTap: () {
                      setState(() {
                        _filter = _filter.copyWith(
                          duration: () => selected ? null : duration,
                        );
                      });
                    },
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primaryYellow
                            : AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Equipment'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _equipments.map((equipment) {
                  final selected = _filter.equipment == equipment;
                  return _FilterChipContainer(
                    isSelected: selected,
                    onTap: () {
                      setState(() {
                        _filter = _filter.copyWith(
                          equipment: () => selected ? null : equipment,
                        );
                      });
                    },
                    child: Text(
                      equipment,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primaryYellow
                            : AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFF24242D), height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _reset,
                    child: Text(
                      'Reset Filter',
                      style: TextStyle(
                        color: AppColors.primaryYellow.withValues(
                          alpha: hasActive ? 1.0 : 0.65,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_filter),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(96, 44),
                        backgroundColor: hasActive
                            ? AppColors.primaryYellow
                            : AppColors.primaryYellow.withValues(alpha: 0.7),
                        foregroundColor: AppColors.textDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FilterChipContainer extends StatelessWidget {
  const _FilterChipContainer({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? AppColors.primaryYellow : const Color(0xFF282832),
            width: 1.2,
          ),
        ),
        child: child,
      ),
    );
  }
}
