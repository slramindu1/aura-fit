/// Data model for a workout or program card displayed on Home and Search.
class WorkoutItem {
  const WorkoutItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.durationMinutes,
    required this.calories,
    required this.exercisesCount,
    required this.startLevel,
    this.endLevel,
    this.equipment = 'Full Equipment',
    this.isProgram = false,
  });

  final String id;
  final String title;
  final String imagePath;
  final String category;
  final int durationMinutes;
  final int calories;
  final int exercisesCount;
  final String startLevel;
  final String? endLevel;
  final String equipment;
  final bool isProgram;
}

/// Data model for muscle-group filter chips.
class WorkoutCategory {
  const WorkoutCategory({
    required this.label,
    required this.iconPath,
  });

  final String label;
  final String iconPath;
}

/// Filter criteria for workout search results.
class WorkoutFilter {
  const WorkoutFilter({
    this.bodyPart,
    this.level,
    this.duration,
    this.equipment,
  });

  final String? bodyPart;
  final String? level;
  final String? duration;
  final String? equipment;

  int get activeCount {
    var count = 0;
    if (bodyPart != null) count++;
    if (level != null) count++;
    if (duration != null) count++;
    if (equipment != null) count++;
    return count;
  }

  WorkoutFilter copyWith({
    String? Function()? bodyPart,
    String? Function()? level,
    String? Function()? duration,
    String? Function()? equipment,
  }) {
    return WorkoutFilter(
      bodyPart: bodyPart != null ? bodyPart() : this.bodyPart,
      level: level != null ? level() : this.level,
      duration: duration != null ? duration() : this.duration,
      equipment: equipment != null ? equipment() : this.equipment,
    );
  }
}
