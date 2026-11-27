import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import '../workout/sheets/add_to_programs_sheet.dart';

/// Screen listing user-created programs with search and "+ New Program" creation.
class CreatedProgramsScreen extends StatefulWidget {
  const CreatedProgramsScreen({super.key});

  @override
  State<CreatedProgramsScreen> createState() => _CreatedProgramsScreenState();
}

class _CreatedProgramsScreenState extends State<CreatedProgramsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserProgram> _programs = [
    const UserProgram(
      id: 'cp_1',
      title: 'No Excuse Plan 💪',
      imagePath: AppAssets.programme1,
      workoutsCount: 3,
    ),
    const UserProgram(
      id: 'cp_2',
      title: 'Built Different',
      imagePath: AppAssets.bookmarkProg1,
      workoutsCount: 3,
    ),
    const UserProgram(
      id: 'cp_3',
      title: 'Easy Training',
      imagePath: AppAssets.bookmarkProg2,
      workoutsCount: 2,
    ),
  ];

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
                  setState(() {
                    _programs.add(
                      UserProgram(
                        id: 'cp_${_programs.length + 1}',
                        title: title,
                        imagePath: AppAssets.bookmarkProg2,
                        workoutsCount: 0,
                      ),
                    );
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
                    'Created Programs',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: _createNewProgram,
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
                        Icons.add,
                        color: AppColors.primaryYellow,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
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
                    for (final prog in filtered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                prog.imagePath,
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
                                    prog.title,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    prog.workoutsCount == 2
                                        ? '2 Workout'
                                        : '${prog.workoutsCount} Workouts',
                                    style: TextStyle(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.72,
                                      ),
                                      fontSize: 13,
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
                              color: const Color(0xFF17171E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add,
                              color: AppColors.textPrimary,
                              size: 22,
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
            ],
          ),
        ),
      ),
    );
  }
}
