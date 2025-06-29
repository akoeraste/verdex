class ImageUtils {
  static bool isValidImageFormat(String? filename) {
    if (filename == null || filename.isEmpty) return false;
    final allowed = ['jpg', 'jpeg', 'png', 'webp'];
    final ext = filename.split('.').last.toLowerCase();
    return allowed.contains(ext);
  }

  static bool isValidImageSize(int sizeInBytes) {
    // Accept images up to 10MB
    return sizeInBytes > 0 && sizeInBytes <= 10 * 1024 * 1024;
  }

  static double calculateCompressionQuality(int sizeInBytes) {
    if (sizeInBytes <= 1024 * 1024) return 1.0;
    if (sizeInBytes <= 5 * 1024 * 1024) return 0.8;
    if (sizeInBytes <= 10 * 1024 * 1024) return 0.6;
    return 0.2;
  }

  static bool isValidDimensions(int width, int height) {
    // Accept images between 200x200 and 4000x4000
    return width >= 200 && height >= 200 && width <= 4000 && height <= 4000;
  }
}
