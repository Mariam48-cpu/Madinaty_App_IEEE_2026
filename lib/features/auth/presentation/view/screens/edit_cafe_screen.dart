import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:toastification/toastification.dart';

class EditCafeScreen extends StatefulWidget {
  final String cafeId;

  const EditCafeScreen({super.key, required this.cafeId});

  @override
  State<EditCafeScreen> createState() => _EditCafeScreenState();
}

class _EditCafeScreenState extends State<EditCafeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  final _openTimeController = TextEditingController();
  final _closeTimeController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCafeData();
  }

  Future<void> _fetchCafeData() async {
    if (widget.cafeId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('cafes')
          .doc(widget.cafeId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _descController.text = data['description'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _openTimeController.text = data['openTime'] ?? '';
        _closeTimeController.text = data['closeTime'] ?? '';
      }
    } catch (e) {
      if (mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: e.toString(),
          type: ToastificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('cafes')
          .doc(widget.cafeId)
          .set({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'phone': _phoneController.text.trim(),
        'openTime': _openTimeController.text.trim(),
        'closeTime': _closeTimeController.text.trim(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      AppToast.showToast(
        context: context,
        title: AppLocale.toastSuccess.getString(context),
        description: AppLocale.cafeUpdatedSuccess.getString(context),
        type: ToastificationType.success,
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: e.toString(),
          type: ToastificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocale.editCafeTitle.getString(context))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.editCafeTitle.getString(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppLocale.cafeNameLabel.getString(context),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? AppLocale.enterNameError.getString(context)
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocale.cafeDescLabel.getString(context),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: AppLocale.cafePhoneLabel.getString(context),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _openTimeController,
                      decoration: InputDecoration(
                        labelText: AppLocale.openTimeLabel.getString(context),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _closeTimeController,
                      decoration: InputDecoration(
                        labelText: AppLocale.closeTimeLabel.getString(context),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(AppLocale.saveChanges.getString(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}