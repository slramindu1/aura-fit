import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/auth_top_bar.dart';
import '../models/workout_item.dart';
import '../widgets/home_workout_cards.dart';
import 'filter_bottom_sheet.dart';
import 'search_catalog.dart';

/// Full-screen search results view with Workouts/Programs tabs and Filter sheet.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.initialQuery,
    this.onWorkoutSelected,
  });

  final String initialQuery;
  final ValueChanged<WorkoutItem>? onWorkoutSelected;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _searchController;
  int _selectedTab = 0; // 0 = Workouts, 1 = Programs
  WorkoutFilter _filter = const WorkoutFilter();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<WorkoutFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(initialFilter: _filter),
    );
    if (result != null) {
      setState(() => _filter = result);
    }
  }

  List<WorkoutItem> get _filteredItems {
    final query = _searchController.text;
    final wantPrograms = _selectedTab == 1;

    return SearchCatalog.allWorkouts.where((item) {
      if (item.isProgram != wantPrograms) return false;
      if (!SearchCatalog.matchesQuery(item.title, query)) return false;
      if (!SearchCatalog.matchesFilter(item, _filter)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final items = _filteredItems;
    final activeFilterCount = _filter.activeCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTopBar(),
                  ),
                  const Text(
                    'Search',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF17171E),
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
                    hintText: 'Search Workouts, Programs etc',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Image.asset(
                        AppAssets.searchIcon,
                        width: 20,
                        height: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: Image.asset(
                              AppAssets.clearCircleIcon,
                              width: 18,
                              height: 18,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Search Result ',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.72,
                              ),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: query.isEmpty ? '' : '“$query”',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: _openFilterSheet,
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF17171E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF282832),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.filterIcon,
                            width: 20,
                            height: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (activeFilterCount > 0)
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryYellow,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$activeFilterCount',
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _TabItem(
                    label: 'Workouts',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  _TabItem(
                    label: 'Programs',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppAssets.searchNotFound,
                                width: 104,
                                height: 104,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No Result Found',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We couldn’t find any workouts matching your search.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.72,
                                  ),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return OtherWorkoutCard(
                            workout: item,
                            onTap: () {
                              widget.onWorkoutSelected?.call(item);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
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
