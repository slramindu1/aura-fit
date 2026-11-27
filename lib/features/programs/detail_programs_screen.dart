import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../home/models/workout_item.dart';
import '../workout/sheets/add_to_programs_sheet.dart';
import '../workout/sheets/share_workout_sheet.dart';
import 'add_workouts_to_program_screen.dart';
import 'edit_program_list_screen.dart';

/// Full-screen prompt to name a newly created program (`#2 Program` -> `Easy Training`).
class GiveProgramNameScreen extends StatefulWidget {
  const GiveProgramNameScreen({super.key, this.initialName = ''});

  final String initialName;

  @override
  State<GiveProgramNameScreen> createState() => _GiveProgramNameScreenState();
}

class _GiveProgramNameScreenState extends State<GiveProgramNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              const Spacer(),
              const Text(
                'Give Your Program Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryYellow,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                cursorColor: AppColors.primaryYellow,
                decoration: InputDecoration(
                  hintText: '#2 Program',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.45),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4A4A55)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryYellow),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = _controller.text.trim();
                          Navigator.of(context).pop(
                            name.isEmpty ? '#2 Program' : name,
                          );
                        },
                        child: const Text('Create'),
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

/// Detail Programs screen supporting empty state, workout list, training goal mode,
/// workout options sheet, program options sheet, and Share Program sheet.
class DetailProgramsScreen extends StatefulWidget {
  const DetailProgramsScreen({
    super.key,
    required this.title,
    required this.imagePath,
    this.initialWorkouts = const [],
    this.initialGoalActive = false,
  });

  final String title;
  final String imagePath;
  final List<WorkoutItem> initialWorkouts;
  final bool initialGoalActive;

  @override
  State<DetailProgramsScreen> createState() => _DetailProgramsScreenState();
}

