import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/settings_screen.dart';

/// Slide-over drawer showing searchable recent AI chats, New Chat CTA, and Settings.
class AiChatDrawer extends StatefulWidget {
  const AiChatDrawer({
    super.key,
    required this.recentChats,
    required this.onSelectChat,
    required this.onNewChat,
  });

  final List<String> recentChats;
  final ValueChanged<String> onSelectChat;
  final VoidCallback onNewChat;

  @override
  State<AiChatDrawer> createState() => _AiChatDrawerState();
}

class _AiChatDrawerState extends State<AiChatDrawer> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = widget.recentChats
        .where((c) => query.isEmpty || c.toLowerCase().contains(query))
        .toList();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: const Color(0xFF121216),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A22),
                        borderRadius: BorderRadius.circular(10),
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
                          hintText: 'Search Chat',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              AppAssets.searchIcon,
                              width: 18,
                              height: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF282832)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        AppAssets.closeIcon,
                        width: 18,
                        height: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'RECENT CHATS',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.65),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final title = filtered[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onSelectChat(title);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNewChat();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.profileEditPen,
                        width: 18,
                        height: 18,
                        color: AppColors.textDark,
                      ),
                      const SizedBox(width: 8),
                      const Text('New Chat'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssets.profileSetting,
                        width: 20,
                        height: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
