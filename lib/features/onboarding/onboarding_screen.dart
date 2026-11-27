import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_welcome_screen.dart';

/// Immutable data model for a single onboarding slide.
class _OnboardingSlide {
  const _OnboardingSlide({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;
}

/// Three-step onboarding carousel with segmented progress indicator and CTA.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      imagePath: AppAssets.onboarding1,
      title: 'STOP WASTING REPS.',
      subtitle:
          'Most people train with poor form. Slow progress.\nHigher injury risk.',
    ),
    _OnboardingSlide(
      imagePath: AppAssets.onboarding2,
      title: 'MEET YOUR AI COACH.',
      subtitle:
          'Real time form correction. Instant feedback.\nSmarter results.',
    ),
    _OnboardingSlide(
      imagePath: AppAssets.onboarding3,
      title: 'WHAT’S YOUR GOAL?',
      subtitle:
          'Your training should match your ambition and your ambition deserves the right plan.',
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const AuthWelcomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _slides[index].imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 0.68, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                    const Color(0xFF0A0A0C),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Column(
                      key: ValueKey<int>(_currentPage),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSlide.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentSlide.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SegmentedProgressBar(
                    totalSteps: _slides.length,
                    activeStep: _currentPage,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleNext,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({
    required this.totalSteps,
    required this.activeStep,
  });

  final int totalSteps;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= activeStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3.5,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryYellow
                    : AppColors.progressInactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
