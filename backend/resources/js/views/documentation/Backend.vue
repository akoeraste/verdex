<template>
  <DocumentationLayout>
    <div class="backend-docs">
      <div class="page-header">
        <div class="header-badge">
          <i class="bi bi-server"></i>
          <span>Laravel Backend</span>
        </div>
        <h1 id="overview">Backend Documentation</h1>
        <p class="lead-text">The Verdex backend is a Laravel 10.x RESTful API that powers the Verdex mobile and admin applications. It manages users, plants, feedback, notifications, and more.</p>
      </div>

      <section class="doc-section">
        <h2 id="features">
          <i class="bi bi-stars"></i>
          Features
        </h2>
        <div class="features-grid">
          <div class="feature-item">
            <i class="bi bi-arrow-repeat"></i>
            <span>RESTful API for all app features</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-shield-check"></i>
            <span>User authentication (Sanctum)</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-person-badge"></i>
            <span>Role & permission management</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-flower1"></i>
            <span>Plant CRUD and search</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-chat-dots"></i>
            <span>Feedback system with admin responses</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-bell"></i>
            <span>Notification system (database & email)</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-activity"></i>
            <span>Activity logging</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-translate"></i>
            <span>Multi-language support</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-upload"></i>
            <span>File/image upload</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-lightning"></i>
            <span>Caching and performance optimizations</span>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="project-structure">
          <i class="bi bi-folder2-open"></i>
          Project Structure
        </h2>
        <div class="code-block">
          <div class="code-header">
            <span>Directory Structure</span>
          </div>
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
seeders/             # Database seeders</code></pre>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="main-modules">
          <i class="bi bi-puzzle"></i>
          Main Modules/Services
        </h2>
        <div class="modules-grid">
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-people"></i>
            </div>
            <h3>User Management</h3>
            <p>Registration, login, profile, roles, permissions</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-flower1"></i>
            </div>
            <h3>Plant Management</h3>
            <p>CRUD, categories, translations</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-chat-dots"></i>
            </div>
            <h3>Feedback System</h3>
            <p>User feedback, admin responses</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-bell"></i>
            </div>
            <h3>Notification System</h3>
            <p>Database/email notifications</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-activity"></i>
            </div>
            <h3>Activity Logging</h3>
            <p>User/system actions</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-upload"></i>
            </div>
            <h3>File Storage</h3>
            <p>Image/file upload</p>
          </div>
          <div class="module-card">
            <div class="module-icon">
              <i class="bi bi-translate"></i>
            </div>
            <h3>Localization</h3>
            <p>Multi-language support</p>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="database-schema">
          <i class="bi bi-database"></i>
          Database Schema
        </h2>
        <div class="info-box">
          <div class="info-icon">
            <i class="bi bi-info-circle"></i>
          </div>
          <div class="info-content">
            <h4>Core Tables</h4>
            <p><code>users</code>, <code>plants</code>, <code>categories</code>, <code>plant_translations</code>, <code>feedback</code>, <code>notifications</code>, <code>activity_logs</code>, <code>roles</code>, <code>permissions</code>, <code>favorites</code></p>
            <p>See <code>database/migrations/</code> for details</p>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="auth">
          <i class="bi bi-shield-lock"></i>
          Authentication & Authorization
        </h2>
        <div class="auth-features">
          <div class="auth-item">
            <i class="bi bi-key"></i>
            <span>Uses <strong>Laravel Sanctum</strong> for API token auth</span>
          </div>
          <div class="auth-item">
            <i class="bi bi-person-badge"></i>
            <span>Role-based and permission-based access (Spatie package)</span>
          </div>
          <div class="auth-item">
            <i class="bi bi-shield-check"></i>
            <span>Policies for resource access</span>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="api-structure">
          <i class="bi bi-code-slash"></i>
          API Structure
        </h2>
        <div class="api-endpoints">
          <div class="endpoint-group">
            <h4>All API routes in <code>routes/api.php</code></h4>
            <div class="endpoints-grid">
              <div class="endpoint-category">
                <h5><i class="bi bi-shield-lock"></i> Authentication</h5>
                <ul>
                  <li><code>POST /api/login</code> - User login</li>
                  <li><code>POST /api/register</code> - User registration</li>
                  <li><code>POST /api/logout</code> - User logout</li>
                  <li><code>POST /api/forgot-password</code> - Password reset request</li>
                  <li><code>POST /api/reset-password</code> - Password reset</li>
                  <li><code>GET /api/user</code> - Get current user</li>
                  <li><code>PUT /api/user</code> - Update user profile</li>
                </ul>
              </div>
              
              <div class="endpoint-category">
                <h5><i class="bi bi-flower1"></i> Plants</h5>
                <ul>
                  <li><code>GET /api/plants</code> - List all plants</li>
                  <li><code>GET /api/plants/{id}</code> - Get specific plant</li>
                  <li><code>POST /api/plants</code> - Create new plant</li>
                  <li><code>PUT /api/plants/{id}</code> - Update plant</li>
                  <li><code>DELETE /api/plants/{id}</code> - Delete plant</li>
                  <li><code>GET /api/plants/search</code> - Search plants</li>
                  <li><code>GET /api/plants/categories</code> - Get plant categories</li>
                </ul>
              </div>
              
              <div class="endpoint-category">
                <h5><i class="bi bi-chat-dots"></i> Feedback</h5>
                <ul>
                  <li><code>GET /api/feedback</code> - List feedback</li>
                  <li><code>POST /api/feedback</code> - Submit feedback</li>
                  <li><code>PUT /api/feedback/{id}</code> - Update feedback</li>
                  <li><code>DELETE /api/feedback/{id}</code> - Delete feedback</li>
                  <li><code>POST /api/feedback/{id}/respond</code> - Admin response</li>
                </ul>
              </div>
              
              <div class="endpoint-category">
                <h5><i class="bi bi-bell"></i> Notifications</h5>
                <ul>
                  <li><code>GET /api/notifications</code> - List notifications</li>
                  <li><code>PUT /api/notifications/{id}/read</code> - Mark as read</li>
                  <li><code>DELETE /api/notifications/{id}</code> - Delete notification</li>
                  <li><code>POST /api/notifications/mark-all-read</code> - Mark all as read</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="notifications">
          <i class="bi bi-bell"></i>
          Notifications & Feedback
        </h2>
        <div class="notification-system">
          <div class="info-box">
            <div class="info-icon">
              <i class="bi bi-info-circle"></i>
            </div>
            <div class="info-content">
              <h4>Notification System</h4>
              <p>The backend uses Laravel's notification system with database and email channels.</p>
            </div>
          </div>
          
          <div class="notification-types">
            <h4>Notification Types</h4>
            <div class="notification-grid">
              <div class="notification-item">
                <i class="bi bi-chat-dots"></i>
                <h5>Feedback Submitted</h5>
                <p>Sent to admins when users submit feedback</p>
              </div>
              <div class="notification-item">
                <i class="bi bi-reply"></i>
                <h5>Feedback Response</h5>
                <p>Sent to users when admins respond to feedback</p>
              </div>
              <div class="notification-item">
                <i class="bi bi-key"></i>
                <h5>Password Reset</h5>
                <p>Sent when users request password reset</p>
              </div>
              <div class="notification-item">
                <i class="bi bi-person-plus"></i>
                <h5>Welcome Email</h5>
                <p>Sent to new users upon registration</p>
              </div>
            </div>
          </div>
          
          <div class="feedback-system">
            <h4>Feedback System</h4>
            <div class="feedback-flow">
              <div class="flow-step">
                <div class="step-number">1</div>
                <h5>User Submits Feedback</h5>
                <p>Users can submit feedback through the mobile app</p>
              </div>
              <div class="flow-step">
                <div class="step-number">2</div>
                <h5>Admin Notification</h5>
                <p>Admins receive notification of new feedback</p>
              </div>
              <div class="flow-step">
                <div class="step-number">3</div>
                <h5>Admin Response</h5>
                <p>Admins can respond to feedback through admin panel</p>
              </div>
              <div class="flow-step">
                <div class="step-number">4</div>
                <h5>User Notification</h5>
                <p>Users receive notification of admin response</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="caching">
          <i class="bi bi-lightning"></i>
          Caching & Performance
        </h2>
        <div class="caching-strategy">
          <div class="cache-layers">
            <h4>Cache Layers</h4>
            <div class="cache-grid">
              <div class="cache-item">
                <i class="bi bi-database"></i>
                <h5>Database Caching</h5>
                <p>Query results cached for frequently accessed data</p>
                <code>Cache::remember('plants', 3600, function() { ... });</code>
              </div>
              <div class="cache-item">
                <i class="bi bi-file-earmark"></i>
                <h5>File Caching</h5>
                <p>Static content and computed results cached</p>
                <code>Cache::put('categories', $categories, 7200);</code>
              </div>
              <div class="cache-item">
                <i class="bi bi-arrow-repeat"></i>
                <h5>Route Caching</h5>
                <p>Route definitions cached for faster routing</p>
                <code>php artisan route:cache</code>
              </div>
              <div class="cache-item">
                <i class="bi bi-view-stacked"></i>
                <h5>View Caching</h5>
                <p>Compiled Blade templates cached</p>
                <code>php artisan view:cache</code>
              </div>
            </div>
          </div>
          
          <div class="performance-optimizations">
            <h4>Performance Optimizations</h4>
            <div class="optimization-list">
              <div class="optimization-item">
                <i class="bi bi-arrow-up-circle"></i>
                <span>Eager loading relationships to prevent N+1 queries</span>
              </div>
              <div class="optimization-item">
                <i class="bi bi-arrow-up-circle"></i>
                <span>Database indexing on frequently queried columns</span>
              </div>
              <div class="optimization-item">
                <i class="bi bi-arrow-up-circle"></i>
                <span>API resource transformation for optimized responses</span>
              </div>
              <div class="optimization-item">
                <i class="bi bi-arrow-up-circle"></i>
                <span>Pagination for large datasets</span>
              </div>
              <div class="optimization-item">
                <i class="bi bi-arrow-up-circle"></i>
                <span>Image optimization and CDN integration</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="testing">
          <i class="bi bi-check-circle"></i>
          Testing
        </h2>
        <div class="testing-strategy">
          <div class="test-types">
            <h4>Test Types</h4>
            <div class="test-grid">
              <div class="test-item">
                <i class="bi bi-unit"></i>
                <h5>Unit Tests</h5>
                <p>Test individual methods and classes</p>
                <ul>
                  <li>Model relationships and scopes</li>
                  <li>Service class methods</li>
                  <li>Helper functions</li>
                </ul>
              </div>
              <div class="test-item">
                <i class="bi bi-arrow-left-right"></i>
                <h5>Feature Tests</h5>
                <p>Test complete features and workflows</p>
                <ul>
                  <li>API endpoint functionality</li>
                  <li>Authentication flows</li>
                  <li>CRUD operations</li>
                </ul>
              </div>
              <div class="test-item">
                <i class="bi bi-database"></i>
                <h5>Database Tests</h5>
                <p>Test database operations and migrations</p>
                <ul>
                  <li>Migration rollbacks</li>
                  <li>Seeder functionality</li>
                  <li>Database constraints</li>
                </ul>
              </div>
            </div>
          </div>
          
          <div class="test-commands">
            <h4>Testing Commands</h4>
            <div class="command-grid">
              <div class="command-item">
                <code>php artisan test</code>
                <span>Run all tests</span>
              </div>
              <div class="command-item">
                <code>php artisan test --filter=PlantTest</code>
                <span>Run specific test class</span>
              </div>
              <div class="command-item">
                <code>php artisan test --coverage</code>
                <span>Run tests with coverage report</span>
              </div>
              <div class="command-item">
                <code>php artisan test --parallel</code>
                <span>Run tests in parallel</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="deployment">
          <i class="bi bi-rocket"></i>
          Deployment
        </h2>
        <div class="deployment-guide">
          <div class="deployment-steps">
            <h4>Deployment Steps</h4>
            <div class="step-list">
              <div class="deployment-step">
                <div class="step-number">1</div>
                <div class="step-content">
                  <h5>Environment Setup</h5>
                  <p>Configure production environment variables</p>
                  <code>cp .env.example .env</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">2</div>
                <div class="step-content">
                  <h5>Dependencies</h5>
                  <p>Install production dependencies</p>
                  <code>composer install --optimize-autoloader --no-dev</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">3</div>
                <div class="step-content">
                  <h5>Database</h5>
                  <p>Run migrations and seeders</p>
                  <code>php artisan migrate --force</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">4</div>
                <div class="step-content">
                  <h5>Optimization</h5>
                  <p>Cache routes, views, and config</p>
                  <code>php artisan optimize</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">5</div>
                <div class="step-content">
                  <h5>Storage</h5>
                  <p>Create storage link</p>
                  <code>php artisan storage:link</code>
                </div>
              </div>
            </div>
          </div>
          
          <div class="deployment-config">
            <h4>Deployment Configuration</h4>
            <div class="config-grid">
              <div class="config-item">
                <h5>Web Server</h5>
                <p>Nginx or Apache with PHP-FPM</p>
                <code>nginx -g 'daemon off;'</code>
              </div>
              <div class="config-item">
                <h5>Queue Worker</h5>
                <p>Process background jobs</p>
                <code>php artisan queue:work</code>
              </div>
              <div class="config-item">
                <h5>Schedule</h5>
                <p>Run scheduled tasks</p>
                <code>* * * * * php artisan schedule:run</code>
              </div>
              <div class="config-item">
                <h5>Monitoring</h5>
                <p>Log monitoring and error tracking</p>
                <code>tail -f storage/logs/laravel.log</code>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="contribution">
          <i class="bi bi-people"></i>
          Contribution Guidelines
        </h2>
        <div class="contribution-guide">
          <div class="development-setup">
            <h4>Development Setup</h4>
            <div class="setup-steps">
              <div class="setup-step">
                <h5>1. Clone Repository</h5>
                <code>git clone https://github.com/your-org/verdex-backend.git</code>
              </div>
              <div class="setup-step">
                <h5>2. Install Dependencies</h5>
                <code>composer install</code>
              </div>
              <div class="setup-step">
                <h5>3. Environment Setup</h5>
                <code>cp .env.example .env</code>
              </div>
              <div class="setup-step">
                <h5>4. Database Setup</h5>
                <code>php artisan migrate --seed</code>
              </div>
              <div class="setup-step">
                <h5>5. Start Development Server</h5>
                <code>php artisan serve</code>
              </div>
            </div>
          </div>
          
          <div class="coding-standards">
            <h4>Coding Standards</h4>
            <div class="standards-list">
              <div class="standard-item">
                <i class="bi bi-check2"></i>
                <span>Follow PSR-12 coding standards</span>
              </div>
              <div class="standard-item">
                <i class="bi bi-check2"></i>
                <span>Use meaningful variable and function names</span>
              </div>
              <div class="standard-item">
                <i class="bi bi-check2"></i>
                <span>Write comprehensive tests for new features</span>
              </div>
              <div class="standard-item">
                <i class="bi bi-check2"></i>
                <span>Document complex methods and classes</span>
              </div>
              <div class="standard-item">
                <i class="bi bi-check2"></i>
                <span>Use type hints and return types</span>
              </div>
            </div>
          </div>
          
          <div class="git-workflow">
            <h4>Git Workflow</h4>
            <div class="workflow-steps">
              <div class="workflow-step">
                <h5>1. Create Feature Branch</h5>
                <code>git checkout -b feature/your-feature-name</code>
              </div>
              <div class="workflow-step">
                <h5>2. Make Changes</h5>
                <p>Implement your feature with tests</p>
              </div>
              <div class="workflow-step">
                <h5>3. Commit Changes</h5>
                <code>git commit -m "feat: add new feature description"</code>
              </div>
              <div class="workflow-step">
                <h5>4. Push and Create PR</h5>
                <code>git push origin feature/your-feature-name</code>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="troubleshooting">
          <i class="bi bi-tools"></i>
          Troubleshooting
        </h2>
        <div class="troubleshooting-guide">
          <div class="common-issues">
            <h4>Common Issues</h4>
            <div class="issues-grid">
              <div class="issue-item">
                <h5>Database Connection Issues</h5>
                <p><strong>Problem:</strong> Cannot connect to database</p>
                <p><strong>Solution:</strong> Check .env configuration and database server status</p>
                <code>php artisan config:clear</code>
              </div>
              <div class="issue-item">
                <h5>Permission Errors</h5>
                <p><strong>Problem:</strong> Storage or cache permission denied</p>
                <p><strong>Solution:</strong> Set proper permissions on storage and bootstrap/cache</p>
                <code>chmod -R 775 storage bootstrap/cache</code>
              </div>
              <div class="issue-item">
                <h5>Queue Jobs Not Processing</h5>
                <p><strong>Problem:</strong> Background jobs stuck in queue</p>
                <p><strong>Solution:</strong> Start queue worker and check queue configuration</p>
                <code>php artisan queue:work --verbose</code>
              </div>
              <div class="issue-item">
                <h5>API Rate Limiting</h5>
                <p><strong>Problem:</strong> Too many requests error</p>
                <p><strong>Solution:</strong> Check rate limiting configuration in RouteServiceProvider</p>
                <code>php artisan route:clear</code>
              </div>
            </div>
          </div>
          
          <div class="debug-tools">
            <h4>Debug Tools</h4>
            <div class="tools-grid">
              <div class="tool-item">
                <h5>Laravel Telescope</h5>
                <p>Debug and monitor application requests</p>
                <code>composer require laravel/telescope --dev</code>
              </div>
              <div class="tool-item">
                <h5>Laravel Debugbar</h5>
                <p>Debug queries, routes, and performance</p>
                <code>composer require barryvdh/laravel-debugbar --dev</code>
              </div>
              <div class="tool-item">
                <h5>Log Files</h5>
                <p>Check application logs for errors</p>
                <code>tail -f storage/logs/laravel.log</code>
              </div>
              <div class="tool-item">
                <h5>Artisan Commands</h5>
                <p>Clear caches and debug configuration</p>
                <code>php artisan config:clear && php artisan cache:clear</code>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="future">
          <i class="bi bi-graph-up"></i>
          Future Improvements
        </h2>
        <div class="future-roadmap">
          <div class="roadmap-items">
            <div class="roadmap-item">
              <div class="roadmap-icon">
                <i class="bi bi-speedometer2"></i>
              </div>
              <div class="roadmap-content">
                <h5>Performance Optimization</h5>
                <ul>
                  <li>Implement Redis caching for better performance</li>
                  <li>Add database query optimization</li>
                  <li>Implement API response compression</li>
                  <li>Add CDN integration for static assets</li>
                </ul>
              </div>
            </div>
            
            <div class="roadmap-item">
              <div class="roadmap-icon">
                <i class="bi bi-shield-check"></i>
              </div>
              <div class="roadmap-content">
                <h5>Security Enhancements</h5>
                <ul>
                  <li>Implement API rate limiting per user</li>
                  <li>Add request validation middleware</li>
                  <li>Implement audit logging for sensitive operations</li>
                  <li>Add two-factor authentication</li>
                </ul>
              </div>
            </div>
            
            <div class="roadmap-item">
              <div class="roadmap-icon">
                <i class="bi bi-arrow-repeat"></i>
              </div>
              <div class="roadmap-content">
                <h5>Real-time Features</h5>
                <ul>
                  <li>Implement WebSocket connections</li>
                  <li>Add real-time notifications</li>
                  <li>Implement live chat support</li>
                  <li>Add real-time plant updates</li>
                </ul>
              </div>
            </div>
            
            <div class="roadmap-item">
              <div class="roadmap-icon">
                <i class="bi bi-graph-up"></i>
              </div>
              <div class="roadmap-content">
                <h5>Analytics & Monitoring</h5>
                <ul>
                  <li>Add comprehensive analytics dashboard</li>
                  <li>Implement error tracking and monitoring</li>
                  <li>Add performance metrics collection</li>
                  <li>Implement user behavior analytics</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>

    </div>
  </DocumentationLayout>
