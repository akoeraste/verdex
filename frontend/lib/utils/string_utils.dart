class StringUtils {
  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  }

  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String cleanText(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  static bool isValidLength(String? text, int min, int max) {
    if (text == null) return false;
    return text.length >= min && text.length <= max;
  }

  static bool containsIgnoreCase(String? text, String? pattern) {
    if (text == null || pattern == null) return false;
    return text.toLowerCase().contains(pattern.toLowerCase());
  }

  static String formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } else {
      return number.toStringAsFixed(2);
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String formatPercentage(double value) {
    return (value * 100).toStringAsFixed(2) + '%';
  }
}
