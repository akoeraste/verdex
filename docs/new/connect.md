# Verdex Backend-Frontend Connection Guide

## Overview
This guide explains how the Verdex Flutter frontend connects to the Laravel backend API for authentication, data, feedback, and notifications.

## API Base URL & Environment Setup
- **API Base URL**: Set in `lib/constants/api_config.dart` (Flutter)
- Example: `https://api.verdex.app/api`
- Use environment variables for dev/staging/prod

## Authentication Flow
1. User logs in via `/login` (POST)
2. Backend returns a Bearer token
3. Frontend stores token securely (e.g., `SharedPreferences`)
4. All subsequent API requests include `Authorization: Bearer <token>`

## How Frontend Calls Backend APIs
- Uses `http` package in Flutter
- All requests are JSON (`Content-Type: application/json`)
- Authenticated endpoints require Bearer token
- Example:
```dart
final response = await http.get(
  Uri.parse('$baseUrl/plants'),
  headers: {'Authorization': 'Bearer $token'},
);
```

## Error Handling & Status Codes
- Backend returns standard HTTP status codes
- Error responses include `error` and `message` fields
- Frontend should handle 401 (unauthenticated), 403 (forbidden), 422 (validation), 500 (server error)

## Data Formats
- All data exchanged as JSON
- Dates in ISO 8601 format
- Example response:
```json
{
  "data": [ ... ],
  "meta": { "current_page": 1, ... }
}
```

## CORS & Security
- Backend enables CORS for allowed origins
- Always use HTTPS in production
- Never expose tokens in logs or URLs

## Example Integration
### Login
```dart
final response = await http.post(
  Uri.parse('$baseUrl/login'),
  body: jsonEncode({ 'email': email, 'password': password }),
  headers: { 'Content-Type': 'application/json' },
);
```
### Fetch Plants
```dart
final response = await http.get(
  Uri.parse('$baseUrl/plants'),
  headers: { 'Authorization': 'Bearer $token' },
);
```
### Submit Feedback
```dart
final response = await http.post(
  Uri.parse('$baseUrl/feedback'),
  body: jsonEncode({ 'category': 'bug_report', 'message': 'Found a bug!' }),
  headers: { 'Authorization': 'Bearer $token', 'Content-Type': 'application/json' },
);
```
### Get Notifications
```dart
final response = await http.get(
  Uri.parse('$baseUrl/notifications'),
  headers: { 'Authorization': 'Bearer $token' },
);
```

## Troubleshooting Connection Issues
- Check API base URL and network connectivity
- Ensure correct token is sent in headers
- For CORS errors, check backend CORS config
- For 401/403, check authentication and permissions
- Use tools like Postman to test endpoints

## Best Practices
- Use environment variables for API URLs
- Handle all error cases in frontend
- Keep tokens secure and refresh as needed
- Log errors for debugging (but not sensitive data)
- Test integration in staging before production 