import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_text_field.dart';
import 'reminders_screen.dart';
import 'widgets/personalize_option_cards.dart';
import 'widgets/personalize_pickers.dart';
import 'widgets/personalize_scaffold.dart';

/// Seven-step personalization questionnaire (`01/07` through `07/07`).
class PersonalizeFlowScreen extends StatefulWidget {
  const PersonalizeFlowScreen({super.key});

  @override
  State<PersonalizeFlowScreen> createState() => _PersonalizeFlowScreenState();
}

class _PersonalizeFlowScreenState extends State<PersonalizeFlowScreen> {
  static const int _totalSteps = 7;

  static const List<({String icon, String title})> _trainingGoals = [
    (icon: AppAssets.trainingMuscle, title: 'Build Muscle'),
    (icon: AppAssets.trainingFat, title: 'Lose Fat'),
    (icon: AppAssets.trainingStrength, title: 'Increase Strength'),
    (icon: AppAssets.trainingForm, title: 'Improve Form'),
    (icon: AppAssets.trainingConsistent, title: 'Stay Consistent'),
  ];

  static const List<({String icon, String title, String subtitle})>
      _experienceLevels = [
    (
      icon: AppAssets.experienceBeginner,
      title: 'Beginner',
      subtitle: 'Just getting started',
    ),
    (
      icon: AppAssets.experienceMedium,
      title: 'Medium',
      subtitle: 'Training consistently for 6+ months',
    ),
    (
      icon: AppAssets.experienceIntermediate,
      title: 'Intermediate',
      subtitle: 'Performance progression',
    ),
  ];

  static const List<({String icon, String title, String subtitle})>
      _trainingLocations = [
    (
      icon: AppAssets.experienceBeginner,
      title: 'Home',
      subtitle: 'Dumbbells only',
    ),
    (
      icon: AppAssets.trainingMuscle,
      title: 'Home',
      subtitle: 'No Equipment',
    ),
    (
      icon: AppAssets.trainingMuscle,
      title: 'Gym',
      subtitle: 'Full Equipment',
    ),
  ];

  int _currentStep = 0;

  // Step 01 state
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Male';

  // Step 02 & 03 state
  int _weightKg = 90;
  int _heightCm = 178;

  // Step 04 state
  final Set<int> _selectedGoals = {0};

  // Step 05 state
  int _selectedExperience = 0;

  // Step 06 state
  int _selectedLocation = 0;

  // Step 07 state
  int _selectedDaysIndex = 2; // '3' days

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _onContinue() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RemindersScreen(),
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0:
        return 'Complete your profile';
      case 1:
        return 'What is your weight?';
      case 2:
        return 'What is your height?';
      case 3:
        return 'What Are You Training For?';
      case 4:
        return 'What’s Your Experience Level ?';
      case 5:
        return 'Where Do You Train ?';
      case 6:
        return 'Ready To Commit?';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepNumber = (_currentStep + 1).toString().padLeft(2, '0');
    final progress = (_currentStep + 1) / _totalSteps;

    return PersonalizeScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  stepNumber,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' / 0$_totalSteps',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.65),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFF34343D),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryYellow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _stepTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 22),
            Expanded(child: _buildStepBody()),
            const SizedBox(height: 16),
            PersonalizeBottomButtons(
              secondaryLabel: 'Back',
              primaryLabel: 'Continue',
              onSecondaryPressed: _onBack,
              onPrimaryPressed: _onContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBody() {
    switch (_currentStep) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: 'Fullname',
                hintText: 'Sam Porter',
                controller: _fullnameController,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Username',
                hintText: '@porterbridgessam2222',
                controller: _usernameController,
              ),
              const SizedBox(height: 16),
              const Text(
                'Phone Number',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF17171E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF282832)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.usFlag,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '+1',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        cursorColor: AppColors.primaryYellow,
                        decoration: InputDecoration(
                          hintText: '728 7230 0324',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.45,
                            ),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gender',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GenderOptionCard(
                      iconPath: AppAssets.maleIcon,
                      label: 'Male',
                      isSelected: _selectedGender == 'Male',
                      onTap: () => setState(() => _selectedGender = 'Male'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GenderOptionCard(
                      iconPath: AppAssets.femaleIcon,
                      label: 'Female',
                      isSelected: _selectedGender == 'Female',
                      onTap: () => setState(() => _selectedGender = 'Female'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 1:
        return Center(
          child: HorizontalNumberPicker(
            key: const ValueKey<String>('weight_picker'),
            minValue: 30,
            maxValue: 200,
            initialValue: _weightKg,
            onChanged: (value) => _weightKg = value,
          ),
        );
      case 2:
        return Center(
          child: HorizontalNumberPicker(
            key: const ValueKey<String>('height_picker'),
            minValue: 120,
            maxValue: 220,
            initialValue: _heightCm,
            onChanged: (value) => _heightCm = value,
          ),
        );
      case 3:
        return ListView.separated(
          itemCount: _trainingGoals.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final goal = _trainingGoals[index];
            return PersonalizeOptionCard(
              iconPath: goal.icon,
              title: goal.title,
              isSelected: _selectedGoals.contains(index),
              onTap: () {
                setState(() {
                  if (_selectedGoals.contains(index)) {
                    if (_selectedGoals.length > 1) {
                      _selectedGoals.remove(index);
                    }
                  } else {
                    _selectedGoals.add(index);
                  }
                });
              },
            );
          },
        );
      case 4:
        return ListView.separated(
          itemCount: _experienceLevels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final level = _experienceLevels[index];
            return PersonalizeOptionCard(
              iconPath: level.icon,
              title: level.title,
              subtitle: level.subtitle,
              isSelected: _selectedExperience == index,
              onTap: () => setState(() => _selectedExperience = index),
            );
          },
        );
      case 5:
        return GridView.builder(
          itemCount: _trainingLocations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final loc = _trainingLocations[index];
            return PersonalizeGridCard(
              iconPath: loc.icon,
              title: loc.title,
              subtitle: loc.subtitle,
              isSelected: _selectedLocation == index,
              onTap: () => setState(() => _selectedLocation = index),
            );
          },
        );
      case 6:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How many days per week can you train?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            TrainingDaysSlider(
              selectedIndex: _selectedDaysIndex,
              onChanged: (index) =>
                  setState(() => _selectedDaysIndex = index),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
