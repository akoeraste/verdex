# Offline Functionality Implementation

## Overview

Verdex now supports full offline functionality, allowing users to continue using the app even when there's no internet connection. This implementation provides a seamless user experience by caching user credentials, data, and handling offline scenarios gracefully.

## Key Features

### 1. Offline Login
- Users can log in using cached credentials when offline
- Credentials are securely stored and validated locally
- Automatic fallback to offline mode when network is unavailable

### 2. Data Caching
- User profile data is cached for offline access
- Plant data is cached for offline browsing
- Credentials are cached securely for offline authentication

### 3. Network Awareness
- Real-time connectivity monitoring
- Automatic sync when connection is restored
- Visual indicators for offline status

### 4. Queue System
- Actions performed offline are queued for sync
- Automatic processing when back online
- Graceful handling of sync failures

## Architecture

### Services

#### 1. ConnectivityService
- Monitors network connectivity status
- Provides real-time connection state updates
- Singleton pattern for app-wide access

```dart
final connectivityService = ConnectivityService();
await connectivityService.initialize();
```

#### 2. OfflineStorageService
- Manages secure storage of user credentials
- Handles caching of user data
- Manages pending actions queue

```dart
final offlineStorage = OfflineStorageService();
await offlineStorage.cacheUserCredentials(login, password);
```

#### 3. AuthService (Enhanced)
- Supports both online and offline authentication
- Automatic fallback to offline mode
- Handles credential validation and caching

### Widgets

#### 1. NetworkAwareWrapper
- Wraps any widget to provide network awareness
- Shows offline banner when disconnected
- Handles automatic sync when connection restored

```dart
NetworkAwareWrapper(
  child: YourWidget(),
  showOfflineBanner: true,
  onConnectionRestored: () {
    // Handle connection restoration
  },
)
```

#### 2. OfflineIndicator
- Simple indicator showing offline status
- Customizable size and appearance
- Can show/hide text as needed

```dart
OfflineIndicator(
  showText: true,
  size: 16,
  color: Colors.red,
)
```

## Usage Examples

### 1. Basic Offline Login

```dart
final authService = AuthService();
final result = await authService.login(login, password);

if (result['success'] == true) {
  if (result['offline'] == true) {
    // Show offline login message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.orange,
      ),
    );
  }
  // Navigate to home
}
```

### 2. Network-Aware Screen

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Screen'),
          actions: [
            OfflineIndicator(size: 20),
          ],
        ),
        body: YourContent(),
      ),
    );
  }
}
```

### 3. Offline-Aware Actions

```dart
Future<void> updateProfile() async {
  final authService = AuthService();
  final result = await authService.updateProfile(
    username: 'newUsername',
    email: 'newemail@example.com',
  );
  
  if (result['offline'] == true) {
    // Show queued message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
```

## Configuration

### 1. Initialize Services

In your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => connectivityService),
        // Other providers...
      ],
      child: MyApp(),
    ),
  );
}
```

### 2. Add Translation Keys

Add these keys to your translation files:

```json
{
  "offline_mode_active": "Offline Mode Active",
  "syncing_data": "Syncing data...",
  "connection_restored_sync_complete": "Connection restored! Data synced successfully.",
  "sync_failed_try_again": "Sync failed. Please try again.",
  "no_cached_credentials": "No cached credentials found. Please connect to the internet to login.",
  "logged_in_offline": "Logged in using cached credentials. Connect to the internet to sync your data."
}
```

## Security Considerations

### 1. Credential Storage
- Credentials are stored using `flutter_secure_storage`
- Encrypted storage on both iOS and Android
- Automatic cleanup on logout

### 2. Data Validation
- Cached credentials have expiration (30 days)
- Local validation before offline login
- Secure token management

### 3. Privacy
- No sensitive data is stored in plain text
- Automatic data cleanup when appropriate
- User control over cached data

## Error Handling

### 1. Network Errors
- Graceful fallback to offline mode
- Clear error messages for users
- Automatic retry mechanisms

### 2. Sync Failures
- Queued actions are preserved
- Manual retry options
- Clear feedback to users

### 3. Cache Issues
- Automatic cache validation
- Fallback to online authentication
- Clear error messages

## Testing

### 1. Offline Testing
- Enable airplane mode to test offline functionality
- Verify cached login works
- Test sync when connection restored

### 2. Edge Cases
- Test with expired cached credentials
- Verify queue system works correctly
- Test with poor network conditions

## Future Enhancements

### 1. Advanced Caching
- Implement more sophisticated cache invalidation
- Add cache size management
- Implement cache compression

### 2. Background Sync
- Implement background sync when app is not active
- Add sync scheduling options
- Implement sync priority system

### 3. Conflict Resolution
- Handle data conflicts when syncing
- Implement merge strategies
- Add conflict resolution UI

## Troubleshooting

### Common Issues

1. **Offline login not working**
   - Check if credentials were cached during online login
   - Verify cache hasn't expired
   - Check secure storage permissions

2. **Sync not working**
   - Verify network connectivity
   - Check if pending actions exist
   - Review sync error logs

3. **Cache issues**
   - Clear app data and re-login
   - Check storage permissions
   - Verify secure storage is working

### Debug Information

Enable debug logging by adding:

```dart
// In your services, add debug prints
print('Connectivity status: ${connectivityService.isConnected}');
print('Cached credentials: ${await offlineStorage.getCachedCredentials()}');
```

## Conclusion

This offline functionality implementation provides a robust, secure, and user-friendly experience for Verdex users. It ensures the app remains functional even in poor network conditions while maintaining data integrity and security. 