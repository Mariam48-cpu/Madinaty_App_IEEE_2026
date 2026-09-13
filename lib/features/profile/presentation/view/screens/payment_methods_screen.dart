import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:toastification/toastification.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethodId = 'card';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedPaymentMethod();
  }

  Future<void> _loadSelectedPaymentMethod() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['defaultPaymentMethod'] != null) {
          setState(() {
            _selectedMethodId = data['defaultPaymentMethod'].toString();
          });
        }
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveDefaultMethod(String methodId) async {
    setState(() => _selectedMethodId = methodId);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'defaultPaymentMethod': methodId,
        }, SetOptions(merge: true));

        if (mounted) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastSuccess.getString(context),
            description: AppLocale.preferencesSavedSuccess.getString(context),
            type: ToastificationType.success,
          );
        }
      }
    } catch (_) {}
  }

  IconData _getMethodIcon(PaymentType type) {
    switch (type) {
      case PaymentType.card:
        return Icons.credit_card_rounded;
      case PaymentType.wallet:
        return Icons.account_balance_wallet_outlined;
      case PaymentType.cashOnArrival:
        return Icons.payments_outlined;
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
          AppLocale.paymentMethods.getString(context),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocale.choosePreferredPaymentMethod.getString(context),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocale.defaultPaymentMethodDesc.getString(context),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...PaymentMethodEntity.availableMethods.map((method) {
                    final isSelected = _selectedMethodId == method.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onTap: () => _saveDefaultMethod(method.id),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getMethodIcon(method.type),
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          method.title.getString(context),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: method.subtitle != null
                            ? Text(
                                method.subtitle!.getString(context),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : null,
                        trailing: Radio<String>(
                          value: method.id,
                          groupValue: _selectedMethodId,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            if (val != null) _saveDefaultMethod(val);
                          },
                        ),
                      ),
                    ),
                  );
                }),
                ],
              ),
            ),
    );
  }
}
