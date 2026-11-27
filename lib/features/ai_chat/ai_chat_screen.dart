import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';
import 'widgets/ai_chat_drawer.dart';

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;
}

/// AI Personal Trainer chat screen linked to the "AI Assist" bottom bar tab.
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({
    super.key,
    this.onBackPressed,
    this.responseDelay = const Duration(milliseconds: 600),
  });

  final VoidCallback? onBackPressed;
  final Duration responseDelay;

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  static const List<String> _defaultRecentChats = [
    'Can you increase my bench press performance?',
    'I only have half an hour today.',
    'I feel like I’ve plateaued this week.',
    'My legs feel fatigued after last session.',
    'I want to lose fat but keep muscle.',
    "I'm new to the gym. Where should I start?",
    'Analyze my last two workouts.',
    'Should I increase my weight this week?',
    'My shoulder feels unstable during press.',
    'No equipment today. What can I do?',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _recentChats = List<String>.from(_defaultRecentChats);
  final List<_ChatMessage> _messages = [];
  bool _isGenerating = false;
  bool _showAttachments = false;
  Timer? _replyTimer;

  @override
  void dispose() {
    _replyTimer?.cancel();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _sendMessage([String? presetText]) {
    final text = (presetText ?? _inputController.text).trim();
    if (text.isEmpty || _isGenerating) return;

    _inputController.clear();
    setState(() {
      _showAttachments = false;
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isGenerating = true;
      _recentChats.remove(text);
      _recentChats.insert(0, text);
    });
    _scrollToBottom();

    _replyTimer?.cancel();
    _replyTimer = Timer(widget.responseDelay, () {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
        _messages.add(_ChatMessage(text: _buildAiReply(text), isUser: false));
      });
      _scrollToBottom();
    });
  }

  String _buildAiReply(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('3 workouts') || lower.contains('split')) {
      return 'Perfect.\n\n'
          'Here’s your optimized weekly split:\n\n'
          'Day 1 – Lower Strength (Heavy Compound Focus)\n\n'
          'Day 2 – Upper Heavy (Low Reps, Higher Load)\n\n'
          'Day 3 – Upper Volume & Stability (Controlled Tempo)\n\n'
          'Progression Rule:\n'
          'If all target reps are completed with proper form, load increases next week.\n\n'
          'Would you like me to activate this updated plan?';
    }
    return 'Yes 💪 I reviewed your last 2 weeks of training.\n\n'
        'Here’s what I noticed:\n\n'
        '• Bench press performance plateaued\n'
        '• Lower body strength improved steadily\n'
        '• Shoulder fatigue increased in Week 2\n\n'
        'Do you want to prioritize strength or recovery this week?';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewChat() {
    _replyTimer?.cancel();
    setState(() {
      _messages.clear();
      _isGenerating = false;
      _showAttachments = false;
    });
  }

  void _loadRecentChat(String title) {
    _replyTimer?.cancel();
    setState(() {
      _isGenerating = false;
      _showAttachments = false;
      _messages
        ..clear()
        ..add(_ChatMessage(text: title, isUser: true))
        ..add(_ChatMessage(text: _buildAiReply(title), isUser: false));
    });
  }

  Future<void> _showMessageContextMenu(
    BuildContext context,
    _ChatMessage message,
    Offset globalPosition,
  ) async {
    final selected = await showMenu<String>(
      context: context,
      color: const Color(0xFF1B1B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF2C2C36)),
      ),
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy - 140,
        20,
        0,
      ),
      items: [
        _buildMenuItem('share', AppAssets.aiShare, 'Share'),
        _buildMenuItem('select', AppAssets.aiCopy, 'Select Text'),
        _buildMenuItem('copy', AppAssets.aiCopy, 'Copy'),
        _buildMenuItem('edit', AppAssets.profileEditPen, 'Edit'),
      ],
    );

    if (!mounted || selected == null) return;
    switch (selected) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
        _showSnack('Copied to clipboard');
      case 'edit':
        _inputController.text = message.text;
      default:
        _showSnack('$selected selected');
    }
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    String iconPath,
    String label, {
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? const Color(0xFFEF4444) : AppColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Image.asset(iconPath, width: 18, height: 18, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: AiChatDrawer(
        recentChats: _recentChats,
        onSelectChat: _loadRecentChat,
        onNewChat: _startNewChat,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF242424),
            colorBlendMode: BlendMode.srcIn,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildWelcomeState()
                        : _buildMessagesList(),
                  ),
                  const SizedBox(height: 10),
                  if (_showAttachments) _buildAttachmentMenu(),
                  _buildComposer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AuthTopBar(
          onBackTap: widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
        ),
        Row(
          children: [
            InkWell(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                  AppAssets.aiSidebar,
                  width: 18,
                  height: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (_messages.isNotEmpty) ...[
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                color: const Color(0xFF1B1B22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFF2C2C36)),
                ),
                onSelected: (value) {
                  if (value == 'new' || value == 'delete') {
                    _startNewChat();
                  } else {
                    _showSnack('$value selected');
                  }
                },
                itemBuilder: (_) => [
                  _buildMenuItem('new', AppAssets.profileEditPen, 'New Chat'),
                  _buildMenuItem('share', AppAssets.aiShare, 'Share'),
                  _buildMenuItem(
                    'Archive Chat',
                    AppAssets.aiArchive,
                    'Archive Chat',
                  ),
                  _buildMenuItem('Pin Chat', AppAssets.aiPin, 'Pin Chat'),
                  _buildMenuItem(
                    'delete',
                    AppAssets.aiDelete,
                    'Delete',
                    isDestructive: true,
                  ),
                  _buildMenuItem(
                    'Report Chat',
                    AppAssets.aiReport,
                    'Report Chat',
                  ),
                ],
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
                    AppAssets.aiMenu,
                    width: 18,
                    height: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: 'Your personal trainer, ready\nto adjust ',
                        ),
                        TextSpan(
                          text: 'your plan.',
                          style: TextStyle(color: AppColors.primaryYellow),
                        ),
                        TextSpan(text: ' 💪'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 156,
                    child: Row(
                      children: [
                        Expanded(
                          child: _StarterPromptCard(
                            iconPath: AppAssets.aiCalendar,
                            text:
                                'Create a structured training split in seconds, tailored to your goals and schedule.',
                            onTap: () => _sendMessage(
                              'Can you adjust my weekly program?',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StarterPromptCard(
                            iconPath: AppAssets.aiAnalytics,
                            text:
                                'Adjust volume and intensity based on your performance for smarter, faster results.',
                            onTap: () =>
                                _sendMessage('Analyze my last two workouts.'),
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
      },
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length + (_isGenerating ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF17171E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF282832)),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          );
        }

        final msg = _messages[index];
        if (msg.isUser) {
          return Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onLongPressStart: (details) =>
                  _showMessageContextMenu(context, msg, details.globalPosition),
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 12, left: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF17171E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF282832)),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141418),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF24242D)),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _ActionIcon(
                  iconPath: AppAssets.aiCopy,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: msg.text));
                    _showSnack('Response copied');
                  },
                ),
                _ActionIcon(
                  iconPath: AppAssets.aiLike,
                  onTap: () => _showSnack('Marked helpful'),
                ),
                _ActionIcon(
                  iconPath: AppAssets.aiDislike,
                  onTap: () => _showSnack('Feedback noted'),
                ),
                _ActionIcon(
                  iconPath: AppAssets.aiShare,
                  onTap: () => _showSnack('Share response'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildAttachmentMenu() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 224,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2C2C36)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AttachmentOption(
              iconPath: AppAssets.aiImage,
              label: 'Image',
              onTap: () {
                setState(() => _showAttachments = false);
                _showSnack('Image picker selected');
              },
            ),
            _AttachmentOption(
              iconPath: AppAssets.aiCaptureImage,
              label: 'Capture Image',
              onTap: () {
                setState(() => _showAttachments = false);
                _showSnack('Camera selected');
              },
            ),
            _AttachmentOption(
              iconPath: AppAssets.aiFile,
              label: 'File',
              onTap: () {
                setState(() => _showAttachments = false);
                _showSnack('File picker selected');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141418),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF282832)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.aiStars,
                width: 18,
                height: 18,
                color: AppColors.primaryYellow,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  cursorColor: AppColors.primaryYellow,
                  decoration: InputDecoration(
                    hintText: 'Ask anything...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.72),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() => _showAttachments = !_showAttachments);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B22),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF282832)),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    _showAttachments ? AppAssets.closeIcon : AppAssets.aiPlus,
                    width: 18,
                    height: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showSnack('Voice input activated'),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B22),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF282832)),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.aiMic,
                    width: 18,
                    height: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.aiSend,
                    width: 18,
                    height: 18,
                    color: AppColors.textDark,
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

class _StarterPromptCard extends StatelessWidget {
  const _StarterPromptCard({
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  final String iconPath;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141418),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF24242D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              width: 18,
              height: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.85),
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.iconPath,
    required this.onTap,
  });

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          iconPath,
          width: 16,
          height: 16,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 18,
              height: 18,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
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
