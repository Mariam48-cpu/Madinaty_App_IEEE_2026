import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/utils/app_toast.dart';
import '../../view_model/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String currentName;
  final String currentPhone;
  final String currentEmail;
  final String? currentImageUrl;
  final String? currentBirthDate;

  const EditProfileScreen({
    super.key,
    required this.uid,
    required this.currentName,
    required this.currentPhone,
    required this.currentEmail,
    this.currentImageUrl,
    this.currentBirthDate,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;

  File? _selectedImage;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _emailController = TextEditingController(text: widget.currentEmail);

    String formattedDate = '';
    if (widget.currentBirthDate != null &&
        widget.currentBirthDate!.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(widget.currentBirthDate!);
        formattedDate =
        "${parsedDate.day} / ${parsedDate.month} / ${parsedDate.year}";
        _selectedBirthDate = parsedDate;
      } catch (_) {
        formattedDate = widget.currentBirthDate!;
      }
    }

    _birthDateController = TextEditingController(text: formattedDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } catch (e) {
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        title: AppLocale.toastError.getString(context),
        description: e.toString(),
        type: ToastificationType.error,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
        "${picked.day} / ${picked.month} / ${picked.year}";
      });
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            AppLocale.deleteAccountTitle.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            AppLocale.deleteAccountConfirmMessage.getString(context),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppLocale.dialogNo.getString(context),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ProfileCubit>().deleteAccount();
              },
              child: Text(
                AppLocale.dialogYes.getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocale.editProfileTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            AppToast.showToast(
              context: context,
              title: AppLocale.toastSuccess.getString(context),
              description: AppLocale.profileUpdatedSuccess.getString(context),
              type: ToastificationType.success,
            );
            Navigator.pop(context);
          }

          if (state is ProfileAccountDeleted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/auth',
                  (route) => false,
            );
          }

          if (state is ProfileError) {
            AppToast.showToast(
              context: context,
              title: AppLocale.toastError.getString(context),
              description: state.message,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          final bool isUpdating = state is ProfileUpdating;
          final bool isDeleting = state is ProfileDeleting;
          final bool isBusy = isUpdating || isDeleting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.surfaceVariant,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (widget.currentImageUrl != null &&
                                widget.currentImageUrl!.isNotEmpty)
                                ? NetworkImage(widget.currentImageUrl!)
                                : const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                            ),
                          ),
                          InkWell(
                            onTap: isBusy ? null : _pickImage,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.darkButton,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.onDarkButton,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: isBusy ? null : _pickImage,
                        child: Text(
                          AppLocale.changePhoto.getString(context),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.name.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        enabled: !isBusy,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        AppLocale.emailOrPhone.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        enabled: false,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.border.withValues(alpha: 0.3),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        AppLocale.phoneNumberLabel.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _phoneController,
                        enabled: !isBusy,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        AppLocale.birthDateLabel.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: isBusy ? null : () => _selectDate(context),
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed:
                            isBusy ? null : () => _selectDate(context),
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkButton,
                      foregroundColor: AppColors.onDarkButton,
                      disabledBackgroundColor:
                      AppColors.darkButton.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isBusy
                        ? null
                        : () {
                      final name = _nameController.text.trim();
                      final phone = _phoneController.text.trim();

                      if (name.isEmpty) {
                        AppToast.showToast(
                          context: context,
                          title: AppLocale.toastError.getString(context),
                          description: AppLocale.enterNameError
                              .getString(context),
                          type: ToastificationType.error,
                        );
                        return;
                      }

                      context.read<ProfileCubit>().updateProfile(
                        uid: widget.uid,
                        name: name,
                        phone: phone,
                        birthDate: _selectedBirthDate,
                        imageFile: _selectedImage,
                      );
                    },
                    child: isUpdating
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      AppLocale.saveChanges.getString(context),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isBusy ? null : _showDeleteAccountDialog,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 18,
                    ),
                    label: Text(
                      AppLocale.deleteAccountBtn.getString(context),
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                if (isDeleting) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocale.deletingAccountProgress.getString(context),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}