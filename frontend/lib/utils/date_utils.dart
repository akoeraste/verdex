import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds.abs() < 60) return 'just now';
    if (diff.inMinutes.abs() < 60)
      return '${diff.inMinutes.abs()} minute${diff.inMinutes.abs() == 1 ? '' : 's'} ago';
    if (diff.inHours.abs() < 24)
      return '${diff.inHours.abs()} hour${diff.inHours.abs() == 1 ? '' : 's'} ago';
    if (diff.inDays.abs() < 7)
      return '${diff.inDays.abs()} day${diff.inDays.abs() == 1 ? '' : 's'} ago';
    if (diff.inDays.abs() < 30)
      return '${(diff.inDays.abs() / 7).floor()} week${(diff.inDays.abs() / 7).floor() == 1 ? '' : 's'} ago';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(now, date);
  }

  static DateTime? parseDate(String? input) {
    if (input == null || input.isEmpty) return null;
    try {
      if (input.contains('-')) {
        return DateTime.parse(input);
      } else if (input.contains('/')) {
        final parts = input.split('/');
        if (parts.length == 3) {
          // Handle MM/DD/YYYY format
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      }
    } catch (_) {}
    return null;
  }
}