class _DetailProgramsScreenState extends State<DetailProgramsScreen> {
  late String _title;
  late String _imagePath;
  String _description = '';
  late List<WorkoutItem> _workouts;
  final Set<String> _completedIds = {};
  late bool _isGoalActive;
  bool _showGoalToast = false;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _imagePath = widget.imagePath;
    _workouts = List<WorkoutItem>.from(widget.initialWorkouts);
    _isGoalActive = widget.initialGoalActive;
  }

  Future<void> _openAddWorkouts() async {
    final chosen = await Navigator.of(context).push<List<WorkoutItem>>(
      MaterialPageRoute<List<WorkoutItem>>(
        builder: (_) => AddWorkoutsToProgramScreen(
          programTitle: _title,
          initialSelectedIds: _workouts.map((w) => w.id).toSet(),
        ),
      ),
    );
    if (chosen != null && mounted) {
      setState(() => _workouts = chosen);
    }
  }

  void _openProgramOptions() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141418),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          _imagePath,
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
                            _title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_workouts.length} Workouts',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF24242D), height: 1),
                  const SizedBox(height: 8),
                  _ProgramSheetRow(
                    iconPath: AppAssets.bookmarkRemove,
                    label: 'Delete this programs',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      Navigator.of(context).maybePop();
                    },
                  ),
                  _ProgramSheetRow(
                    iconPath: AppAssets.profileEditPen,
                    label: 'Edit Details Programs',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _openEditDetailsSheet();
                    },
                  ),
                  _ProgramSheetRow(
                    iconPath: AppAssets.bookmarkShare,
                    label: 'Share',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _openShareProgramSheet();
                    },
                  ),
                  _ProgramSheetRow(
                    iconPath: AppAssets.goalEditListIcon,
                    label: 'Edit Program List',
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      final updated =
                          await Navigator.of(context).push<List<WorkoutItem>>(
                        MaterialPageRoute<List<WorkoutItem>>(
                          builder: (_) =>
                              EditProgramListScreen(workouts: _workouts),
                        ),
                      );
                      if (updated != null && mounted) {
                        setState(() => _workouts = updated);
                      }
                    },
                  ),
                  _ProgramSheetRow(
                    iconPath: AppAssets.progCalendarPlus,
                    label: 'Set program to your training goals',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      setState(() {
                        _isGoalActive = true;
                        _showGoalToast = true;
                      });
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

  void _openEditDetailsSheet() {
    final nameController = TextEditingController(text: _title);
    final descController = TextEditingController(text: _description);
    var pendingImage = _imagePath;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF141418),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                pendingImage,
                                width: 74,
                                height: 74,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  setSheetState(() {
                                    pendingImage =
                                        pendingImage == AppAssets.bookmarkProg2
                                            ? AppAssets.bookmarkProg1
                                            : AppAssets.bookmarkProg2;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.textDark,
                                  minimumSize: const Size(120, 40),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Edit Image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Program name',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameController,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          cursorColor: AppColors.primaryYellow,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF17171E),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF282832),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryYellow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descController,
                          maxLines: 3,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          cursorColor: AppColors.primaryYellow,
                          decoration: InputDecoration(
                            hintText: 'Add Description (Optional)',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.55,
                              ),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF17171E),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF282832),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryYellow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final updatedName = nameController.text.trim();
                            setState(() {
                              if (updatedName.isNotEmpty) {
                                _title = updatedName;
                              }
                              _imagePath = pendingImage;
                              _description = descController.text.trim();
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      descController.dispose();
    });
  }

  void _openShareProgramSheet() {
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E3E48),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          _imagePath,
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
                            _title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_workouts.length} Workouts  •  ${_workouts.length} Days / Week',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Share to',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ShareProgIcon(
                        label: 'Copy Link',
                        color: AppColors.primaryYellow,
                        icon: const Icon(
                          Icons.link,
                          color: AppColors.textDark,
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(),
                      ),
                      _ShareProgIcon(
                        label: 'Whatsapp',
                        color: const Color(0xFF25D366),
                        icon: const Icon(
                          Icons.chat_bubble,
                          color: AppColors.white,
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(),
                      ),
                      _ShareProgIcon(
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        icon: Image.asset(
                          AppAssets.facebookIcon,
                          width: 24,
                          height: 24,
                          color: AppColors.white,
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(),
                      ),
                      _ShareProgIcon(
                        label: 'Instagram',
                        color: const Color(0xFFE1306C),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.white,
                        ),
                        onTap: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openWorkoutItemOptions(WorkoutItem item) {
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
                  _ProgramWorkoutCard(
                    item: item,
                    isCompleted: _completedIds.contains(item.id),
                    onTap: () {},
                    onMenuTap: () {},
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFF24242D), height: 1),
                  const SizedBox(height: 8),
                  _ProgramSheetRow(
                    iconPath: AppAssets.bookmarkRemove,
                    label: 'Remove from list',
                    isDestructive: true,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      final confirmed = await showDeleteWorkoutDialog(context);
                      if (confirmed && mounted) {
                        setState(() {
                          _workouts.removeWhere((w) => w.id == item.id);
                          _completedIds.remove(item.id);
                        });
                      }
                    },
                  ),
                  _ProgramSheetRow(
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
                  _ProgramSheetRow(
                    iconPath: AppAssets.bookmarkPlaylistPlus,
                    label: 'Add to another program',
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

  @override
  Widget build(BuildContext context) {
    final completedCount =
        _workouts.where((w) => _completedIds.contains(w.id)).length;
    final totalCount = _workouts.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AuthTopBar(),
                      const Text(
                        'Detail Programs',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: _openProgramOptions,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _imagePath,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.dumbbellIcon,
                        width: 14,
                        height: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalCount Workouts',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Image.asset(
                        AppAssets.statCalendar,
                        width: 14,
                        height: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$totalCount Days / Week',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (_isGoalActive && totalCount > 0) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 14,
                              backgroundColor: const Color(0xFF1A1A22),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryYellow,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$completedCount',
                                style: TextStyle(
                                  color: completedCount > 0
                                      ? AppColors.primaryYellow
                                      : AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' / $totalCount Completed',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),
                  if (_workouts.isEmpty)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141418),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF24242D)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.progCalendarBumble,
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'There are no workouts in this program yet  let’s add one and start training. 💪🔥',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.78,
                                ),
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: _openAddWorkouts,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Workouts'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(154, 44),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: _openAddWorkouts,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF17171E),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF282832),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.textPrimary,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Add Workout',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF17171E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF282832)),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.filterIcon,
                            width: 18,
                            height: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141418),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF24242D)),
                        ),
                        child: ListView.separated(
                          itemCount: _workouts.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _workouts[index];
                            final isDone = _completedIds.contains(item.id);
                            return _ProgramWorkoutCard(
                              item: item,
                              isCompleted: isDone,
                              onTap: () {
                                setState(() {
                                  if (isDone) {
                                    _completedIds.remove(item.id);
                                  } else {
                                    _completedIds.add(item.id);
                                  }
                                });
                              },
                              onMenuTap: () => _openWorkoutItemOptions(item),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_showGoalToast)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _showGoalToast = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Set to your training goals',
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProgramWorkoutCard extends StatelessWidget {
  const _ProgramWorkoutCard({
    required this.item,
    required this.isCompleted,
    required this.onTap,
    required this.onMenuTap,
  });

  final WorkoutItem item;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item.imagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Image.asset(
                      AppAssets.goalCompletedRibbon,
                      width: 36,
                      height: 36,
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
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.durationMinutes} min • ${item.calories} kcal • ${item.exercisesCount} exercises',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.72),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
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

class _ProgramSheetRow extends StatelessWidget {
  const _ProgramSheetRow({
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
            Image.asset(iconPath, width: 20, height: 20, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareProgIcon extends StatelessWidget {
  const _ShareProgIcon({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
