import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class AppToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    required ToastificationType type,
  }) {
    final isSuccess = type == ToastificationType.success;
    final isError = type == ToastificationType.error;

    final backgroundColor = isSuccess
        ? const Color(0xffE8F5E9)
        : isError
        ? const Color(0xffFFEBEE)
        : const Color(0xffFFF8E1);

    final textColor = isSuccess
        ? const Color(0xff2E7D32)
        : isError
        ? const Color(0xffC62828)
        : const Color(0xffEF6C00);

    final icon = isSuccess
        ? Icons.check_circle_outline
        : isError
        ? Icons.error_outline
        : Icons.warning_amber_rounded;

    toastification.show(
      context: context,

      type: type,

      style: ToastificationStyle.flatColored,

      alignment: Alignment.topCenter,

      margin: const EdgeInsets.only(top: 70, left: 20, right: 20),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      borderRadius: BorderRadius.circular(14),

      autoCloseDuration: const Duration(seconds: 2),

      animationDuration: const Duration(milliseconds: 400),

      showProgressBar: true,

      dragToClose: true,

      backgroundColor: backgroundColor,

      foregroundColor: textColor,

      icon: Icon(icon, color: textColor, size: 28),

      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),

      description: Text(
        description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),

      progressBarTheme: ProgressIndicatorThemeData(color: textColor),
    );
  }
}
