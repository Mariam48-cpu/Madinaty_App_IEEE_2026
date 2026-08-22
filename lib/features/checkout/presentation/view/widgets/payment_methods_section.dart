import 'package:flutter/material.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../domain/entities/payment_method_entity.dart';

class PaymentMethodsSection extends StatelessWidget {
  final PaymentMethodEntity selectedMethod;
  final Function(PaymentMethodEntity) onMethodSelected;
  final TextEditingController phoneWalletController;

  const PaymentMethodsSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.phoneWalletController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'طريقة الدفع',
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: 12),

        _buildPaymentOption(
          id: 'card',
          type: PaymentType.card,
          title: 'بطاقة ائتمان / خصم مباشر',
          subtitle: 'فيزا، ماستركارد، ميزة',
          icon: Icons.credit_card,
          isSelected: selectedMethod.type == PaymentType.card || selectedMethod.id == 'card',
        ),
        const SizedBox(height: 12),

        _buildPaymentOption(
          id: 'wallet',
          type: PaymentType.wallet,
          title: 'محفظة رقمية',
          subtitle: 'فودافون كاش، إنستاباي، وغيرها',
          icon: Icons.account_balance_wallet_outlined,
          isSelected: selectedMethod.type == PaymentType.wallet || selectedMethod.id == 'wallet',
          extraContent: _buildWalletInput(context),
        ),
        const SizedBox(height: 12),

        _buildPaymentOption(
          id: 'cash',
          type: PaymentType.cashOnArrival,
          title: 'الدفع عند الوصول للكافيه',
          subtitle: 'نقداً أو عبر نقاط البيع المتاحة بالكافيه',
          icon: Icons.payments_outlined,
          isSelected: selectedMethod.type == PaymentType.cashOnArrival || selectedMethod.id == 'cash',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required PaymentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    Widget? extraContent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMethodSelected(
                PaymentMethodEntity(
                  id: id,
                  title: title,
                  type: type,
                  isSelected: true,
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isSelected,
                    activeColor: AppColors.primary,
                    onChanged: (_) {
                      onMethodSelected(
                        PaymentMethodEntity(
                          id: id,
                          title: title,
                          type: type,
                          isSelected: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isSelected && extraContent != null) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.all(16),
              child: extraContent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم المحفظة الإلكترونية',
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneWalletController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '01xxxxxxxxx',
            prefixIcon: const Icon(Icons.phone_android, size: 20),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'سيتم تحويلك لتأكيد الدفع عبر محفظتك الإلكترونية',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}