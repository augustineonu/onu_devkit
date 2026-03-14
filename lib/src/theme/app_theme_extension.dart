import 'dart:ui';

import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final double inputRadius;
  final double buttonRadius;
  final double cardRadius;

  const AppThemeExtension({
    required this.inputRadius,
    required this.buttonRadius,
    required this.cardRadius,
  });

  @override
  AppThemeExtension copyWith({
    double? inputRadius,
    double? buttonRadius,
    double? cardRadius,
  }) {
    return AppThemeExtension(
      inputRadius: inputRadius ?? this.inputRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      cardRadius: cardRadius ?? this.cardRadius,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;

    return AppThemeExtension(
      inputRadius: lerpDouble(inputRadius, other.inputRadius, t)!,
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
    );
  }
}
