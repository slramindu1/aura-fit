import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/models/workout_item.dart';
import '../../home/widgets/home_workout_cards.dart';

/// Bottom sheet for sharing a workout to social apps or copying its link.
class ShareWorkoutSheet extends StatelessWidget {
  const ShareWorkoutSheet({
    super.key,
    required this.workout,
  });

  final WorkoutItem workout;

  void _onShareTap(BuildContext context, String target) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            target == 'Copy Link'
                ? 'Link copied for ${workout.title}'
                : 'Shared ${workout.title} to $target',
          ),
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
              OtherWorkoutCard(
                workout: workout,
                onTap: () {},
              ),
              const SizedBox(height: 22),
              const Text(
                'Share to',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShareTargetButton(
                    label: 'Copy Link',
                    background: const BoxDecoration(
                      color: AppColors.primaryYellow,
                      shape: BoxShape.circle,
                    ),
                    icon: const Icon(
                      Icons.link,
                      color: AppColors.textDark,
                      size: 26,
                    ),
                    onTap: () => _onShareTap(context, 'Copy Link'),
                  ),
                  _ShareTargetButton(
                    label: 'Whatsapp',
                    background: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    icon: const Icon(
                      Icons.chat_bubble,
                      color: AppColors.white,
                      size: 24,
                    ),
                    onTap: () => _onShareTap(context, 'Whatsapp'),
                  ),
                  _ShareTargetButton(
                    label: 'Facebook',
                    background: const BoxDecoration(
                      color: Color(0xFF1877F2),
                      shape: BoxShape.circle,
                    ),
                    icon: Image.asset(
                      AppAssets.facebookIcon,
                      width: 26,
                      height: 26,
                      color: AppColors.white,
                    ),
                    onTap: () => _onShareTap(context, 'Facebook'),
                  ),
                  _ShareTargetButton(
                    label: 'Instagram',
                    background: const BoxDecoration(
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
                      size: 26,
                    ),
                    onTap: () => _onShareTap(context, 'Instagram'),
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

class _ShareTargetButton extends StatelessWidget {
  const _ShareTargetButton({
    required this.label,
    required this.background,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final BoxDecoration background;
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
            width: 54,
            height: 54,
            decoration: background,
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
