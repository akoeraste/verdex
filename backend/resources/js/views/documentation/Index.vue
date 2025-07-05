<template>
  <div class="doc-layout-overview">
    <!-- Modern floating navigation bar -->
    <nav class="doc-navbar">
      <div class="nav-container">
        <div class="nav-brand">
          <router-link to="/documentation" class="brand-link">
            <img src="/logo.png" alt="Verdex Logo" class="brand-logo" />
            <span class="brand-text">Verdex Docs</span>
          </router-link>
        </div>
          <router-link to="/" class="login-btn">
            <i class="bi bi-person-circle"></i>
            <span>Home</span>
          </router-link>
      </div>
    </nav>

    <!-- Main content area -->
    <div class="documentation-landing">
      <!-- Hero Section -->
      <section class="hero-section">
        <div class="hero-content">
          <div class="hero-badge">
            <span class="badge-icon">📚</span>
            <span class="badge-text">Documentation</span>
          </div>
          <h1 class="hero-title">
            Verdex Platform
            <span class="title-accent">Documentation</span>
          </h1>
          <p class="hero-subtitle">
            Comprehensive guides and resources for building, deploying, and maintaining the Verdex plant identification platform.
          </p>
          <div class="hero-stats">
            <div class="stat-item">
              <span class="stat-number">4</span>
              <span class="stat-label">Core Modules</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">50+</span>
              <span class="stat-label">API Endpoints</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">100%</span>
              <span class="stat-label">Open Source</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Documentation Cards -->
      <section class="docs-section">
        <div class="section-header">
          <h2 class="section-title">Choose Your Path</h2>
          <p class="section-subtitle">Explore the documentation that fits your needs</p>
        </div>
        
              <div class="docs-grid">
        <!-- ML Section -->
        <div class="section-group">
          <h3 class="section-title">Machine Learning</h3>
          <div class="section-cards">
            <router-link to="/documentation/ml" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-cpu"></i>
                </div>
                <div class="card-badge">ML</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">ML Documentation</h3>
                <p class="card-description">Learn about the machine learning models, training pipeline, and deployment strategies.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
            <router-link to="/documentation/project-structure" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-diagram-3"></i>
                </div>
                <div class="card-badge">Structure</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">Project Structure</h3>
                <p class="card-description">Understand the overall project architecture, file organization, and development workflow.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
          </div>
        </div>

        <!-- Frontend Section -->
        <div class="section-group">
          <h3 class="section-title">Frontend Development</h3>
          <div class="section-cards">
            <router-link to="/documentation/frontend" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-phone"></i>
                </div>
                <div class="card-badge">Flutter</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">Frontend Development</h3>
                <p class="card-description">Build mobile applications with Flutter, implement state management, and integrate with the Verdex API.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
            <router-link to="/documentation/connect" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-link-45deg"></i>
                </div>
                <div class="card-badge">Integration</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">Connect & Integrate</h3>
                <p class="card-description">Learn how to connect your applications to the Verdex platform, handle authentication, and manage API integrations.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
          </div>
        </div>

        <!-- Backend Section -->
        <div class="section-group">
          <h3 class="section-title">Backend Development</h3>
          <div class="section-cards">
            <router-link to="/documentation/backend" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-server"></i>
                </div>
                <div class="card-badge">Laravel</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">Backend Development</h3>
                <p class="card-description">Explore the Laravel backend architecture, database schema, authentication system, and deployment strategies.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
            <router-link to="/documentation/api" class="doc-card">
              <div class="card-header">
                <div class="card-icon">
                  <i class="bi bi-code-slash"></i>
                </div>
                <div class="card-badge">REST API</div>
              </div>
              <div class="card-content">
                <h3 class="card-title">API Reference</h3>
                <p class="card-description">Complete API documentation with endpoints, authentication, error handling, and usage examples.</p>
              </div>
              <div class="card-footer">
                <span class="card-link">
                  Get Started
                  <i class="bi bi-arrow-right"></i>
                </span>
              </div>
            </router-link>
          </div>
        </div>
      </div>
      </section>

      <!-- Quick Start Section -->
      <section class="quick-start-section">
        <div class="section-header">
          <h2 class="section-title">Quick Start</h2>
          <p class="section-subtitle">Get up and running in minutes</p>
        </div>
        
        <div class="quick-start-grid">
          <div class="quick-step">
            <div class="step-number">1</div>
            <h3 class="step-title">Environment Setup</h3>
            <p class="step-description">Configure your development environment with the required tools and dependencies.</p>
            <router-link to="/documentation/connect" class="step-link">
              Setup Guide <i class="bi bi-arrow-right"></i>
            </router-link>
          </div>
          
          <div class="quick-step">
            <div class="step-number">2</div>
            <h3 class="step-title">API Integration</h3>
            <p class="step-description">Learn how to authenticate and make API calls to the Verdex backend.</p>
            <router-link to="/documentation/api" class="step-link">
              API Reference <i class="bi bi-arrow-right"></i>
            </router-link>
          </div>
          
          <div class="quick-step">
            <div class="step-number">3</div>
            <h3 class="step-title">Deploy & Scale</h3>
            <p class="step-description">Deploy your application and scale it to handle production workloads.</p>
            <router-link to="/documentation/backend" class="step-link">
              Deployment Guide <i class="bi bi-arrow-right"></i>
            </router-link>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
