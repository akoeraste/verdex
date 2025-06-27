<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">Frontend Documentation (Flutter)</h1>
      <p>Verdex's frontend is a cross-platform Flutter application for iOS, Android, and Web. It provides plant identification, plant library, user feedback, notifications, and more.</p>
      <h2 id="features">Features</h2>
      <ul>
        <li>Plant identification via camera/gallery</li>
        <li>Plant library browsing and search</li>
        <li>User authentication and profile management</li>
        <li>Feedback submission and notification</li>
        <li>Multi-language support</li>
        <li>Offline data caching</li>
        <li>Push notifications</li>
        <li>Favorites management</li>
      </ul>
      <h2 id="project-structure">Project Structure</h2>
      <pre><code>lib/
  constants/         # API config and constants
  models/            # Data models
  providers/         # State management (Provider)
  screens/           # Main app screens (Home, Identify, Settings, etc.)
  services/          # API, Auth, Notification, Language, etc.
  utils/             # Utility functions
  widgets/           # Reusable UI components
assets/
  images/            # App images
  translations/      # Localization files (en.json, fr.json, etc.)
</code></pre>
      <h2 id="main-screens">Main Screens & Navigation</h2>
      <ul>
        <li><b>HomeScreen:</b> Dashboard, plant highlights</li>
        <li><b>IdentifyScreen:</b> Plant identification via camera/gallery</li>
        <li><b>PlantDetailScreen:</b> Plant info, images, uses</li>
        <li><b>FavoritesScreen:</b> User's favorite plants</li>
        <li><b>FeedbackScreen:</b> Submit feedback</li>
        <li><b>NotificationsScreen:</b> View notifications</li>
        <li><b>SettingsScreen:</b> Profile, preferences, language, theme</li>
        <li><b>Login/Register:</b> Authentication</li>
        <li><b>About/Privacy/Terms:</b> Info pages</li>
      </ul>
      <p>Navigation is managed via <code>Navigator</code> and custom bottom navigation bar.</p>
      <h2 id="state-management">State Management</h2>
      <ul>
        <li>Uses <b>Provider</b> for app-wide state (auth, language, favorites, etc.)</li>
        <li>Local state via <code>StatefulWidget</code> where appropriate</li>
      </ul>
      <h2 id="api-integration">API Integration</h2>
      <ul>
        <li>Uses <code>http</code> package for REST API calls</li>
        <li>All endpoints are defined in <code>constants/api_config.dart</code></li>
        <li>Authenticated requests use Bearer tokens</li>
        <li>Error handling and loading states are managed in each screen/service</li>
      </ul>
      <h2 id="caching">Caching & Offline Support</h2>
      <ul>
        <li>Uses <code>SharedPreferences</code> for local storage</li>
        <li>Caches plant data, favorites, and user info for offline use</li>
        <li>Handles network errors gracefully</li>
      </ul>
      <h2 id="localization">Localization</h2>
      <ul>
        <li>Uses <code>easy_localization</code> package</li>
        <li>Translation files in <code>assets/translations/</code></li>
        <li>Supports English, French, Spanish, Bengali, and more</li>
      </ul>
      <h2 id="notifications">Notifications</h2>
      <ul>
        <li>In-app notification center (<code>NotificationsScreen</code>)</li>
        <li>Fetches notifications from backend via API</li>
        <li>Supports marking as read, deleting, and clearing all</li>
        <li>(Optional) Integrate with Firebase Cloud Messaging for push</li>
      </ul>
      <h2 id="build-run">How to Build and Run</h2>
      <ol>
        <li>Install Flutter SDK (3.x recommended)</li>
        <li>Run <code>flutter pub get</code></li>
        <li>For Android: <code>flutter run -d android</code></li>
        <li>For iOS: <code>flutter run -d ios</code></li>
        <li>For Web: <code>flutter run -d chrome</code></li>
        <li>To build release: <code>flutter build apk</code> / <code>flutter build ios</code> / <code>flutter build web</code></li>
      </ol>
      <h2 id="testing">Testing</h2>
      <ul>
        <li>Widget tests in <code>test/</code></li>
        <li>Run all tests: <code>flutter test</code></li>
      </ul>
      <h2 id="contribution">Contribution Guidelines</h2>
      <ul>
        <li>Fork the repo and create a feature branch</li>
        <li>Follow Dart/Flutter best practices</li>
        <li>Write clear commit messages</li>
        <li>Add/Update tests for new features</li>
        <li>Submit a pull request for review</li>
      </ul>
      <h2 id="troubleshooting">Troubleshooting</h2>
      <ul>
        <li>If dependencies fail: run <code>flutter pub get --verbose</code></li>
        <li>For iOS issues: run <code>pod install</code> in <code>ios/</code></li>
        <li>For Android: check emulator/device connection</li>
        <li>For localization: ensure <code>easy_localization</code> is initialized</li>
      </ul>
      <h2 id="future">Future Improvements</h2>
      <ul>
        <li>Real-time sync with backend (WebSockets)</li>
        <li>Advanced offline mode</li>
        <li>More languages</li>
        <li>Enhanced accessibility</li>
        <li>Deep linking and sharing</li>
        <li>In-app tutorials</li>
      </ul>
    </div>
  </DocumentationLayout>
</template>

<script setup>
import DocumentationLayout from './DocumentationLayout.vue';
</script>

<style scoped>
pre {
  background: #f8fafc;
  border-radius: 6px;
  padding: 1rem;
  font-size: 0.98rem;
  overflow-x: auto;
}
code {
  font-family: 'Fira Mono', 'Consolas', 'Menlo', monospace;
  color: #2e7d32;
}
</style> 