</template>

<script setup>
import DocumentationLayout from './DocumentationLayout.vue';
</script>

<style scoped>
.backend-docs {
  max-width: 100%;
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
  padding-bottom: 2rem;
  border-bottom: 2px solid rgba(102, 126, 234, 0.1);
}

.header-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  border: 1px solid rgba(102, 126, 234, 0.2);
  border-radius: 50px;
  margin-bottom: 1.5rem;
  backdrop-filter: blur(10px);
}

.header-badge i {
  font-size: 1.25rem;
  color: #667eea;
}

.header-badge span {
  font-weight: 600;
  color: #667eea;
  font-size: 0.95rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.lead-text {
  font-size: 1.25rem;
  color: #4a5568;
  line-height: 1.6;
  max-width: 600px;
  margin: 0 auto;
}

.doc-section {
  margin-bottom: 3rem;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.doc-section h2 {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1.5rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid rgba(102, 126, 234, 0.1);
}

.doc-section h2 i {
  color: #667eea;
  font-size: 1.5rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  transition: all 0.2s ease;
}

.feature-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
}

.feature-item i {
  color: #667eea;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.code-block {
  background: rgba(248, 250, 252, 0.9);
  border: 1px solid rgba(102, 126, 234, 0.1);
  border-radius: 12px;
  overflow: hidden;
}

.code-header {
  padding: 1rem 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border-bottom: 1px solid rgba(102, 126, 234, 0.1);
  font-weight: 600;
  color: #667eea;
}

pre {
  background: transparent;
  border-radius: 0;
  padding: 1.5rem;
  font-size: 0.95rem;
  overflow-x: auto;
  margin: 0;
}

code {
  font-family: 'Fira Mono', 'Consolas', 'Menlo', monospace;
  color: #2e7d32;
}

.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

.module-card {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  text-align: center;
  transition: all 0.2s ease;
}

.module-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
}

