/// DateTime extension methods.
extension DateTimeExtensions on DateTime {
  /// Format as readable date string.
  String get formatted => '$day/$month/$year';

  /// Format as readable time string.
  String get formattedTime => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Check if today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