// No menu array needed - using structured sections instead
</script>

<style scoped>
/* Layout for overview page */
.doc-layout-overview {
  min-height: 100vh;
  background: linear-gradient(120deg, #f8fafc 0%, #e3f2fd 100%);
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Modern Navigation Bar */
.doc-navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 32px rgba(0, 0, 0, 0.08);
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
}

.nav-brand {
  display: flex;
  align-items: center;
}

.brand-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-decoration: none;
  color: #1a1a1a;
  font-weight: 700;
  font-size: 1.25rem;
  transition: transform 0.2s ease;
}

.brand-link:hover {
  transform: translateY(-1px);
}

.brand-logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  object-fit: contain;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
}

.brand-text {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  border-radius: 12px;
  transition: all 0.2s ease;
  position: relative;
}

.nav-link:hover {
  color: #667eea;
  background: rgba(102, 126, 234, 0.08);
  transform: translateY(-1px);
}

.nav-link.router-link-active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.12);
  font-weight: 600;
}

.nav-link i {
  font-size: 1.1rem;
}

.nav-actions {
  display: flex;
  align-items: center;
}

.login-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.95rem;
  border-radius: 12px;
  transition: all 0.2s ease;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
  color: white;
}

/* Main content area */
.documentation-landing {
  max-width: 1200px;
  margin: 0 auto;
  padding-top: 90px; /* Space for fixed navbar */
}

/* Hero Section */
.hero-section {
  text-align: center;
  padding: 4rem 0 6rem 0;
  margin-bottom: 4rem;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  border: 1px solid rgba(102, 126, 234, 0.2);
  border-radius: 50px;
  margin-bottom: 2rem;
  backdrop-filter: blur(10px);
}

.badge-icon {
  font-size: 1.25rem;
}

.badge-text {
  font-weight: 600;
  color: #667eea;
  font-size: 0.95rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  color: #1a1a1a;
}

.title-accent {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-subtitle {
  font-size: 1.25rem;
  color: #4a5568;
  max-width: 600px;
  margin: 0 auto 3rem auto;
  line-height: 1.6;
}

.hero-stats {
  display: flex;
  justify-content: center;
  gap: 3rem;
  margin-top: 3rem;
}

.stat-item {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 2.5rem;
  font-weight: 800;
  color: #667eea;
  line-height: 1;
}

.stat-label {
  font-size: 0.95rem;
  color: #4a5568;
  font-weight: 500;
}

/* Documentation Section */
.docs-section {
  margin-bottom: 6rem;
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
}

.section-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.section-subtitle {
  font-size: 1.125rem;
  color: #4a5568;
  max-width: 500px;
  margin: 0 auto;
}

.docs-grid {
  display: flex;
  flex-direction: column;
  gap: 3rem;
  margin-top: 3rem;
}

.section-group {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid rgba(102, 126, 234, 0.1);
}

.section-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.doc-card {
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  padding: 2rem;
  text-decoration: none;
  color: inherit;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  position: relative;
  overflow: hidden;
}

.doc-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.doc-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
  border-color: rgba(102, 126, 234, 0.2);
}

.doc-card:hover::before {
  transform: scaleX(1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.5rem;
}

.card-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.card-badge {
  padding: 0.5rem 1rem;
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.card-content {
  margin-bottom: 2rem;
}

.card-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
  line-height: 1.3;
}

.card-description {
  color: #4a5568;
  line-height: 1.6;
  font-size: 1rem;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-link {
  color: #667eea;
  font-weight: 600;
  font-size: 0.95rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: gap 0.2s ease;
}

.doc-card:hover .card-link {
  gap: 0.75rem;
}

/* Quick Start Section */
.quick-start-section {
  margin-bottom: 4rem;
}

.quick-start-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.quick-step {
  background: rgba(255, 255, 255, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 16px;
  padding: 2rem;
  text-align: center;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.quick-step:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(102, 126, 234, 0.1);
}

.step-number {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1.25rem;
  margin: 0 auto 1.5rem auto;
}

.step-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.step-description {
  color: #4a5568;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.step-link {
  color: #667eea;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.95rem;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  transition: gap 0.2s ease;
}

.step-link:hover {
  gap: 0.75rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .nav-container {
    padding: 0 1rem;
  }
  
  .nav-menu {
    display: none;
  }
  
  .brand-text {
    display: none;
  }
  
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-stats {
    flex-direction: column;
    gap: 2rem;
  }
  
  .docs-grid {
    grid-template-columns: 1fr;
  }
  
  .quick-start-grid {
    grid-template-columns: 1fr;
  }
  
  .section-title {
    font-size: 2rem;
  }
  
  .hero-section {
    padding: 2rem 0 4rem 0;
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 2rem;
  }
  
  .hero-subtitle {
    font-size: 1.125rem;
  }
  
  .doc-card {
    padding: 1.5rem;
  }
  
  .quick-step {
    padding: 1.5rem;
  }
}
</style> 