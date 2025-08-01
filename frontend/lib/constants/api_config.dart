class ApiConfig {
  // For Android emulator, 10.0.2.2 points to the host machine's localhost.
  // For physical devices, replace with your machine's local IP address.
  // You can find your local IP by running 'ipconfig' (Windows) or 'ifconfig' (macOS/Linux).
  static const String baseUrl = 'https://verdex.nexgengroupltd.com/api';

  // Health check endpoint for connectivity testing
  static const String healthEndpoint = '/health';

  // Authentication endpoints
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String registerEndpoint = '/register';
  static const String sendTempPasswordEndpoint = '/send-temp-password';

  // User endpoints
  static const String userEndpoint = '/user';
  static const String changePasswordEndpoint = '/profile/change-password';
}
