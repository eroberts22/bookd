import 'package:application/theme/theme_colors.dart';
import 'package:flutter/material.dart';

@immutable
class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData();
  }
}
