/// Text and data formatters.
class Formatters {
  Formatters._();

  static String formatPhoneNumber(String number) {
    // TODO: implement phone number formatting
    return number;
  }

  static String formatDate(DateTime date) {
    // TODO: implement date formatting
    return date.toIso8601String();
  }

  static String formatTime(DateTime time) {
    // TODO: implement time formatting
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
