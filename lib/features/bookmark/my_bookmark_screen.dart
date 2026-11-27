import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../home/models/workout_item.dart';
import '../workout/sheets/add_to_programs_sheet.dart';
import '../workout/sheets/share_workout_sheet.dart';
import 'created_programs_screen.dart';

class _ProgramCardItem {
  const _ProgramCardItem({
    required this.title,
    required this.imagePath,
    required this.scheduleLabel,
  });

  final String title;
  final String imagePath;
  final String scheduleLabel;
}

/// My Bookmark screen with Workouts & Programs tabs, multi-select edit mode,
/// item options sheet, and "No Bookmarks Yet" empty state.
class MyBookmarkScreen extends StatefulWidget {
  const MyBookmarkScreen({
    super.key,
    this.initialEmpty = false,
  });

  final bool initialEmpty;

  @override
  State<MyBookmarkScreen> createState() => _MyBookmarkScreenState();
}

class _MyBookmarkScreenState extends State<MyBookmarkScreen> {
  static const List<WorkoutItem> _defaultBookmarks = [
    WorkoutItem(
      id: 'bm_push',
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
      id: 'bm_lower',
      title: 'Lower Body Power',
      imagePath: AppAssets.bookmarkLowerBody,
      category: 'Legs',
      durationMinutes: 50,
      calories: 380,
      exercisesCount: 5,
      startLevel: 'Intermediate',
    ),
    WorkoutItem(
      id: 'bm_chest',
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
      id: 'bm_leg',
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
      id: 'bm_pull',
      title: 'Pull Day',
      imagePath: AppAssets.bookmarkPullDay,
      category: 'Back',
      durationMinutes: 48,
      calories: 360,
      exercisesCount: 5,
      startLevel: 'Medium',
    ),
    WorkoutItem(
      id: 'bm_core',
      title: 'Core & Abs Shred',
      imagePath: AppAssets.bookmarkCoreAbs,
      category: 'Core',
      durationMinutes: 30,
      calories: 220,
      exercisesCount: 6,
      startLevel: 'Medium',
    ),
    WorkoutItem(
      id: 'bm_upper',
      title: 'Upper Body Strength',
      imagePath: AppAssets.bookmarkUpperBody,
      category: 'Chest',
      durationMinutes: 45,
      calories: 320,
      exercisesCount: 4,
      startLevel: 'Beginner',
      endLevel: 'Intermediate',
    ),
  ];

  static const List<_ProgramCardItem> _createdPrograms = [
    _ProgramCardItem(
      title: 'Built Different',
      imagePath: AppAssets.bookmarkProg1,
      scheduleLabel: '3 Workout / Week',
    ),
    _ProgramCardItem(
      title: 'Easy Training',
      imagePath: AppAssets.bookmarkProg2,
      scheduleLabel: '2 Workout / Week',
    ),
    _ProgramCardItem(
      title: 'Build the Basics',
      imagePath: AppAssets.bookmarkProg3,
      scheduleLabel: '3 Workout / Week',
    ),
  ];

