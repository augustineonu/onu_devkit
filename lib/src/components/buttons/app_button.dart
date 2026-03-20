import 'package:flutter/material.dart';
import 'package:onu_devkit/src/extensions/extensions.dart';
import 'package:onu_devkit/src/tokens/app_radius.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.loadingColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius = AppRadius.medium,
    this.width,
    this.height,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isDisabled = onPressed == null || isLoading;

    final Color resolvedBg = backgroundColor ?? theme.colorScheme.primary;
    final Color resolvedText = textColor ?? theme.colorScheme.onPrimary;

    final radius = borderRadius ?? context.appTheme.buttonRadius;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 45,
        padding: padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          color: isDisabled ? resolvedBg.withValues(alpha: 0.6) : resolvedBg,
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loadingColor ?? resolvedText,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8)],
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize ?? 16,
                        fontWeight: fontWeight ?? FontWeight.w600,
                        color: isDisabled
                            ? resolvedText.withValues(alpha: 0.6)
                            : resolvedText,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (suffixIcon != null) ...[SizedBox(width: 8), suffixIcon!],
                ],
              ),
      ),
    );
  }
}
