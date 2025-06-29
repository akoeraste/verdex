class ValidationUtils {
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    if (password.length < 8) return false;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasUppercase && hasLowercase && hasDigit;
  }

  static bool isValidName(String? name) {
    if (name == null || name.isEmpty) return false;
    final nameRegex = RegExp(r"^[a-zA-Z\s'\-]+$");
    return nameRegex.hasMatch(name);
  }

  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final urlRegex = RegExp(r'^https?://.+');
    return urlRegex.hasMatch(url);
  }
}
