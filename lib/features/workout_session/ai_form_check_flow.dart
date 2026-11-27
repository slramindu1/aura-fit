import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';

/// 2-step phone setup guide before launching live AI Form Check.
class SetUpPhoneScreen extends StatefulWidget {
  const SetUpPhoneScreen({super.key});

  @override
  State<SetUpPhoneScreen> createState() => _SetUpPhoneScreenState();
}

class _SetUpPhoneScreenState extends State<SetUpPhoneScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final isFirst = _step == 0;
    final stepTitle = isFirst ? 'Position Your Phone' : 'Phone in Portrait';
    final stepDesc = isFirst
        ? 'Prop your phone in front of you and make sure your entire body fits in the frame before starting.'
        : 'Make sure your phone is in portrait mode before starting the session.';
    final imagePath =
        isFirst ? AppAssets.sessionSetup1 : AppAssets.sessionSetup2;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTopBar(
                      onBackTap: () {
                        if (_step > 0) {
                          setState(() => _step--);
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                    ),
                  ),
                  const Text(
                    'Set Up Phone',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.72),
                    fontSize: 13,
                  ),
                  children: [
                    const TextSpan(text: 'Step '),
                    TextSpan(
                      text: '${_step + 1}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' of 2'),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stepTitle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stepDesc,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.78),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (isFirst) {
                    setState(() => _step = 1);
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const LiveFormCheckScreen(),
                      ),
                    );
                  }
                },
                child: Text(isFirst ? 'Next' : 'Start Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Live AI Form Check overlay with pose skeleton, accuracy score, and PIP preview.
class LiveFormCheckScreen extends StatelessWidget {
  const LiveFormCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.sessionFormLive,
            fit: BoxFit.cover,
          ),
          IgnorePointer(
            child: CustomPaint(
              painter: _PoseSkeletonPainter(),
            ),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.22, 0.7, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
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
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                      const Text(
                        'Exercise 4 of 4',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17171E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF282832)),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.sessionDotsMenu,
                          width: 18,
                          height: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryYellow,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Raise Your Arms',
                        style: TextStyle(
                          color: AppColors.primaryYellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Form Accurate',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '95%',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          AppAssets.sessionExercise,
                          width: 72,
                          height: 92,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Set',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.78,
                              ),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '02 ',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '/ 03',
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.65,
                                    ),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Reps',
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.78,
                              ),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '02 ',
                                  style: TextStyle(
                                    color: AppColors.primaryYellow,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '/ 10',
                                  style: TextStyle(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.65,
                                    ),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(138, 44),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Back to Default',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.sessionPause,
                          width: 20,
                          height: 20,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Image.asset(
                        AppAssets.clockIcon,
                        width: 16,
                        height: 16,
                        color: AppColors.primaryYellow,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '01:43',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.textDark,
                            minimumSize: const Size(124, 46),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppAssets.sessionCheckCircle,
                                width: 18,
                                height: 18,
                                color: AppColors.textDark,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'End Set',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _PoseSkeletonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leftWrist = Offset(size.width * 0.24, size.height * 0.24);
    final leftElbow = Offset(size.width * 0.16, size.height * 0.40);
    final leftShoulder = Offset(size.width * 0.31, size.height * 0.54);
    final rightShoulder = Offset(size.width * 0.72, size.height * 0.54);
    final rightElbow = Offset(size.width * 0.83, size.height * 0.40);
    final rightWrist = Offset(size.width * 0.79, size.height * 0.24);

    final bonePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(leftWrist, leftElbow, bonePaint);
    canvas.drawLine(leftElbow, leftShoulder, bonePaint);
    canvas.drawLine(leftShoulder, rightShoulder, bonePaint);
    canvas.drawLine(rightShoulder, rightElbow, bonePaint);
    canvas.drawLine(rightElbow, rightWrist, bonePaint);

    final jointPaint = Paint()..color = const Color(0xFF00FF2A);
    for (final pt in [
      leftWrist,
      leftElbow,
      leftShoulder,
      rightShoulder,
      rightElbow,
      rightWrist,
    ]) {
      canvas.drawCircle(pt, 7.5, jointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
