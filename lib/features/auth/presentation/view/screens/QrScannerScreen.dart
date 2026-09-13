import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  final String cafeId;

  const QrScannerScreen({super.key, required this.cafeId});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  Future<void> _handleBarcode(String rawCode) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final reservationId = rawCode.trim();

      final reservationDoc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(reservationId)
          .get();

      if (!mounted) return;

      if (!reservationDoc.exists) {
        _showResultDialog(
          title: AppLocale.toastError.getString(context),
          message: AppLocale.invalidReservationCode.getString(context),
          isSuccess: false,
        );
        return;
      }

      final data = reservationDoc.data()!;

      final bookingCafeId = (data['cafeId'] ?? '').toString().trim().toLowerCase();
      final bookingCafeName = (data['cafeName'] ?? '').toString().trim().toLowerCase();
      final currentCafeId = widget.cafeId.trim().toLowerCase();

      DocumentSnapshot? ownerCafeDoc;
      if (currentCafeId.isNotEmpty) {
        ownerCafeDoc = await FirebaseFirestore.instance.collection('cafes').doc(currentCafeId).get();
      }
      final ownerCafeName = (ownerCafeDoc?.data() as Map<String, dynamic>?)?['name']?.toString().trim().toLowerCase() ?? '';

      developer.log(
        'SCANNER VERIFY: bookingCafeId="$bookingCafeId", bookingCafeName="$bookingCafeName", currentCafeId="$currentCafeId", ownerCafeName="$ownerCafeName"',
        name: 'QrScanner',
      );

      final isMatching = currentCafeId.isEmpty ||
          (bookingCafeId.isNotEmpty && bookingCafeId == currentCafeId) ||
          (bookingCafeName.isNotEmpty && currentCafeId == bookingCafeName) ||
          (bookingCafeName.isNotEmpty && currentCafeId.contains(bookingCafeName)) ||
          (bookingCafeId.isNotEmpty && currentCafeId.contains(bookingCafeId)) ||
          (bookingCafeName.isNotEmpty && ownerCafeName.isNotEmpty &&
              (bookingCafeName.contains(ownerCafeName) || ownerCafeName.contains(bookingCafeName)));

      if (!isMatching) {
        _showResultDialog(
          title: AppLocale.toastError.getString(context),
          message: AppLocale.unauthorizedReservation.getString(context),
          isSuccess: false,
        );
        return;
      }

      final status = (data['status'] ?? '').toString().toLowerCase();
      if (status == 'completed' || status == 'checked_in') {
        _showResultDialog(
          title: AppLocale.toastError.getString(context),
          message: AppLocale.reservationAlreadyCheckedIn.getString(context),
          isSuccess: false,
        );
        return;
      }

      await reservationDoc.reference.update({
        'status': 'checked_in',
        'checkedInAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showBookingDetailsDialog(
        bookingId: reservationId,
        data: data,
      );
    } catch (e) {
      if (!mounted) return;
      _showResultDialog(
        title: AppLocale.toastError.getString(context),
        message: '${AppLocale.checkInFailedMessage.getString(context)}$e',
        isSuccess: false,
      );
    }
  }

  void _showBookingDetailsDialog({
    required String bookingId,
    required Map<String, dynamic> data,
  }) {
    final customerName = data['userName'] ?? data['name'] ?? AppLocale.defaultCustomerName.getString(context);
    final guests = data['guests']?.toString() ?? '1';
    final time = data['time'] ?? '--:--';
    final seating = data['seatingPreference'] ?? AppLocale.indoorSeating.getString(context);
    final occasion = data['occasion'] ?? AppLocale.filterAll.getString(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocale.toastSuccess.getString(context),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '${AppLocale.customerRoleTitle.getString(context)}: $customerName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildDialogRow(
              Icons.confirmation_number_outlined,
              AppLocale.bookingNumberLabel.getString(context),
              '#${bookingId.substring(0, bookingId.length > 8 ? 8 : bookingId.length).toUpperCase()}',
            ),
            const SizedBox(height: 8),
            _buildDialogRow(Icons.access_time_rounded, AppLocale.time.getString(context), time),
            const SizedBox(height: 8),
            _buildDialogRow(Icons.people_outline_rounded, AppLocale.numberOfGuestsLabel.getString(context), '$guests ${AppLocale.guestsSuffix.getString(context)}'),
            const SizedBox(height: 8),
            _buildDialogRow(Icons.chair_outlined, AppLocale.seating.getString(context), seating),
            const SizedBox(height: 8),
            _buildDialogRow(Icons.celebration_outlined, AppLocale.occasionOptionalLabel.getString(context), occasion),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _isProcessing = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocale.ok.getString(context),
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResultDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? AppColors.primary : AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _isProcessing = false);
            },
            child: Text(
              AppLocale.ok.getString(context),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.scanQrTitle.getString(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _handleBarcode(barcode!.rawValue!);
              }
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}