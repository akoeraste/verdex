<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">Project Structure</h1>
      <p>This document provides a comprehensive overview of the Verdex project structure, including both the backend (Laravel) and frontend (Flutter) codebases.</p>
      
      <h2 id="backend-structure">Backend Structure (Laravel)</h2>
      <p>The Laravel backend follows the standard Laravel directory structure with custom additions for the Verdex application:</p>
      
      <h3>Core Directories</h3>
      <pre><code>backend/
├── app/
│   ├── Console/           # Artisan commands
│   ├── Exceptions/        # Error handling
│   ├── Http/
│   │   ├── Controllers/   # API controllers
│   │   ├── Middleware/    # Request middleware
│   │   ├── Requests/      # Form validation
│   │   └── Resources/     # API resources
│   ├── Mail/              # Email notifications
│   ├── Models/            # Eloquent models
│   ├── Notifications/     # Notification classes
│   ├── Policies/          # Authorization policies
│   └── Providers/         # Service providers
├── config/                # App configuration
├── database/
│   ├── migrations/        # Database migrations
│   ├── seeders/           # Database seeders
│   └── factories/         # Model factories
├── resources/
│   ├── js/                # Vue.js frontend
│   ├── views/             # Blade templates
│   └── lang/              # Localization
├── routes/                # API and web routes
├── storage/               # File storage
└── tests/                 # Test files</code></pre>
      
      <h3>Key Models</h3>
      <ul>
        <li><code>User</code> - User authentication and profiles</li>
        <li><code>Plant</code> - Plant data and information</li>
        <li><code>Category</code> - Plant categories</li>
        <li><code>PlantTranslation</code> - Multi-language plant names</li>
        <li><code>Feedback</code> - User feedback system</li>
        <li><code>Notification</code> - User notifications</li>
        <li><code>ActivityLog</code> - System activity tracking</li>
        <li><code>Role</code> & <code>Permission</code> - Authorization system</li>
      </ul>
      
      <h2 id="frontend-structure">Frontend Structure (Flutter)</h2>
      <p>The Flutter frontend is organized for maintainability and scalability:</p>
      
      <h3>Core Directories</h3>
      <pre><code>frontend/
