# Connecting Flutter Frontend to Laravel Backend

This guide explains how to connect the Flutter frontend (in `frontend/`) to the Laravel backend (in `backend/`) for user authentication and persistent login. It also outlines a workflow to ensure a robust, maintainable integration.

---

## 1. API Host Configuration
- Centralize the API base URL in `frontend/lib/constants/api_config.dart`.
- Use a variable like `baseUrl` for easy switching between localhost and production.
- Example:
  ```dart
  class ApiConfig {
    static const String baseUrl = 'http://10.0.2.2:8000/api';
  }
  ```
- For production, update `baseUrl` to your deployed backend URL.

---

## 2. Authentication Flow
- User enters email and password in the Flutter app.
- App sends a POST request to the backend `/api/login` endpoint.
- Backend returns a JSON response with `access_token` and user info.
- App stores the token securely using `flutter_secure_storage`.
- For all authenticated requests, the app includes the token in the `Authorization` header as `Bearer <token>`.
- On app launch, the app checks for a stored token to keep the user logged in.
- Logout removes the token from secure storage and notifies the backend.

---

## 3. Implementation Steps

### Backend (Laravel)
- Ensure `/api/login` route exists and is handled by `AuthController@login`.
- The login endpoint should accept `email` and `password` and return:
  ```json
  {
    "access_token": "TOKEN_STRING",
    "token_type": "Bearer",
    "user": { ...user fields... }
  }
  ```
- Protect other API routes with authentication middleware (e.g., Sanctum).
- Implement `/api/logout` to revoke the token.

### Frontend (Flutter)
- Add `flutter_secure_storage` to `pubspec.yaml` for secure token storage.
- Refactor or create `AuthService` to:
  - Handle login: send credentials, store token on success.
  - Handle logout: remove token and call backend logout.
  - Provide `isLoggedIn()` and `getToken()` methods.
- On app start, check if a token exists to persist login.
- Use the token in the `Authorization` header for all authenticated API requests.
- Update login/logout UI to use the new service.

---

## 4. Workflow

1. **Backend Preparation**
   - Confirm `/api/login` and `/api/logout` endpoints are working.
   - Ensure CORS is configured to allow requests from the frontend.
   - Protect sensitive routes with authentication middleware.

2. **Frontend Preparation**
   - Set the correct API base URL in `api_config.dart`.
   - Install dependencies: `flutter pub get`.
   - Refactor authentication logic to use `AuthService` with secure storage.

3. **Authentication Integration**
   - On login, call `AuthService().login(email, password)`.
   - On app launch, call `AuthService().isLoggedIn()` to check login state.
   - For authenticated requests, use `AuthService().getToken()` to get the token and add it to the `Authorization` header.
   - On logout, call `AuthService().logout()`.

4. **Testing**
   - Test login with valid and invalid credentials.
   - Test persistent login by restarting the app.
   - Test logout and ensure the user is redirected to the login screen.
   - Test API requests with and without the token.

5. **Production Readiness**
   - Update `baseUrl` in `api_config.dart` to your production backend URL.
   - Ensure HTTPS is used in production.
   - Review CORS and security settings on the backend.

---

## 5. Best Practices
- Never hardcode sensitive information in the app.
- Use secure storage for tokens.
- Handle token expiration and errors gracefully (e.g., redirect to login if unauthorized).
- Keep API URLs and keys in a single config file for easy management.

---

## 6. References
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [Laravel Sanctum](https://laravel.com/docs/10.x/sanctum)
- [Flutter HTTP package](https://pub.dev/packages/http)

---

**Follow this workflow to ensure a secure and maintainable connection between your Flutter frontend and Laravel backend.** 