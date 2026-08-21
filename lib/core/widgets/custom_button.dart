import 'package:flutter/material.dart';

enum ButtonVariant { elevated, outlined, text }

/// A reusable, responsive, and RTL-friendly button widget.
///
/// Automatically inherits styling from [AppTheme] while allowing
/// customization for loading state, icons, variants, and colors.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.elevated,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 16.0,
    this.padding,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;

    Widget childContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.elevated
                    ? (textColor ?? theme.colorScheme.onSecondary)
                    : (textColor ?? theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style:
              textStyle ??
              theme.textTheme.labelLarge?.copyWith(
                color:
                    textColor ??
                    (variant == ButtonVariant.elevated
                        ? theme.colorScheme.onSecondary
                        : theme.colorScheme.primary),
              ),
        ),
      ],
    );

    Widget button;
    switch (variant) {
      case ButtonVariant.elevated:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
            foregroundColor: textColor ?? theme.colorScheme.onSecondary,
            minimumSize: Size(width ?? 88.0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;

      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.onSurface,
            minimumSize: Size(width ?? 88.0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            side: backgroundColor != null
                ? BorderSide(color: backgroundColor!)
                : null,
          ),
          child: childContent,
        );
        break;

      case ButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            minimumSize: Size(width ?? 88.0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;
    }

    if (width != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