├── lib/
│   ├── constants/         # App constants
│   ├── models/            # Data models
│   ├── providers/         # State management
│   ├── screens/           # UI screens
│   ├── services/          # API services
│   ├── utils/             # Utility functions
│   └── widgets/           # Reusable widgets
├── assets/
│   ├── images/            # App images
│   ├── model/             # ML model files
│   └── translations/      # Localization files
├── test/                  # Test files
├── android/               # Android-specific code
└── ios/                   # iOS-specific code</code></pre>
      
      <h3>Key Screens</h3>
      <ul>
        <li><code>HomeScreen</code> - Main plant identification interface</li>
        <li><code>PlantDetailScreen</code> - Detailed plant information</li>
        <li><code>ProfileScreen</code> - User profile management</li>
        <li><code>SettingsScreen</code> - App settings</li>
        <li><code>AboutScreen</code> - About the application</li>
        <li><code>LoginScreen</code> - User authentication</li>
      </ul>
      
      <h2 id="api-structure">API Structure</h2>
      <p>The API follows RESTful conventions with consistent endpoint patterns:</p>
      
      <h3>Authentication Endpoints</h3>
      <ul>
        <li><code>POST /api/login</code> - User login</li>
        <li><code>POST /api/register</code> - User registration</li>
        <li><code>POST /api/logout</code> - User logout</li>
        <li><code>GET /api/user</code> - Get current user</li>
      </ul>
      
      <h3>Plant Endpoints</h3>
      <ul>
        <li><code>GET /api/plants</code> - List all plants</li>
        <li><code>GET /api/plants/{id}</code> - Get specific plant</li>
        <li><code>POST /api/plants/identify</code> - Identify plant from image</li>
        <li><code>GET /api/plants/search</code> - Search plants</li>
      </ul>
      
      <h3>Category Endpoints</h3>
      <ul>
        <li><code>GET /api/categories</code> - List all categories</li>
        <li><code>GET /api/categories/{id}/plants</code> - Get plants by category</li>
      </ul>
      
      <h3>Feedback Endpoints</h3>
      <ul>
        <li><code>GET /api/feedback</code> - List user feedback</li>
        <li><code>POST /api/feedback</code> - Submit feedback</li>
        <li><code>PUT /api/feedback/{id}</code> - Update feedback</li>
      </ul>
      
      <h2 id="database-schema">Database Schema</h2>
      <p>The database uses a relational structure with proper foreign key relationships:</p>
      
      <h3>Core Tables</h3>
      <ul>
        <li><code>users</code> - User accounts and profiles</li>
        <li><code>plants</code> - Plant information and metadata</li>
        <li><code>categories</code> - Plant categories</li>
        <li><code>plant_translations</code> - Multi-language plant names</li>
        <li><code>feedback</code> - User feedback and responses</li>
        <li><code>notifications</code> - User notifications</li>
        <li><code>activity_logs</code> - System activity tracking</li>
        <li><code>roles</code> & <code>permissions</code> - Authorization system</li>
        <li><code>favorites</code> - User favorite plants</li>
      </ul>
      
      <h2 id="ml-integration">ML Integration</h2>
      <p>The machine learning component is integrated throughout the application:</p>
      
      <h3>Model Files</h3>
      <ul>
        <li><code>plant_classifier_mobile.tflite</code> - Mobile-optimized model</li>
        <li><code>plant_classifier_server.tflite</code> - Server-side model</li>
      </ul>
      
      <h3>Integration Points</h3>
      <ul>
        <li><b>Mobile App:</b> Local inference using TensorFlow Lite</li>
        <li><b>Server API:</b> Server-side processing for complex requests</li>
        <li><b>Admin Panel:</b> Model performance monitoring</li>
      </ul>
      
      <h2 id="deployment-structure">Deployment Structure</h2>
      <p>The application is designed for scalable deployment:</p>
      
      <h3>Backend Deployment</h3>
      <ul>
        <li><b>Web Server:</b> Nginx/Apache configuration</li>
        <li><b>Application Server:</b> PHP-FPM with Laravel</li>
        <li><b>Database:</b> MySQL/PostgreSQL</li>
        <li><b>Cache:</b> Redis for session and data caching</li>
        <li><b>Queue:</b> Redis for background job processing</li>
      </ul>
      
      <h3>Frontend Deployment</h3>
      <ul>
        <li><b>Mobile Apps:</b> App Store and Google Play Store</li>
        <li><b>Web Admin:</b> Deployed with backend</li>
        <li><b>Assets:</b> CDN for static files</li>
      </ul>
      
      <h2 id="development-workflow">Development Workflow</h2>
      <p>The project follows a structured development process:</p>
      
      <h3>Version Control</h3>
      <ul>
        <li><b>Repository:</b> Git with feature branch workflow</li>
        <li><b>Branches:</b> main, develop, feature branches</li>
        <li><b>Commits:</b> Conventional commit messages</li>
      </ul>
      
      <h3>Testing Strategy</h3>
      <ul>
        <li><b>Unit Tests:</b> Individual component testing</li>
        <li><b>Integration Tests:</b> API endpoint testing</li>
        <li><b>E2E Tests:</b> Full application flow testing</li>
        <li><b>ML Tests:</b> Model accuracy and performance testing</li>
      </ul>
      
      <h2 id="configuration">Configuration</h2>
      <p>Environment-specific configuration is managed through:</p>
      
      <h3>Environment Files</h3>
      <ul>
        <li><code>.env</code> - Local development configuration</li>
        <li><code>.env.production</code> - Production configuration</li>
        <li><code>.env.staging</code> - Staging environment configuration</li>
      </ul>
      
      <h3>Key Configuration Areas</h3>
      <ul>
        <li><b>Database:</b> Connection settings and credentials</li>
        <li><b>API Keys:</b> External service integrations</li>
        <li><b>ML Models:</b> Model paths and configuration</li>
        <li><b>File Storage:</b> Upload and storage settings</li>
        <li><b>Notifications:</b> Email and push notification settings</li>
      </ul>
      
      <h2 id="security">Security Structure</h2>
      <p>Security is implemented at multiple levels:</p>
      
      <h3>Authentication & Authorization</h3>
      <ul>
        <li><b>JWT Tokens:</b> Stateless authentication</li>
        <li><b>Role-based Access:</b> User role management</li>
        <li><b>Permission System:</b> Granular access control</li>
        <li><b>API Rate Limiting:</b> Request throttling</li>
      </ul>
      
      <h3>Data Protection</h3>
      <ul>
        <li><b>Input Validation:</b> Request data sanitization</li>
        <li><b>SQL Injection Prevention:</b> Parameterized queries</li>
        <li><b>XSS Protection:</b> Output encoding</li>
        <li><b>CSRF Protection:</b> Cross-site request forgery prevention</li>
      </ul>
      
      <h2 id="monitoring">Monitoring & Logging</h2>
      <p>Comprehensive monitoring and logging systems:</p>
      
      <h3>Application Monitoring</h3>
      <ul>
        <li><b>Error Tracking:</b> Exception monitoring and alerting</li>
        <li><b>Performance Monitoring:</b> Response time and throughput</li>
        <li><b>User Analytics:</b> Usage patterns and behavior</li>
        <li><b>ML Model Monitoring:</b> Accuracy and performance tracking</li>
      </ul>
      
      <h3>Logging Structure</h3>
      <ul>
        <li><b>Application Logs:</b> General application events</li>
        <li><b>Error Logs:</b> Exception and error tracking</li>
        <li><b>Access Logs:</b> User activity and API usage</li>
        <li><b>ML Logs:</b> Model inference and performance data</li>
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