import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

/// Post-workout screen for capturing/changing a summary photo, sharing, or commenting.
class WorkoutCompleteCaptureScreen extends StatefulWidget {
  const WorkoutCompleteCaptureScreen({super.key});

  @override
  State<WorkoutCompleteCaptureScreen> createState() =>
      _WorkoutCompleteCaptureScreenState();
}

class _WorkoutCompleteCaptureScreenState
    extends State<WorkoutCompleteCaptureScreen> {
  bool _hasCaptured = false;

  void _openShareSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PostWorkoutShareSheet(),
    );
  }

  void _openFeedbackScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const WorkoutFeedbackScreen(),
      ),
    );
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
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
                      AppAssets.closeIcon,
                      width: 18,
                      height: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  _hasCaptured
                      ? AppAssets.sessionResultPhoto
                      : AppAssets.sessionResultBanner,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () => setState(() => _hasCaptured = !_hasCaptured),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17171E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF282832)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        _hasCaptured
                            ? AppAssets.profileEditPen
                            : AppAssets.sessionCaptureIcon,
                        width: 18,
                        height: 18,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _hasCaptured ? 'Change Image' : 'Capture Image',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                        onPressed: _openShareSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.textDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Share Workout'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _openFeedbackScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.textDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add Comment'),
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

/// Share card bottom sheet featuring photo, stats overlay, and social targets.
class PostWorkoutShareSheet extends StatelessWidget {
  const PostWorkoutShareSheet({super.key});

  void _shareTo(BuildContext context, String target) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Shared workout card to $target'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryYellow,
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          AppAssets.sessionResultPhoto,
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.45, 1.0],
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.85),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 16,
                          right: 16,
                          bottom: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ShareStatColumn(
                                label: 'Calorie Burn',
                                value: '320 kcal',
                              ),
                              _ShareStatColumn(
                                label: 'Total time',
                                value: '40 :32',
                              ),
                              _ShareStatColumn(
                                label: 'Exercise',
                                value: '4',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      color: AppColors.primaryYellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: const Text(
                        'I just crushed my workout  who’s ready to\ntrain with me? 💪🔥',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                  _ShareCircle(
                    label: 'Copy Link',
                    decoration: const BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    icon: const Icon(
                      Icons.link,
                      color: AppColors.textDark,
                      size: 24,
                    ),
                    onTap: () => _shareTo(context, 'Copy Link'),
                  ),
                  _ShareCircle(
                    label: 'Whatsapp',
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    icon: const Icon(
                      Icons.chat_bubble,
                      color: AppColors.white,
                      size: 22,
                    ),
                    onTap: () => _shareTo(context, 'Whatsapp'),
                  ),
                  _ShareCircle(
                    label: 'Facebook',
                    decoration: const BoxDecoration(
                      color: Color(0xFF1877F2),
                      shape: BoxShape.circle,
                    ),
                    icon: Image.asset(
                      AppAssets.facebookIcon,
                      width: 24,
                      height: 24,
                      color: AppColors.white,
                    ),
                    onTap: () => _shareTo(context, 'Facebook'),
                  ),
                  _ShareCircle(
                    label: 'Instagram',
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF833AB4),
                          Color(0xFFE1306C),
                          Color(0xFFF77737),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.white,
                      size: 24,
                    ),
                    onTap: () => _shareTo(context, 'Instagram'),
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

/// Post-workout rating & comment screen ("You Nailed it !").
class WorkoutFeedbackScreen extends StatefulWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  State<WorkoutFeedbackScreen> createState() => _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends State<WorkoutFeedbackScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _rating > 0 || _commentController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.of(context).maybePop(),
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
                              AppAssets.closeIcon,
                              width: 18,
                              height: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'You Nailed it !',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ShareStatColumn(
                            label: 'Calorie Burn',
                            value: '320 kcal',
                          ),
                          _ShareStatColumn(
                            label: 'Total time',
                            value: '40 :32',
                          ),
                          _ShareStatColumn(label: 'Exercise', value: '4'),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final filled = index < _rating;
                          return IconButton(
                            onPressed: () =>
                                setState(() => _rating = index + 1),
                            icon: Icon(
                              Icons.star_rounded,
                              size: 38,
                              color: filled
                                  ? AppColors.primaryYellow
                                  : AppColors.primaryYellow.withValues(
                                      alpha: 0.38,
                                    ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _commentController,
                        maxLines: 5,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        cursorColor: AppColors.primaryYellow,
                        decoration: InputDecoration(
                          hintText: 'Add Comments',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.65,
                            ),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF17171E),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF282832),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryYellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: canSubmit
                    ? () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Workout feedback submitted!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit
                      ? AppColors.primaryYellow
                      : AppColors.primaryYellow.withValues(alpha: 0.65),
                  disabledBackgroundColor: AppColors.primaryYellow.withValues(
                    alpha: 0.65,
                  ),
                  disabledForegroundColor: AppColors.textDark.withValues(
                    alpha: 0.6,
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareStatColumn extends StatelessWidget {
  const _ShareStatColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ShareCircle extends StatelessWidget {
  const _ShareCircle({
    required this.label,
    required this.decoration,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final BoxDecoration decoration;
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
            decoration: decoration,
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
