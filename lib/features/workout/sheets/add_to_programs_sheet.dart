import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Data model for a user workout program.
class UserProgram {
  const UserProgram({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.workoutsCount,
  });

  final String id;
  final String title;
  final String imagePath;
  final int workoutsCount;
}

/// Bottom sheet allowing the user to add a workout to one of their programs.
class AddToProgramsSheet extends StatefulWidget {
  const AddToProgramsSheet({
    super.key,
    required this.programs,
    this.initialSelectedId,
  });

  final List<UserProgram> programs;
  final String? initialSelectedId;

  @override
  State<AddToProgramsSheet> createState() => _AddToProgramsSheetState();
}

class _AddToProgramsSheetState extends State<AddToProgramsSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<UserProgram> _programs;
  String? _selectedProgramId;

  @override
  void initState() {
    super.initState();
    _programs = List<UserProgram>.from(widget.programs);
    _selectedProgramId = widget.initialSelectedId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _createNewProgram() {
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A22),
          title: const Text(
            'New Program',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.textPrimary),
            cursorColor: AppColors.primaryYellow,
            decoration: const InputDecoration(
              hintText: 'Program name',
              hintStyle: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = nameController.text.trim();
                if (title.isNotEmpty) {
                  final newProgram = UserProgram(
                    id: 'prog_${_programs.length + 1}',
                    title: title,
                    imagePath: AppAssets.programme2,
                    workoutsCount: 1,
                  );
                  setState(() {
                    _programs.add(newProgram);
                    _selectedProgramId = newProgram.id;
                  });
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Create',
                style: TextStyle(color: AppColors.primaryYellow),
              ),
            ),
          ],
        );
      },
    ).then((_) => nameController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _programs
        .where((p) => query.isEmpty || p.title.toLowerCase().contains(query))
        .toList();

    UserProgram? selectedProgram;
    if (_selectedProgramId != null) {
      for (final p in _programs) {
        if (p.id == _selectedProgramId) {
          selectedProgram = p;
          break;
        }
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add to Programs',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    onTap: _createNewProgram,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.primaryYellow,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'New Program',
                            style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF282832)),
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
                    hintText: 'Search Programs',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    for (final program in filtered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedProgramId =
                                  _selectedProgramId == program.id
                                      ? null
                                      : program.id;
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
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.72),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedProgramId == program.id)
                                Image.asset(
                                  AppAssets.workoutSuccess,
                                  width: 24,
                                  height: 24,
                                )
                              else
                                Image.asset(
                                  AppAssets.workoutPlus,
                                  width: 24,
                                  height: 24,
                                  color: AppColors.textPrimary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: _createNewProgram,
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'New Program',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedProgram != null) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedProgram);
                  },
                  child: const Text('Save'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