.module-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem auto;
  color: white;
  font-size: 1.5rem;
}

.module-card h3 {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.module-card p {
  color: #4a5568;
  font-size: 0.95rem;
}

.info-box {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border: 1px solid rgba(102, 126, 234, 0.1);
  border-radius: 12px;
}

.info-icon {
  color: #667eea;
  font-size: 1.5rem;
  flex-shrink: 0;
}

.info-content h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.info-content p {
  color: #4a5568;
  margin-bottom: 0.5rem;
}

.auth-features, .performance-features, .testing-info, .contribution-rules, .troubleshooting-tips, .future-features {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.auth-item, .perf-item, .test-item, .rule-item, .tip-item, .feature-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.auth-item i, .perf-item i, .test-item i, .rule-item i, .tip-item i, .feature-item i {
  color: #667eea;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.api-endpoints {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.endpoint-group h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.endpoint-group ul {
  margin-bottom: 1rem;
}

.endpoint-group li {
  margin-bottom: 0.5rem;
  color: #4a5568;
}

.notification-flow {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
}

.flow-step {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  min-width: 200px;
}

.step-number {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1.125rem;
}

.step-content h4 {
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.25rem;
}

.step-content p {
  color: #4a5568;
  font-size: 0.9rem;
}

.flow-arrow {
  font-size: 1.5rem;
  color: #667eea;
  font-weight: bold;
}

.deployment-steps {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.step-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.step-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.125rem;
}

@media (max-width: 768px) {
  .features-grid, .modules-grid {
    grid-template-columns: 1fr;
  }
  
  .notification-flow {
    flex-direction: column;
  }
  
  .flow-arrow {
    transform: rotate(90deg);
  }
  
  .doc-section {
    padding: 1.5rem;
  }
}
</style> 