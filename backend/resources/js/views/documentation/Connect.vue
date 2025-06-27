<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">Backend-Frontend Connection Guide</h1>
      <p>This guide explains how the Verdex Flutter frontend connects to the Laravel backend API for authentication, data, feedback, and notifications.</p>
      <h2 id="api-base-url">API Base URL & Environment Setup</h2>
      <ul>
        <li><b>API Base URL:</b> Set in <code>lib/constants/api_config.dart</code> (Flutter)</li>
        <li>Example: <code>https://api.verdex.app/api</code></li>
        <li>Use environment variables for dev/staging/prod</li>
      </ul>
      <h2 id="authentication-flow">Authentication Flow</h2>
      <ol>
        <li>User logs in via <code>/login</code> (POST)</li>
        <li>Backend returns a Bearer token</li>
        <li>Frontend stores token securely (e.g., <code>SharedPreferences</code>)</li>
        <li>All subsequent API requests include <code>Authorization: Bearer &lt;token&gt;</code></li>
      </ol>
      <h2 id="how-frontend-calls">How Frontend Calls Backend APIs</h2>
      <ul>
        <li>Uses <code>http</code> package in Flutter</li>
        <li>All requests are JSON (<code>Content-Type: application/json</code>)</li>
        <li>Authenticated endpoints require Bearer token</li>
      </ul>
      <div class="doc-tabs">
        <div class="doc-tab-labels">
          <span :class="{active: tab==='dart'}" @click="tab='dart'">Dart Example</span>
        </div>
        <div v-if="tab==='dart'" class="doc-tab-content">
          <pre><code class="language-dart">final response = await http.get(
  Uri.parse('$baseUrl/plants'),
  headers: {'Authorization': 'Bearer $token'},
);</code></pre>
        </div>
      </div>
      <h2 id="error-handling">Error Handling & Status Codes</h2>
      <ul>
        <li>Backend returns standard HTTP status codes</li>
        <li>Error responses include <code>error</code> and <code>message</code> fields</li>
        <li>Frontend should handle 401 (unauthenticated), 403 (forbidden), 422 (validation), 500 (server error)</li>
      </ul>
      <h2 id="data-formats">Data Formats</h2>
      <ul>
        <li>All data exchanged as JSON</li>
        <li>Dates in ISO 8601 format</li>
      </ul>
      <pre><code class="language-json">{
  "data": [ ... ],
  "meta": { "current_page": 1, ... }
}</code></pre>
      <h2 id="cors-security">CORS & Security</h2>
      <ul>
        <li>Backend enables CORS for allowed origins</li>
        <li>Always use HTTPS in production</li>
        <li>Never expose tokens in logs or URLs</li>
      </ul>
      <h2 id="example-integration">Example Integration</h2>
      <div class="doc-tabs">
        <div class="doc-tab-labels">
          <span :class="{active: tab==='login'}" @click="tab='login'">Login</span>
          <span :class="{active: tab==='fetch'}" @click="tab='fetch'">Fetch Plants</span>
          <span :class="{active: tab==='feedback'}" @click="tab='feedback'">Submit Feedback</span>
          <span :class="{active: tab==='notif'}" @click="tab='notif'">Get Notifications</span>
        </div>
        <div v-if="tab==='login'" class="doc-tab-content">
          <pre><code class="language-dart">final response = await http.post(
  Uri.parse('$baseUrl/login'),
  body: jsonEncode({ 'email': email, 'password': password }),
  headers: { 'Content-Type': 'application/json' },
);</code></pre>
        </div>
        <div v-if="tab==='fetch'" class="doc-tab-content">
          <pre><code class="language-dart">final response = await http.get(
  Uri.parse('$baseUrl/plants'),
  headers: { 'Authorization': 'Bearer $token' },
);</code></pre>
        </div>
        <div v-if="tab==='feedback'" class="doc-tab-content">
          <pre><code class="language-dart">final response = await http.post(
  Uri.parse('$baseUrl/feedback'),
  body: jsonEncode({ 'category': 'bug_report', 'message': 'Found a bug!' }),
  headers: { 'Authorization': 'Bearer $token', 'Content-Type': 'application/json' },
);</code></pre>
        </div>
        <div v-if="tab==='notif'" class="doc-tab-content">
          <pre><code class="language-dart">final response = await http.get(
  Uri.parse('$baseUrl/notifications'),
  headers: { 'Authorization': 'Bearer $token' },
);</code></pre>
        </div>
      </div>
      <h2 id="troubleshooting">Troubleshooting Connection Issues</h2>
      <ul>
        <li>Check API base URL and network connectivity</li>
        <li>Ensure correct token is sent in headers</li>
        <li>For CORS errors, check backend CORS config</li>
        <li>For 401/403, check authentication and permissions</li>
        <li>Use tools like Postman to test endpoints</li>
      </ul>
      <h2 id="best-practices">Best Practices</h2>
      <ul>
        <li>Use environment variables for API URLs</li>
        <li>Handle all error cases in frontend</li>
        <li>Keep tokens secure and refresh as needed</li>
        <li>Log errors for debugging (but not sensitive data)</li>
        <li>Test integration in staging before production</li>
      </ul>
    </div>
  </DocumentationLayout>
</template>

<script setup>
import { ref } from 'vue';
import DocumentationLayout from './DocumentationLayout.vue';
const tab = ref('login');
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