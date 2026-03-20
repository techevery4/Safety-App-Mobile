/// String extension methods.
extension StringExtensions on String {
  /// Capitalize the first letter.
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Check if string is a valid email.
  bool get isValidEmail => RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);

  /// Check if string is empty or whitespace.
  bool get isBlank => trim().isEmpty;
}
