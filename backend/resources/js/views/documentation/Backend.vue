<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">Backend Documentation (Laravel)</h1>
      <p>The Verdex backend is a Laravel 10.x RESTful API that powers the Verdex mobile and admin applications. It manages users, plants, feedback, notifications, and more.</p>
      <h2 id="features">Features</h2>
      <ul>
        <li>RESTful API for all app features</li>
        <li>User authentication (Sanctum)</li>
        <li>Role & permission management</li>
        <li>Plant CRUD and search</li>
        <li>Feedback system with admin responses</li>
        <li>Notification system (database & email)</li>
        <li>Activity logging</li>
        <li>Multi-language support</li>
        <li>File/image upload</li>
        <li>Caching and performance optimizations</li>
      </ul>
      <h2 id="project-structure">Project Structure</h2>
      <pre><code>app/
  Console/           # Artisan commands
  Exceptions/        # Error handling
  Http/
    Controllers/     # API controllers
    Middleware/      # Request middleware
    Requests/        # Form validation
    Resources/       # API resources
  Mail/              # Email notifications
  Models/            # Eloquent models
  Notifications/     # Notification classes
  Providers/         # Service providers
config/              # App configuration
routes/              # API and web routes
resources/           # Views, assets
public/              # Public files
storage/             # File storage
lang/                # Localization
migrations/          # Database migrations
seeders/             # Database seeders
</code></pre>
      <h2 id="main-modules">Main Modules/Services</h2>
      <ul>
        <li><b>User Management:</b> Registration, login, profile, roles, permissions</li>
        <li><b>Plant Management:</b> CRUD, categories, translations</li>
        <li><b>Feedback System:</b> User feedback, admin responses</li>
        <li><b>Notification System:</b> Database/email notifications</li>
        <li><b>Activity Logging:</b> User/system actions</li>
        <li><b>File Storage:</b> Image/file upload</li>
        <li><b>Localization:</b> Multi-language support</li>
      </ul>
      <h2 id="database-schema">Database Schema</h2>
      <ul>
        <li><code>users</code>, <code>plants</code>, <code>categories</code>, <code>plant_translations</code>, <code>feedback</code>, <code>notifications</code>, <code>activity_logs</code>, <code>roles</code>, <code>permissions</code>, <code>favorites</code></li>
        <li>See <code>database/migrations/</code> for details</li>
      </ul>
      <h2 id="auth">Authentication & Authorization</h2>
      <ul>
        <li>Uses <b>Laravel Sanctum</b> for API token auth</li>
        <li>Role-based and permission-based access (Spatie package)</li>
        <li>Policies for resource access</li>
      </ul>
      <h2 id="api-structure">API Structure</h2>
      <ul>
        <li>All API routes in <code>routes/api.php</code></li>
        <li>RESTful endpoints for all resources</li>
        <li>Auth endpoints: <code>/login</code>, <code>/register</code>, <code>/logout</code></li>
        <li>Feedback: <code>/feedback</code>, <code>/feedback/{id}/respond</code></li>
        <li>Notifications: <code>/notifications</code>, <code>/notifications/{id}/read</code>, etc.</li>
        <li>See <code>app/Http/Controllers/Api/</code></li>
      </ul>
      <h2 id="notifications">Notifications & Feedback</h2>
      <ul>
        <li>Users receive notifications when admins respond to feedback</li>
        <li>Notifications stored in DB and sent via email</li>
        <li>Users can view, mark as read, and delete notifications</li>
      </ul>
      <h2 id="caching">Caching & Performance</h2>
      <ul>
        <li>Uses Redis for cache (if configured)</li>
        <li>Query/result caching for performance</li>
        <li>File and image caching</li>
        <li>Queue support for notifications/emails</li>
      </ul>
      <h2 id="testing">Testing</h2>
      <ul>
        <li>Feature and unit tests in <code>tests/</code></li>
        <li>Run tests: <code>php artisan test</code></li>
      </ul>
      <h2 id="deployment">Deployment</h2>
      <ul>
        <li>Configure <code>.env</code> for production</li>
        <li>Run <code>php artisan migrate --seed</code></li>
        <li>Set up web server (Nginx/Apache)</li>
        <li>Use supervisor for queue workers</li>
        <li>Set up storage symlink: <code>php artisan storage:link</code></li>
      </ul>
      <h2 id="contribution">Contribution Guidelines</h2>
      <ul>
        <li>Fork and branch for features/bugfixes</li>
        <li>Follow PSR-12 coding standards</li>
        <li>Write tests for new features</li>
        <li>Submit pull requests for review</li>
      </ul>
      <h2 id="troubleshooting">Troubleshooting</h2>
      <ul>
        <li>Check <code>.env</code> for DB and mail config</li>
        <li>Run <code>php artisan config:cache</code> after changes</li>
        <li>Check logs in <code>storage/logs/</code></li>
        <li>For queue issues: check worker status</li>
      </ul>
      <h2 id="future">Future Improvements</h2>
      <ul>
        <li>Real-time broadcasting (WebSockets)</li>
        <li>Advanced analytics</li>
        <li>Microservices support</li>
        <li>More third-party integrations</li>
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