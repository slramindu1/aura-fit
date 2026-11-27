import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

/// Horizontal scrollable number picker framed by two vertical yellow lines.
class HorizontalNumberPicker extends StatefulWidget {
  const HorizontalNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  State<HorizontalNumberPicker> createState() => _HorizontalNumberPickerState();
}

class _HorizontalNumberPickerState extends State<HorizontalNumberPicker> {
  late final PageController _pageController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.clamp(
      widget.minValue,
      widget.maxValue,
    );
    _pageController = PageController(
      initialPage: _selectedValue - widget.minValue,
      viewportFraction: 0.24,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.maxValue - widget.minValue + 1;

    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: totalCount,
            onPageChanged: (index) {
              final value = widget.minValue + index;
              setState(() => _selectedValue = value);
              widget.onChanged(value);
            },
            itemBuilder: (context, index) {
              final value = widget.minValue + index;
              final distance = (value - _selectedValue).abs();
              final isSelected = distance == 0;
              final opacity = isSelected
                  ? 1.0
                  : distance == 1
                      ? 0.72
                      : 0.25;

              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  );
                },
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 160),
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: opacity),
                      fontSize: isSelected ? 34 : 26,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                    child: Text('$value'),
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 2,
                  height: 76,
                  color: AppColors.primaryYellow,
                ),
                const SizedBox(width: 92),
                Container(
                  width: 2,
                  height: 76,
                  color: AppColors.primaryYellow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive 5-stop training days slider (`1`, `2`, `3`, `4`, `5+`).
class TrainingDaysSlider extends StatelessWidget {
  const TrainingDaysSlider({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const List<String> labels = ['1', '2', '3', '4', '5+'];

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  void _updateFromLocalDx(double dx, double width) {
    if (width <= 0) return;
    final ratio = (dx / width).clamp(0.0, 1.0);
    final index = (ratio * (labels.length - 1)).round();
    if (index != selectedIndex) {
      onChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = selectedIndex / (labels.length - 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            const thumbSize = 48.0;
            final thumbLeft =
                (trackWidth - thumbSize) * progress.clamp(0.0, 1.0);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) =>
                  _updateFromLocalDx(details.localPosition.dx, trackWidth),
              onHorizontalDragUpdate: (details) =>
                  _updateFromLocalDx(details.localPosition.dx, trackWidth),
              child: SizedBox(
                height: 68,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF282832),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primaryYellow.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0.04, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      left: thumbLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: thumbSize,
                            height: thumbSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFF151519),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryYellow,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppAssets.trainingMuscle,
                              fit: BoxFit.contain,
                            ),
                          ),
                          CustomPaint(
                            size: const Size(14, 7),
                            painter: _ThumbPointerPainter(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onChanged(index),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ThumbPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryYellow
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
