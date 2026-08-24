import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_typography.dart';
import '../../../../booking/domain/entities/booking_entity.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final BookingEntity booking;
  final double reservationFee;
  final double preOrdersAmount;
  final double taxRate;

  const CheckoutSummaryCard({
    super.key,
    required this.booking,
    this.reservationFee = 50.0,
    this.preOrdersAmount = 0.0,
    this.taxRate = 0.14,
  });

  String _formatAmount(double amount) {
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final currency = AppLocale.currency.getString(context);
    final double taxableAmount = reservationFee + preOrdersAmount;
    final double taxAmount = taxableAmount * taxRate;
    final double totalAmount = taxableAmount + taxAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            title: AppLocale.tableReservationFee.getString(context),
            subtitle: AppLocale.tableReservationFeeSubtitle.getString(context),
            value: '${_formatAmount(reservationFee)} $currency',
          ),
          if (preOrdersAmount > 0) ...[
            const SizedBox(height: 10),
            _buildSummaryRow(
              title: AppLocale.preOrdersSubtotal.getString(context),
              value: '${_formatAmount(preOrdersAmount)} $currency',
            ),
          ],
          const SizedBox(height: 10),
          _buildSummaryRow(
            title: AppLocale.taxes.getString(context),
            value: '${_formatAmount(taxAmount)} $currency',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.divider, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.total.getString(context),
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatAmount(totalAmount)} $currency',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocale.inclusiveOfTaxes.getString(context),
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    String? subtitle,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}