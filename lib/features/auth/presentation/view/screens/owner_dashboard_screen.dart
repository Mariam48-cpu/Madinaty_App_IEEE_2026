import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/routes/app_routes.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

import 'QrScannerScreen.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final String cafeId;

  const OwnerDashboardScreen({super.key, required this.cafeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.ownerDashboardTitle.getString(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            tooltip: AppLocale.logoutBtn.getString(context),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              try {
                await GoogleSignIn.instance.signOut();
              } catch (_) {}

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.auth,
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              title: AppLocale.scanQrTitle.getString(context),
              icon: Icons.qr_code_scanner,
              accentColor: const Color(0xFF6B4F4F),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QrScannerScreen(cafeId: cafeId),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              context,
              title: AppLocale.editCafeDataTitle.getString(context),
              icon: Icons.edit_note,
              accentColor: const Color(0xFF8A6F55),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.editCafe, arguments: cafeId);
              },
            ),
            _buildDashboardCard(
              context,
              title: AppLocale.activeBookingsTitle.getString(context),
              icon: Icons.table_restaurant,
              accentColor: const Color(0xFF5A736E),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.activeReservations, arguments: cafeId);
              },
            ),
            _buildDashboardCard(
              context,
              title: AppLocale.manageMenuTitle.getString(context),
              icon: Icons.restaurant_menu,
              accentColor: const Color(0xFF9E6B55),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.manageMenu, arguments: cafeId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color accentColor,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: accentColor.withValues(alpha: 0.15),
              child: Icon(icon, size: 28, color: accentColor),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}