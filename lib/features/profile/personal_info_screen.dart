import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../auth/widgets/auth_top_bar.dart';

/// Personal Information view/edit screen with avatar change dialog.
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _fullnameController =
      TextEditingController(text: 'Sam Porter');
  final TextEditingController _usernameController =
      TextEditingController(text: '@porterbridgessam2222');
  final TextEditingController _phoneController =
      TextEditingController(text: '728 7230 0324');

  bool _isEditing = false;
  String _height = '178';
  String _weight = '90';
  String _experienceLevel = 'Beginner';
  String _avatarPath = AppAssets.profileAvatar;

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openChangeImageDialog() {
    var pendingAvatar = _avatarPath;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final changed = pendingAvatar != _avatarPath;
            return Dialog(
              backgroundColor: const Color(0xFF141418),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        pendingAvatar,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setDialogState(() {
                            pendingAvatar = pendingAvatar ==
                                    AppAssets.profileAvatar
                                ? AppAssets.maleIcon
                                : AppAssets.profileAvatar;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.textDark,
                          minimumSize: const Size(140, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Change Image',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _avatarPath = pendingAvatar);
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: changed
                            ? AppColors.primaryYellow
                            : AppColors.primaryYellow.withValues(alpha: 0.72),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveChanges() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Profile details saved'),
          behavior: SnackBarBehavior.floating,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AuthTopBar(),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _isEditing = !_isEditing),
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
                        _isEditing
                            ? AppAssets.profileClose
                            : AppAssets.profileEditPen,
                        width: 18,
                        height: 18,
                        color: _isEditing
                            ? const Color(0xFFEF4444)
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              _avatarPath,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: InkWell(
                              onTap: _openChangeImageDialog,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  AppAssets.profileEditBadge,
                                  width: 14,
                                  height: 14,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _InfoField(
                        label: 'Fullname',
                        controller: _fullnameController,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      _InfoField(
                        label: 'Username',
                        controller: _usernameController,
                        enabled: _isEditing,
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
                                enabled: _isEditing,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                ),
                                cursorColor: AppColors.primaryYellow,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DropdownField(
                        label: 'Height',
                        value: _height,
                        items: const ['165', '170', '175', '178', '182', '188'],
                        isEditing: _isEditing,
                        onChanged: (v) {
                          if (v != null) setState(() => _height = v);
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField(
                        label: 'Weight',
                        value: _weight,
                        items: const ['70', '80', '85', '90', '95', '100'],
                        isEditing: _isEditing,
                        onChanged: (v) {
                          if (v != null) setState(() => _weight = v);
                        },
                      ),
                      const SizedBox(height: 16),
                      _DropdownField(
                        label: 'Experience Level',
                        value: _experienceLevel,
                        items: const ['Beginner', 'Medium', 'Intermediate'],
                        isEditing: _isEditing,
                        onChanged: (v) {
                          if (v != null) setState(() => _experienceLevel = v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          cursorColor: AppColors.primaryYellow,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF17171E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF282832)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF282832)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryYellow),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.isEditing,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final bool isEditing;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF17171E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF282832)),
          ),
          child: isEditing
              ? DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A22),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textPrimary,
                    ),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                    items: items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
