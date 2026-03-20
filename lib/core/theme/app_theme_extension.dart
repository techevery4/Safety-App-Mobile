import 'package:flutter/material.dart';

/// Custom theme extension for additional theme properties.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color? sosButtonColor;
  final Color? safeStatusColor;
  final Color? emergencyStatusColor;

  const AppThemeExtension({
    this.sosButtonColor,
    this.safeStatusColor,
    this.emergencyStatusColor,
  });

  @override
  AppThemeExtension copyWith({
    Color? sosButtonColor,
    Color? safeStatusColor,
    Color? emergencyStatusColor,
  }) {
    return AppThemeExtension(
      sosButtonColor: sosButtonColor ?? this.sosButtonColor,
      safeStatusColor: safeStatusColor ?? this.safeStatusColor,
      emergencyStatusColor: emergencyStatusColor ?? this.emergencyStatusColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      sosButtonColor: Color.lerp(sosButtonColor, other.sosButtonColor, t),
      safeStatusColor: Color.lerp(safeStatusColor, other.safeStatusColor, t),
      emergencyStatusColor: Color.lerp(emergencyStatusColor, other.emergencyStatusColor, t),
    );
  }
}
