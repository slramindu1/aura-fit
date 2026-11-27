import '../../../core/constants/app_assets.dart';
import '../models/workout_item.dart';

/// Shared catalog of workouts, programs, and search suggestions.
abstract final class SearchCatalog {
  static const List<String> suggestions = [
    'Chest Builder Pro',
    'Chest & Triceps Blast',
    'Upper Body (Chest Focus)',
    '30-Min Chest Pump',
    'Chest Fly (Machine)',
    'Push Day',
    'Full Body Push',
    'Leg Push',
    'Push Hyperthropy',
    'Push Intensity',
    'Upper Body Strength',
    'Lower Body Power',
  ];

  static const List<WorkoutItem> allWorkouts = [
    WorkoutItem(
      id: 'push_day',
      title: 'Push Day',
      imagePath: AppAssets.searchResultPushDay,
      category: 'Chest',
      durationMinutes: 45,
      calories: 340,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
      equipment: 'Full Equipment',
    ),
    WorkoutItem(
      id: 'full_body_push',
      title: 'Full Body Push',
      imagePath: AppAssets.searchResultFullBodyPush,
      category: 'All Body',
      durationMinutes: 55,
      calories: 410,
      exercisesCount: 6,
      startLevel: 'Medium',
      equipment: 'Full Equipment',
    ),
    WorkoutItem(
      id: 'leg_push',
      title: 'Leg Push',
      imagePath: AppAssets.searchResultLegPush,
      category: 'Legs',
      durationMinutes: 35,
      calories: 300,
      exercisesCount: 4,
      startLevel: 'Medium',
      equipment: 'Full Equipment',
    ),
    WorkoutItem(
      id: 'push_hypertrophy',
      title: 'Push Hyperthropy',
      imagePath: AppAssets.searchResultHypertrophy,
      category: 'Chest',
      durationMinutes: 45,
      calories: 340,
      exercisesCount: 5,
      startLevel: 'Intermediate',
      equipment: 'Full Equipment',
    ),
    WorkoutItem(
      id: 'push_intensity',
      title: 'Push Intensity',
      imagePath: AppAssets.workout1,
      category: 'Chest',
      durationMinutes: 45,
      calories: 370,
      exercisesCount: 5,
      startLevel: 'Intermediate',
      equipment: 'Full Equipment',
    ),
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
      equipment: 'Dumbbells only',
      isProgram: true,
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
      equipment: 'Dumbbells only',
      isProgram: true,
    ),
    WorkoutItem(
      id: 'chest_builder',
      title: 'Chest Builder Pro',
      imagePath: AppAssets.searchResultPushDay,
      category: 'Chest',
      durationMinutes: 40,
      calories: 310,
      exercisesCount: 5,
      startLevel: 'Medium',
      equipment: 'Full Equipment',
      isProgram: true,
    ),
  ];

  static bool matchesQuery(String title, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return title.toLowerCase().contains(normalized);
  }

  static bool matchesFilter(WorkoutItem item, WorkoutFilter filter) {
    if (filter.bodyPart != null &&
        filter.bodyPart != 'All Body' &&
        item.category != filter.bodyPart) {
      return false;
    }
    if (filter.level != null &&
        item.startLevel != filter.level &&
        item.endLevel != filter.level) {
      return false;
    }
    if (filter.duration != null) {
      final mins = item.durationMinutes;
      switch (filter.duration) {
        case 'Under 30 min':
          if (mins >= 30) return false;
        case '30–45 min':
          if (mins < 30 || mins > 45) return false;
        case '45–60 min':
          if (mins < 45 || mins > 60) return false;
        case '60+ min':
          if (mins <= 60) return false;
      }
    }
    if (filter.equipment != null && item.equipment != filter.equipment) {
      return false;
    }
    return true;
  }
}
