import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:madinaty_app_ieee_2026/core/localization/app_locale.dart';
import 'package:madinaty_app_ieee_2026/core/theme/app_colors.dart';

class PromptField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;

  const PromptField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<PromptField> createState() => _PromptFieldState();
}

class _PromptFieldState extends State<PromptField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    return Container(
      height: 185,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasText ? AppColors.primary : const Color(0xFFE7DDD4),
          width: hasText ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: null,
              maxLines: null,
              expands: true,
              autofocus: false,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: AppLocale.aiPromptFieldHint.getString(context),
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.72),
                  fontSize: 14,
                  height: 1.6,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(
                  17,
                  16,
                  17,
                  58,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 12,
            bottom: 12,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: hasText ? AppColors.primary : const Color(0xFFE8DED5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: AppLocale.send.getString(context),
                onPressed: hasText ? widget.onSubmitted : null,
                icon: Icon(
                  Icons.arrow_upward_rounded,
                  size: 23,
                  color: hasText ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}