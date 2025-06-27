<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">API Documentation</h1>
      <p>The Verdex API is a RESTful service for plant identification, user management, feedback, notifications, and more. It powers both the mobile app and admin dashboard.</p>
      <h2 id="authentication">Authentication</h2>
      <ul>
        <li>Uses <b>Bearer token</b> (Laravel Sanctum)</li>
        <li>Obtain token via <code>/login</code> or <code>/register</code></li>
        <li>Pass <code>Authorization: Bearer &lt;token&gt;</code> in headers for protected endpoints</li>
      </ul>
      <h2 id="error-handling">Error Handling</h2>
      <ul>
        <li>All errors return JSON with <code>error</code> and <code>message</code> fields</li>
        <li>HTTP status codes indicate error type (400, 401, 403, 404, 422, 500)</li>
      </ul>
      <h2 id="endpoints">Endpoints</h2>
      <div class="doc-tabs">
        <div class="doc-tab-labels">
          <span :class="{active: tab==='auth'}" @click="tab='auth'">Auth</span>
          <span :class="{active: tab==='user'}" @click="tab='user'">User</span>
          <span :class="{active: tab==='plants'}" @click="tab='plants'">Plants</span>
          <span :class="{active: tab==='categories'}" @click="tab='categories'">Categories</span>
          <span :class="{active: tab==='feedback'}" @click="tab='feedback'">Feedback</span>
          <span :class="{active: tab==='notifications'}" @click="tab='notifications'">Notifications</span>
          <span :class="{active: tab==='favorites'}" @click="tab='favorites'">Favorites</span>
          <span :class="{active: tab==='activity'}" @click="tab='activity'">Activity Log</span>
        </div>
        <div v-if="tab==='auth'" class="doc-tab-content">
          <pre><code>POST /login
POST /register
POST /logout</code></pre>
        </div>
        <div v-if="tab==='user'" class="doc-tab-content">
          <pre><code>GET /user
PUT /user
POST /change-password</code></pre>
        </div>
        <div v-if="tab==='plants'" class="doc-tab-content">
          <pre><code>GET /plants
GET /plants/{id}
POST /plants
PUT /plants/{id}
DELETE /plants/{id}
GET /plants/app/all
GET /plants/app/search</code></pre>
        </div>
        <div v-if="tab==='categories'" class="doc-tab-content">
          <pre><code>GET /categories
POST /categories
PUT /categories/{id}
DELETE /categories/{id}</code></pre>
        </div>
        <div v-if="tab==='feedback'" class="doc-tab-content">
          <pre><code>POST /feedback
GET /feedback
GET /feedback/{id}
PUT /feedback/{id}/respond</code></pre>
        </div>
        <div v-if="tab==='notifications'" class="doc-tab-content">
          <pre><code>GET /notifications
GET /notifications/unread-count
PUT /notifications/{id}/read
PUT /notifications/mark-all-read
DELETE /notifications/{id}
DELETE /notifications</code></pre>
        </div>
        <div v-if="tab==='favorites'" class="doc-tab-content">
          <pre><code>GET /favorites
POST /favorites
DELETE /favorites/{plant_id}</code></pre>
        </div>
        <div v-if="tab==='activity'" class="doc-tab-content">
          <pre><code>GET /activity-logs</code></pre>
        </div>
      </div>
      <h2 id="example-request">Example Request</h2>
      <pre><code>POST /login
{
  "email": "user@example.com",
  "password": "secret"
}</code></pre>
      <h2 id="example-response">Example Response</h2>
      <pre><code>{
  "token": "...",
  "user": { ... }
}</code></pre>
      <h2 id="feedback-notification">Feedback & Notification Endpoints</h2>
      <ul>
        <li><b>Submit Feedback:</b> <code>POST /feedback</code> (category, rating, message, contact)</li>
        <li><b>Admin Respond:</b> <code>PUT /feedback/{id}/respond</code> (comment)</li>
        <li><b>User gets notification:</b> <code>GET /notifications</code></li>
        <li><b>Mark as read:</b> <code>PUT /notifications/{id}/read</code></li>
      </ul>
      <h2 id="pagination">Pagination, Filtering, Sorting</h2>
      <ul>
        <li>Most list endpoints support <code>?page=</code>, <code>?per_page=</code>, and resource-specific filters (e.g., <code>?status=pending</code>)</li>
        <li>Responses include <code>meta</code> with pagination info</li>
      </ul>
      <h2 id="status-codes">Status Codes</h2>
      <ul>
        <li><code>200 OK</code> — Success</li>
        <li><code>201 Created</code> — Resource created</li>
        <li><code>204 No Content</code> — Deleted</li>
        <li><code>400 Bad Request</code> — Invalid input</li>
        <li><code>401 Unauthorized</code> — Not authenticated</li>
        <li><code>403 Forbidden</code> — No permission</li>
        <li><code>404 Not Found</code> — Resource missing</li>
        <li><code>422 Unprocessable Entity</code> — Validation error</li>
        <li><code>500 Internal Server Error</code> — Server error</li>
      </ul>
      <h2 id="versioning">Versioning</h2>
      <ul>
        <li>Current version: v1 (default)</li>
        <li>Future: Use <code>/v2/</code> prefix for breaking changes</li>
      </ul>
      <h2 id="best-practices">Best Practices</h2>
      <ul>
        <li>Always use HTTPS</li>
        <li>Handle errors gracefully</li>
        <li>Use pagination for large lists</li>
        <li>Validate all input</li>
        <li>Keep tokens secure</li>
      </ul>
    </div>
  </DocumentationLayout>
</template>

<script setup>
import { ref } from 'vue';
import DocumentationLayout from './DocumentationLayout.vue';
const tab = ref('auth');
</script>

<style scoped>
.doc-tabs {
  margin: 1.5rem 0 2rem 0;
}
.doc-tab-labels {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 0.5rem;
}
.doc-tab-labels span {
  cursor: pointer;
  padding: 0.4rem 1.2rem;
  border-radius: 8px 8px 0 0;
  background: #f1f5f9;
  color: #2e7d32;
  font-weight: 500;
  font-size: 1rem;
  transition: background 0.15s;
}
.doc-tab-labels span.active {
  background: #fff;
  border-bottom: 2px solid #2e7d32;
  color: #22223b;
}
.doc-tab-content {
  background: #fff;
  border-radius: 0 0 8px 8px;
  box-shadow: 0 2px 8px rgba(34,34,59,0.04);
  padding: 1.2rem 1.5rem;
  font-size: 1rem;
  margin-bottom: 1.5rem;
  overflow-x: auto;
}
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