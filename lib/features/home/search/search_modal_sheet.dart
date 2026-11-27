import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import 'search_catalog.dart';

/// Modal bottom sheet for recent searches, live suggestions, and empty states.
class SearchModalSheet extends StatefulWidget {
  const SearchModalSheet({
    super.key,
    required this.recentSearches,
    required this.onRemoveRecent,
    required this.onSubmitSearch,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onRemoveRecent;
  final ValueChanged<String> onSubmitSearch;

  @override
  State<SearchModalSheet> createState() => _SearchModalSheetState();
}

class _SearchModalSheetState extends State<SearchModalSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<String> _recentSearches;

  @override
  void initState() {
    super.initState();
    _recentSearches = List<String>.from(widget.recentSearches);
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<String> get _matchingSuggestions {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return SearchCatalog.suggestions
        .where((s) => s.toLowerCase().contains(query))
        .toList();
  }

  void _submit(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    Navigator.of(context).pop(trimmed);
    widget.onSubmitSearch(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final isFocusedOrTyping = _focusNode.hasFocus || query.isNotEmpty;
    final suggestions = _matchingSuggestions;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFF141418),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 28),
                  const Expanded(
                    child: Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
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
              const SizedBox(height: 18),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocusedOrTyping
                        ? AppColors.primaryYellow
                        : const Color(0xFF282832),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: _submit,
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
                              _controller.clear();
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
              const SizedBox(height: 20),
              Expanded(
                child: _buildBody(query, suggestions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String query, List<String> suggestions) {
    if (query.isEmpty) {
      if (_recentSearches.isEmpty) {
        return _EmptyState(
          imagePath: AppAssets.search3d,
          title: 'You Haven’t Searched Yet',
          subtitle:
              'You haven’t searched for a workout yet. Let’s find something that matches your goal.',
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent search',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.72),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _recentSearches.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final term = _recentSearches[index];
                return InkWell(
                  onTap: () => _submit(term),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          AppAssets.searchHistory,
                          width: 18,
                          height: 18,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            term,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => _recentSearches.remove(term));
                            widget.onRemoveRecent(term);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              AppAssets.closeIcon,
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
              },
            ),
          ),
        ],
      );
    }

    if (suggestions.isEmpty) {
      return _EmptyState(
        imagePath: AppAssets.searchNotFound,
        title: 'No Result Found',
        subtitle: 'We couldn’t find any workouts matching your search.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent search',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.72),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: suggestions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return InkWell(
                onTap: () => _submit(suggestion),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Image.asset(
                        AppAssets.searchArrow,
                        width: 16,
                        height: 16,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 104,
              height: 104,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
