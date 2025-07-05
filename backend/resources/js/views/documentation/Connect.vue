<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">Connect & Integrate</h1>
      <p>Learn how to connect your applications to the Verdex platform, handle authentication, and manage API integrations.</p>
      
      <h2 id="api-base-url">API Base URL</h2>
      <p>All API requests should be made to the following base URL:</p>
      <pre><code>Production: https://api.verdex.app
Development: http://localhost:8000</code></pre>
      
      <h2 id="authentication">Authentication</h2>
      <p>The Verdex API uses JWT (JSON Web Tokens) for authentication. Here's how the authentication flow works:</p>
      <ol>
        <li><b>Login Request:</b> Send credentials to <code>/api/login</code></li>
        <li><b>Token Response:</b> Receive JWT token and user data</li>
        <li><b>API Requests:</b> Include token in Authorization header</li>
      </ol>
      
      <h3>Example Login Request</h3>
      <pre><code>POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password"
}</code></pre>
      
      <h3>Example Response</h3>
      <pre><code>{
  "status": "success",
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "user@example.com",
      "role": "user"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  }
}</code></pre>
      
      <h2 id="api-calls">Making API Calls</h2>
      <p>Include the JWT token in the Authorization header for all authenticated requests:</p>
      <pre><code>Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...</code></pre>
      
      <h3>JavaScript/Fetch Example</h3>
      <pre><code>const response = await fetch('https://api.verdex.app/api/plants', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
});

const data = await response.json();</code></pre>
      
      <h3>cURL Example</h3>
      <pre><code>curl -X GET "https://api.verdex.app/api/plants" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json"</code></pre>
      
      <h2 id="error-handling">Error Handling</h2>
      <p>The API returns standardized error responses. Common HTTP status codes:</p>
      <ul>
        <li><code>200</code> - Success</li>
        <li><code>201</code> - Created</li>
        <li><code>400</code> - Bad Request (validation errors)</li>
        <li><code>401</code> - Unauthorized (invalid/missing token)</li>
        <li><code>403</code> - Forbidden (insufficient permissions)</li>
        <li><code>404</code> - Not Found</li>
        <li><code>422</code> - Validation Error</li>
        <li><code>500</code> - Server Error</li>
      </ul>
      
      <h3>Error Response Format</h3>
      <pre><code>{
  "status": "error",
  "message": "Validation failed",
  "errors": {
    "email": ["The email field is required."],
    "password": ["The password must be at least 8 characters."]
  }
}</code></pre>
      
      <h2 id="rate-limiting">Rate Limiting</h2>
      <ul>
        <li>API requests are rate-limited to prevent abuse</li>
        <li>Default limit: 60 requests per minute per IP</li>
        <li>Rate limit headers included in responses</li>
        <li>Contact support for higher limits if needed</li>
      </ul>
      
      <h2 id="best-practices">Best Practices</h2>
      <ul>
        <li><b>Store tokens securely:</b> Use secure storage (not localStorage for sensitive apps)</li>
        <li><b>Handle token expiration:</b> Implement refresh token logic</li>
        <li><b>Validate responses:</b> Always check HTTP status codes</li>
        <li><b>Use HTTPS:</b> Always use HTTPS in production</li>
        <li><b>Implement retry logic:</b> Handle temporary network issues</li>
        <li><b>Cache responses:</b> Cache static data to reduce API calls</li>
      </ul>
      
      <h2 id="sdk-libraries">SDK & Libraries</h2>
      <p>Official SDKs and community libraries for popular platforms:</p>
      <ul>
        <li><b>JavaScript/TypeScript:</b> <code>@verdex/api-client</code></li>
        <li><b>Python:</b> <code>verdex-python</code></li>
        <li><b>PHP:</b> <code>verdex-php</code></li>
        <li><b>Flutter/Dart:</b> <code>verdex_dart</code></li>
        <li><b>React Native:</b> <code>react-native-verdex</code></li>
      </ul>
      
      <h2 id="webhooks">Webhooks</h2>
      <p>Configure webhooks to receive real-time notifications:</p>
      <ul>
        <li>User registration events</li>
        <li>Plant identification results</li>
        <li>Feedback submissions</li>
        <li>System maintenance notifications</li>
      </ul>
      
      <h3>Webhook Configuration</h3>
      <pre><code>POST /api/webhooks
{
  "url": "https://your-app.com/webhooks/verdex",
  "events": ["user.registered", "plant.identified"],
  "secret": "your-webhook-secret"
}</code></pre>
      
      <h2 id="testing">Testing</h2>
      <ul>
        <li>Use the development environment for testing</li>
        <li>Test with sample data provided in the API documentation</li>
        <li>Use tools like Postman or Insomnia for API testing</li>
        <li>Implement automated tests for your integration</li>
      </ul>
      
      <h2 id="support">Support</h2>
      <ul>
        <li>API Documentation: <code>https://api.verdex.app/docs</code></li>
        <li>GitHub Issues: <code>https://github.com/verdex/verdex-api/issues</code></li>
        <li>Email Support: <code>api-support@verdex.app</code></li>
        <li>Discord Community: <code>https://discord.gg/verdex</code></li>
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