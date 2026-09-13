import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveReservationsScreen extends StatelessWidget {
  final String? cafeId;

  const ActiveReservationsScreen({super.key, required this.cafeId});

  @override
  Widget build(BuildContext context) {
    if (cafeId == null || cafeId!.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppLocale.activeReservationsTitle.getString(context)),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            AppLocale.noCafeIdProvided.getString(context),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final bookingsQuery = FirebaseFirestore.instance
        .collection('bookings')
        .where('cafeId', isEqualTo: cafeId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocale.activeReservationsTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookingsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '${AppLocale.reservationsLoadError.getString(context)}${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBE3D8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_busy,
                      size: 48,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    AppLocale.noReservationsFound.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${AppLocale.currentCafeIdPrefix.getString(context)}$cafeId',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = bookings[index];
              final data = doc.data() as Map<String, dynamic>;

              final userName = data['userName'] ?? data['name'] ?? AppLocale.defaultCustomerName.getString(context);
              final userPhone = data['userPhone'] ?? data['phone'] ?? '';
              final date = data['date'] ?? '';
              final time = data['time'] ?? '';
              final guestsCount = data['guestsCount'] ?? data['seats'] ?? 1;
              final status = (data['status'] ?? 'pending').toString().toLowerCase();

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.textSecondary.withOpacity(0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFEBE3D8),
                              child: Icon(Icons.person, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (userPhone.isNotEmpty)
                                  Text(
                                    userPhone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        _buildStatusBadge(context, status),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(
                          Icons.calendar_today,
                          date.isNotEmpty ? date : AppLocale.today.getString(context),
                        ),
                        _buildDetailItem(
                          Icons.access_time,
                          time.isNotEmpty ? time : AppLocale.notSpecified.getString(context),
                        ),
                        _buildDetailItem(
                          Icons.people_outline,
                          '$guestsCount ${AppLocale.guestsSuffix.getString(context)}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        if (userPhone.isNotEmpty) ...[
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F1EC),
                            ),
                            icon: const Icon(Icons.phone, color: AppColors.textPrimary, size: 20),
                            onPressed: () => _callNumber(userPhone),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _updateBookingStatus(doc.reference, 'cancelled'),
                            child: Text(
                              AppLocale.cancelReservation.getString(context),
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _updateBookingStatus(doc.reference, 'confirmed'),
                            child: Text(
                              AppLocale.confirmReservation.getString(context),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color bg;
    Color textColor;
    String label;

    switch (status) {
      case 'confirmed':
        bg = Colors.green.withOpacity(0.12);
        textColor = Colors.green[800]!;
        label = AppLocale.statusConfirmed.getString(context);
        break;
      case 'cancelled':
        bg = Colors.red.withOpacity(0.12);
        textColor = Colors.red[800]!;
        label = AppLocale.statusCancelled.getString(context);
        break;
      default:
        bg = Colors.orange.withOpacity(0.12);
        textColor = Colors.orange[800]!;
        label = AppLocale.statusPending.getString(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _updateBookingStatus(DocumentReference docRef, String status) async {
    await docRef.update({'status': status});
  }

  Future<void> _callNumber(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}