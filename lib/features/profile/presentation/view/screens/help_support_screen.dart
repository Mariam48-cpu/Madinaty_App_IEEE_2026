import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';
import 'package:madinaty_app_ieee_2026/core/utils/app_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phoneNumber) async {
    final whatsappAppUri = Uri.parse('whatsapp://send?phone=$phoneNumber');
    final whatsappWebUri = Uri.parse('https://wa.me/$phoneNumber');
    
    try {
      if (await canLaunchUrl(whatsappAppUri)) {
        await launchUrl(whatsappAppUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      } else {
        final launched = await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          AppToast.showToast(
            context: context,
            title: AppLocale.toastError.getString(context),
            description: AppLocale.whatsappNotInstalled.getString(context),
            type: ToastificationType.error,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showToast(
          context: context,
          title: AppLocale.toastError.getString(context),
          description: AppLocale.whatsappNotInstalled.getString(context),
          type: ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': AppLocale.faqQ1.getString(context),
        'answer': AppLocale.faqA1.getString(context),
      },
      {
        'question': AppLocale.faqQ2.getString(context),
        'answer': AppLocale.faqA2.getString(context),
      },
      {
        'question': AppLocale.faqQ3.getString(context),
        'answer': AppLocale.faqA3.getString(context),
      },
      {
        'question': AppLocale.faqQ4.getString(context),
        'answer': AppLocale.faqA4.getString(context),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocale.helpAndSupport.getString(context),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Cards
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocale.contactUs.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_outline, color: Colors.green, size: 20),
                    ),
                    title: Text(
                      AppLocale.whatsappSupport.getString(context),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(AppLocale.whatsappSupportDesc.getString(context)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                    onTap: () => _launchWhatsApp(context, '201095190722'),
                  ),
                  const Divider(color: AppColors.border),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      AppLocale.callCustomerService.getString(context),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('19000'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                    onTap: () => _launchUrl('tel:19000'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // FAQ Section
            Text(
              AppLocale.faqTitle.getString(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ExpansionTile(
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.textSecondary,
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
