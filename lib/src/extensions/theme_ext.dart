import 'package:flutter/material.dart';

extension CustomThemeData on ThemeData {
  // App colors
  Color get appPrimary => colorScheme.primary;
  Color get appGreen => Colors.green;
  Color get appTextBlack => colorScheme.onSurface;
}
