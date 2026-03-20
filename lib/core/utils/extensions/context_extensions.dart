import 'package:flutter/material.dart';

/// BuildContext extension methods.
extension ContextExtensions on BuildContext {
  /// Get screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get theme.
  ThemeData get theme => Theme.of(this);

  /// Get text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Show a snackbar.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
