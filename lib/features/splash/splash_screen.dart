import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';

/// Initial splash screen featuring the patterned dumbbell backdrop and centered logo.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.autoNavigate = true,
    this.splashDuration = const Duration(milliseconds: 2200),
  });

  /// Whether to automatically navigate to [OnboardingScreen] after [splashDuration].
  final bool autoNavigate;

  /// Delay before transitioning to onboarding.
  final Duration splashDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _navigationTimer;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    if (widget.autoNavigate) {
      _navigationTimer = Timer(widget.splashDuration, _goToOnboarding);
    }
  }

  void _goToOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.splashBg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF282828),
            colorBlendMode: BlendMode.srcIn,
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  AppAssets.logo,
                  width: 96,
                  height: 96,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
