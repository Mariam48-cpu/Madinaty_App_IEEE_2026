import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference<Map<String, dynamic>>? get _addressesCollection {
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('addresses');
  }

  void _showAddAddressDialog() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            AppLocale.addNewAddress.getString(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppLocale.addressNameLabel.getString(context),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: AppLocale.addressDetailsLabel.getString(context),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocale.dialogNo.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final title = titleController.text.trim();
                final address = addressController.text.trim();

                if (title.isEmpty || address.isEmpty) return;

                final parentContext = context;
                final successTitle = AppLocale.toastSuccess.getString(context);
                final successDesc = AppLocale.preferencesSavedSuccess.getString(context);

                Navigator.pop(context);

                if (_addressesCollection != null) {
                  await _addressesCollection!.add({
                    'title': title,
                    'address': address,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  if (mounted) {
                    AppToast.showToast(
                      context: parentContext,
                      title: successTitle,
                      description: successDesc,
                      type: ToastificationType.success,
                    );
                  }
                }
              },
              child: Text(AppLocale.saveChanges.getString(context)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAddress(String docId) async {
    if (_addressesCollection != null) {
      await _addressesCollection!.doc(docId).delete();
      if (mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastSuccess.getString(context),
          description: AppLocale.addressDeletedSuccess.getString(context),
          type: ToastificationType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.savedAddresses.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _showAddAddressDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          AppLocale.newAddressBtn.getString(context),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                AppLocale.loginRequiredToProceed.getString(context),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _addressesCollection
                  ?.orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocale.noSavedAddresses.getString(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocale.addAddressPrompt.getString(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final title = data['title']?.toString() ?? AppLocale.addressDefaultTitle.getString(context);
                    final address = data['address']?.toString() ?? '';

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => _deleteAddress(doc.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
