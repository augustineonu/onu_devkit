import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final int totalSteps;
  final Color? progressColor;
  final Color? backgroundColor;
  final double? height;
  final double? borderRadius;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.totalSteps,
    this.progressColor,
    this.backgroundColor,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: SizedBox(
        height: height ?? 5,
        child: LinearProgressIndicator(
          value: value / totalSteps,
          backgroundColor:
              backgroundColor ?? theme.dividerColor.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            progressColor ?? theme.colorScheme.primary,
          ),
          minHeight: height ?? 5,
        ),
      ),
    );
  }
}
