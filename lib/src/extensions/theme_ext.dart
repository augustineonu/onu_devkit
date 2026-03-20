import 'package:flutter/material.dart';
import 'package:onu_devkit/src/theme/app_theme_extension.dart';

extension CustomThemeData on ThemeData {
  // App colors
  Color get appPrimary => colorScheme.primary;
  Color get appGreen => Colors.green;
  Color get appTextBlack => colorScheme.onSurface;
}

extension ThemeExt on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