  static const List<_ProgramCardItem> _pumpItPrograms = [
    _ProgramCardItem(
      title: 'Upper Focus',
      imagePath: AppAssets.bookmarkProg4,
      scheduleLabel: '4 Workout / Week',
    ),
    _ProgramCardItem(
      title: 'Upper Focus',
      imagePath: AppAssets.bookmarkProg5,
      scheduleLabel: '3 Workout / Week',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  late List<WorkoutItem> _bookmarks;
  final Set<String> _selectedIds = {};
  int _selectedTab = 0; // 0 = Workouts, 1 = Programs
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _bookmarks =
        widget.initialEmpty ? [] : List<WorkoutItem>.from(_defaultBookmarks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openItemOptions(WorkoutItem item) {
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
                  _BookmarkCard(
                    item: item,
                    isEditMode: false,
                    isSelected: false,
                    onTap: () {},
                    onMenuTap: () {},
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFF24242D), height: 1),
                  const SizedBox(height: 8),
                  _BottomSheetAction(
                    iconPath: AppAssets.bookmarkRemove,
                    label: 'Remove from Bookmark',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      setState(() => _bookmarks.removeWhere((b) => b.id == item.id));
                    },
                  ),
                  _BottomSheetAction(
                    iconPath: AppAssets.bookmarkShare,
                    label: 'Share',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ShareWorkoutSheet(workout: item),
                      );
                    },
                  ),
                  _BottomSheetAction(
                    iconPath: AppAssets.bookmarkPlaylistPlus,
                    label: 'Add to program',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      showModalBottomSheet<UserProgram>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AddToProgramsSheet(
                          programs: [
                            UserProgram(
                              id: 'p1',
                              title: 'No Excuse Plan 💪',
                              imagePath: AppAssets.programme1,
                              workoutsCount: 3,
                            ),
                            UserProgram(
                              id: 'p2',
                              title: 'Built Different',
                              imagePath: AppAssets.programme2,
                              workoutsCount: 3,
                            ),
                          ],
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

  void _deleteSelected() {
    setState(() {
      _bookmarks.removeWhere((b) => _selectedIds.contains(b.id));
      _selectedIds.clear();
      _isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTotallyEmpty = _bookmarks.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AuthTopBar(),
                      const Text(
                        'My Bookmark',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_selectedTab == 0)
                        InkWell(
                          onTap: isTotallyEmpty
                              ? null
                              : () {
                                  setState(() {
                                    _isEditMode = !_isEditMode;
                                    if (!_isEditMode) _selectedIds.clear();
                                  });
                                },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF17171E),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF282832),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              _isEditMode
                                  ? AppAssets.bookmarkClose
                                  : AppAssets.bookmarkEdit,
                              width: 18,
                              height: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),
                if (isTotallyEmpty)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.bookmark3d,
                              width: 108,
                              height: 108,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No Bookmarks Yet',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start bookmarking your favorite workouts to build your go-to list.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.72,
                                ),
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _BookmarkTabButton(
                          label: 'Workouts',
                          isSelected: _selectedTab == 0,
                          onTap: () => setState(() => _selectedTab = 0),
                        ),
                        _BookmarkTabButton(
                          label: 'Programs',
                          isSelected: _selectedTab == 1,
                          onTap: () => setState(() {
                            _selectedTab = 1;
                            _isEditMode = false;
                            _selectedIds.clear();
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
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
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
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
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedTab == 0
                        ? _buildWorkoutsList()
                        : _buildProgramsTab(),
                  ),
                ],
              ],
            ),
            if (_isEditMode && _selectedIds.isNotEmpty)
              Positioned(
                left: 48,
                right: 48,
                bottom: 20,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF191920),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF2A2A34)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _deleteSelected,
                        icon: Image.asset(
                          AppAssets.bookmarkRemove,
                          width: 22,
                          height: 22,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet<UserProgram>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddToProgramsSheet(
                              programs: [
                                UserProgram(
                                  id: 'p1',
                                  title: 'No Excuse Plan 💪',
                                  imagePath: AppAssets.programme1,
                                  workoutsCount: 3,
                                ),
                                UserProgram(
                                  id: 'p2',
                                  title: 'Built Different',
                                  imagePath: AppAssets.programme2,
                                  workoutsCount: 3,
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Image.asset(
                          AppAssets.bookmarkPlaylistPlus,
                          width: 22,
                          height: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_bookmarks.isNotEmpty) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => ShareWorkoutSheet(
                                workout: _bookmarks.first,
                              ),
                            );
                          }
                        },
                        icon: Image.asset(
                          AppAssets.bookmarkShare,
                          width: 22,
                          height: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutsList() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _bookmarks
        .where((b) => query.isEmpty || b.title.toLowerCase().contains(query))
        .toList();

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 0, 20, _isEditMode ? 88 : 20),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isSelected = _selectedIds.contains(item.id);
        return _BookmarkCard(
          item: item,
          isEditMode: _isEditMode,
          isSelected: isSelected,
          onTap: () {
            if (_isEditMode) {
              setState(() {
                if (isSelected) {
                  _selectedIds.remove(item.id);
                } else {
                  _selectedIds.add(item.id);
                }
              });
            } else {
              _openItemOptions(item);
            }
          },
          onMenuTap: () => _openItemOptions(item),
        );
      },
    );
  }

  Widget _buildProgramsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Programs created by you',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CreatedProgramsScreen(),
                    ),
                  );
                },
                child: const Text(
                  'See more',
                  style: TextStyle(
                    color: AppColors.primaryYellow,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 196,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _createdPrograms.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) =>
                  _ProgramHorizontalCard(_createdPrograms[index]),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Programs by Pump IT',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'See more',
                style: TextStyle(
                  color: AppColors.primaryYellow,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _pumpItPrograms.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) =>
                  _ProgramHorizontalCard(_pumpItPrograms[index], width: 158),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({
    required this.item,
    required this.isEditMode,
    required this.isSelected,
    required this.onTap,
    required this.onMenuTap,
  });

  final WorkoutItem item;
  final bool isEditMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

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
    return InkWell(
      onTap: onTap,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.imagePath,
                width: 68,
                height: 68,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                        decoration: BoxDecoration(
                          color: _dotColor(item.startLevel),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.startLevel,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                      if (item.endLevel != null) ...[
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
                          decoration: BoxDecoration(
                            color: _dotColor(item.endLevel!),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            item.endLevel!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.clockIcon,
                        width: 12,
                        height: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.durationMinutes} min',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.75,
                          ),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        AppAssets.caloriesIcon,
                        width: 12,
                        height: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.calories} kcal',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.75,
                          ),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        AppAssets.dumbbellIcon,
                        width: 12,
                        height: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${item.exercisesCount} exercises',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.75,
                            ),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            if (isEditMode)
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryYellow
                      : const Color(0xFF282834),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.textDark,
                      )
                    : null,
              )
            else
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    AppAssets.goalMenuIcon,
                    width: 16,
                    height: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProgramHorizontalCard extends StatelessWidget {
  const _ProgramHorizontalCard(this.item, {this.width = 140});

  final _ProgramCardItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              item.imagePath,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset(
                AppAssets.clockIcon,
                width: 12,
                height: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.72),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.scheduleLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.72),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomSheetAction extends StatelessWidget {
  const _BottomSheetAction({
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? const Color(0xFFEF4444) : AppColors.textPrimary;
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
              color: color,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color,
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

class _BookmarkTabButton extends StatelessWidget {
  const _BookmarkTabButton({
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
                  fontSize: 14,
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
