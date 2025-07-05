<template>
  <DocumentationLayout>
    <div class="ml-docs">
      <div class="page-header">
        <div class="header-badge">
          <i class="bi bi-cpu"></i>
          <span>Machine Learning</span>
        </div>
        <h1 id="overview">ML Documentation</h1>
        <p class="lead-text">Verdex uses advanced machine learning for plant identification with MobileNetV2 architecture optimized for mobile deployment.</p>
      </div>

      <section class="doc-section">
        <h2 id="features">
          <i class="bi bi-stars"></i>
          Features
        </h2>
        <div class="features-grid">
          <div class="feature-item">
            <i class="bi bi-phone"></i>
            <span>Mobile-optimized architecture (MobileNetV2)</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-speedometer2"></i>
            <span>Real-time plant identification</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-graph-up"></i>
            <span>High accuracy with Top-3 and Top-5 metrics</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-arrow-repeat"></i>
            <span>Transfer learning with fine-tuning</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-file-earmark-arrow-down"></i>
            <span>TensorFlow Lite deployment</span>
          </div>
          <div class="feature-item">
            <i class="bi bi-shield-check"></i>
            <span>Robust data augmentation</span>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="model-architecture">
          <i class="bi bi-diagram-3"></i>
          Model Architecture
        </h2>
        <div class="architecture-details">
          <div class="model-card">
            <div class="model-icon">
              <i class="bi bi-phone"></i>
            </div>
            <h3>MobileNetV2</h3>
            <p>Primary architecture optimized for Flutter deployment</p>
            <div class="model-specs">
              <div class="spec-item">
                <strong>Input Size:</strong> 224x224 pixels
              </div>
              <div class="spec-item">
                <strong>Base Model:</strong> MobileNetV2 (pre-trained on ImageNet)
              </div>
              <div class="spec-item">
                <strong>Output:</strong> Multi-class classification
              </div>
              <div class="spec-item">
                <strong>Optimization:</strong> TensorFlow Lite conversion
              </div>
            </div>
          </div>
          
          <div class="architecture-flow">
            <h4>Model Architecture Flow</h4>
            <div class="flow-steps">
              <div class="flow-step">
                <div class="step-number">1</div>
                <h5>Input Preprocessing</h5>
                <p>Resize to 224x224, normalize pixel values</p>
              </div>
              <div class="flow-step">
                <div class="step-number">2</div>
                <h5>MobileNetV2 Base</h5>
                <p>Feature extraction with pre-trained weights</p>
              </div>
              <div class="flow-step">
                <div class="step-number">3</div>
                <h5>Global Average Pooling</h5>
                <p>Reduce spatial dimensions</p>
              </div>
              <div class="flow-step">
                <div class="step-number">4</div>
                <h5>Dense Layers</h5>
                <p>Classification head with dropout</p>
              </div>
              <div class="flow-step">
                <div class="step-number">5</div>
                <h5>Output</h5>
                <p>Softmax probabilities for plant classes</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="dataset">
          <i class="bi bi-database"></i>
          Dataset
        </h2>
        <div class="dataset-info">
          <div class="info-box">
            <div class="info-icon">
              <i class="bi bi-info-circle"></i>
            </div>
            <div class="info-content">
              <h4>Plant Dataset</h4>
              <p>Comprehensive plant image dataset with multiple classes for training and validation.</p>
            </div>
          </div>
          
          <div class="dataset-stats">
            <h4>Dataset Statistics</h4>
            <div class="stats-grid">
              <div class="stat-item">
                <i class="bi bi-images"></i>
                <h5>Training Set</h5>
                <p>Primary training data with data augmentation</p>
              </div>
              <div class="stat-item">
                <i class="bi bi-check-circle"></i>
                <h5>Validation Set</h5>
                <p>Model evaluation during training</p>
              </div>
              <div class="stat-item">
                <i class="bi bi-shield-check"></i>
                <h5>Test Set</h5>
                <p>Final model performance evaluation</p>
              </div>
            </div>
          </div>
          
          <div class="data-augmentation">
            <h4>Data Augmentation</h4>
            <div class="augmentation-list">
              <div class="aug-item">
                <i class="bi bi-arrow-clockwise"></i>
                <span>Random rotation and flipping</span>
              </div>
              <div class="aug-item">
                <i class="bi bi-brightness-high"></i>
                <span>Brightness and contrast adjustment</span>
              </div>
              <div class="aug-item">
                <i class="bi bi-zoom-in"></i>
                <span>Random zoom and crop</span>
              </div>
              <div class="aug-item">
                <i class="bi bi-palette"></i>
                <span>Color jittering</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="performance">
          <i class="bi bi-graph-up"></i>
          Performance Metrics
        </h2>
        <div class="performance-metrics">
          <div class="metrics-grid">
            <div class="metric-card">
              <div class="metric-icon">
                <i class="bi bi-target"></i>
              </div>
              <h4>Top-1 Accuracy</h4>
              <div class="metric-value">86.13%</div>
              <p>Primary classification accuracy</p>
            </div>
            
            <div class="metric-card">
              <div class="metric-icon">
                <i class="bi bi-list-ol"></i>
              </div>
              <h4>Top-3 Accuracy</h4>
              <div class="metric-value">95.40%</div>
              <p>Accuracy within top 3 predictions</p>
            </div>
            
            <div class="metric-card">
              <div class="metric-icon">
                <i class="bi bi-list-check"></i>
              </div>
              <h4>Top-5 Accuracy</h4>
              <div class="metric-value">97.53%</div>
              <p>Accuracy within top 5 predictions</p>
            </div>
            
            <div class="metric-card">
              <div class="metric-icon">
                <i class="bi bi-speedometer2"></i>
              </div>
              <h4>Inference Speed</h4>
              <div class="metric-value">~50ms</div>
              <p>Average inference time on mobile</p>
            </div>
          </div>
          
          <div class="training-progress">
            <h4>Training Progress</h4>
            <div class="progress-info">
              <div class="progress-item">
                <h5>Phase 1: Feature Extraction</h5>
                <p>Frozen base model training with validation accuracy reaching 84.17%</p>
              </div>
              <div class="progress-item">
                <h5>Phase 2: Fine-tuning</h5>
                <p>Unfrozen layers training achieving final accuracy of 86.13%</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="deployment">
          <i class="bi bi-phone"></i>
          Model Deployment
        </h2>
        <div class="deployment-guide">
          <div class="deployment-steps">
            <h4>Deployment Process</h4>
            <div class="step-list">
              <div class="deployment-step">
                <div class="step-number">1</div>
                <div class="step-content">
                  <h5>Model Conversion</h5>
                  <p>Convert Keras model to TensorFlow Lite format</p>
                  <code>tflite_model = tf.lite.TFLiteConverter.from_keras_model(model)</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">2</div>
                <div class="step-content">
                  <h5>Quantization</h5>
                  <p>Optimize model size with float16 quantization</p>
                  <code>converter.optimizations = [tf.lite.Optimize.DEFAULT]</code>
                </div>
              </div>
              <div class="deployment-step">
                <div class="step-number">3</div>
                <div class="step-content">
                  <h5>Flutter Integration</h5>
                  <p>Deploy optimized model to Flutter mobile app</p>
                  <code>plant_classifier_mobile.tflite</code>
                </div>
              </div>
            </div>
          </div>
          
          <div class="deployment-specs">
            <h4>Deployment Specifications</h4>
            <div class="specs-grid">
              <div class="spec-item">
                <h5>Model Format</h5>
                <p>TensorFlow Lite (.tflite)</p>
              </div>
              <div class="spec-item">
                <h5>Model Size</h5>
                <p>Optimized for mobile deployment</p>
              </div>
              <div class="spec-item">
                <h5>Input Processing</h5>
                <p>224x224 RGB image normalization</p>
              </div>
              <div class="spec-item">
                <h5>Output Format</h5>
                <p>Probability distribution over classes</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="api-integration">
          <i class="bi bi-code-slash"></i>
          API Integration
        </h2>
        <div class="api-integration">
          <div class="integration-methods">
            <h4>Integration Methods</h4>
            <div class="method-grid">
              <div class="method-card">
                <i class="bi bi-phone"></i>
                <h5>On-Device Inference</h5>
                <p>Direct model execution on mobile device</p>
                <ul>
                  <li>No internet required</li>
                  <li>Fast inference speed</li>
                  <li>Privacy-preserving</li>
                </ul>
              </div>
              <div class="method-card">
                <i class="bi bi-cloud"></i>
                <h5>Cloud API</h5>
                <p>Server-side model inference</p>
                <ul>
                  <li>Higher accuracy with larger models</li>
                  <li>Regular model updates</li>
                  <li>Requires internet connection</li>
                </ul>
              </div>
            </div>
          </div>
          
          <div class="api-endpoints">
            <h4>API Endpoints</h4>
            <div class="endpoint-list">
              <div class="endpoint-item">
                <code>POST /api/plants/identify</code>
                <span>Upload image for plant identification</span>
              </div>
              <div class="endpoint-item">
                <code>GET /api/plants/suggestions</code>
                <span>Get plant suggestions based on location</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="mobile-integration">
          <i class="bi bi-phone"></i>
          Mobile Integration
        </h2>
        <div class="mobile-integration">
          <div class="flutter-integration">
            <h4>Flutter Integration</h4>
            <div class="integration-steps">
              <div class="integration-step">
                <h5>1. Add Dependencies</h5>
                <code>tflite_flutter: ^0.9.0</code>
              </div>
              <div class="integration-step">
                <h5>2. Load Model</h5>
                <code>final interpreter = await tflite.Interpreter.fromAsset('plant_classifier_mobile.tflite');</code>
              </div>
              <div class="integration-step">
                <h5>3. Preprocess Image</h5>
                <code>final input = preprocessImage(image, 224, 224);</code>
              </div>
              <div class="integration-step">
                <h5>4. Run Inference</h5>
                <code>interpreter.run(input, output);</code>
              </div>
            </div>
          </div>
          
          <div class="performance-optimization">
            <h4>Performance Optimization</h4>
            <div class="optimization-list">
              <div class="opt-item">
                <i class="bi bi-lightning"></i>
                <span>Model quantization for reduced size</span>
              </div>
              <div class="opt-item">
                <i class="bi bi-cpu"></i>
                <span>GPU acceleration where available</span>
              </div>
              <div class="opt-item">
                <i class="bi bi-memory"></i>
                <span>Memory-efficient inference</span>
              </div>
              <div class="opt-item">
                <i class="bi bi-battery-charging"></i>
                <span>Battery-optimized processing</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="model-updates">
          <i class="bi bi-arrow-clockwise"></i>
          Model Updates
        </h2>
        <div class="model-updates">
          <div class="update-strategy">
            <h4>Update Strategy</h4>
            <div class="strategy-grid">
              <div class="strategy-item">
                <i class="bi bi-cloud-download"></i>
                <h5>Over-the-Air Updates</h5>
                <p>Download new model versions automatically</p>
              </div>
              <div class="strategy-item">
                <i class="bi bi-version"></i>
                <h5>Version Management</h5>
                <p>Track model versions and rollback capability</p>
              </div>
              <div class="strategy-item">
                <i class="bi bi-graph-up"></i>
                <h5>Performance Monitoring</h5>
                <p>Monitor model performance in production</p>
              </div>
            </div>
          </div>
          
          <div class="update-process">
            <h4>Update Process</h4>
            <div class="process-steps">
              <div class="process-step">
                <h5>1. Model Training</h5>
                <p>Retrain with new data and improved architecture</p>
              </div>
              <div class="process-step">
                <h5>2. Validation</h5>
                <p>Test on validation set and compare performance</p>
              </div>
              <div class="process-step">
                <h5>3. Deployment</h5>
                <p>Deploy to staging and gradually roll out</p>
              </div>
              <div class="process-step">
                <h5>4. Monitoring</h5>
                <p>Monitor performance and user feedback</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="data-privacy">
          <i class="bi bi-shield-lock"></i>
          Data Privacy
        </h2>
        <div class="data-privacy">
          <div class="privacy-features">
            <h4>Privacy Features</h4>
            <div class="privacy-grid">
              <div class="privacy-item">
                <i class="bi bi-phone"></i>
                <h5>On-Device Processing</h5>
                <p>Images processed locally, never uploaded</p>
              </div>
              <div class="privacy-item">
                <i class="bi bi-eye-slash"></i>
                <h5>No Image Storage</h5>
                <p>Images deleted after processing</p>
              </div>
              <div class="privacy-item">
                <i class="bi bi-lock"></i>
                <h5>Secure Transmission</h5>
                <p>Encrypted API communication</p>
              </div>
              <div class="privacy-item">
                <i class="bi bi-person-check"></i>
                <h5>User Consent</h5>
                <p>Explicit permission for data usage</p>
              </div>
            </div>
          </div>
          
          <div class="compliance">
            <h4>Compliance</h4>
            <div class="compliance-list">
              <div class="compliance-item">
                <i class="bi bi-check-circle"></i>
                <span>GDPR compliant data handling</span>
              </div>
              <div class="compliance-item">
                <i class="bi bi-check-circle"></i>
                <span>COPPA compliance for children's data</span>
              </div>
              <div class="compliance-item">
                <i class="bi bi-check-circle"></i>
                <span>Transparent privacy policy</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="future-improvements">
          <i class="bi bi-graph-up"></i>
          Future Improvements
        </h2>
        <div class="future-improvements">
          <div class="improvement-grid">
            <div class="improvement-item">
              <div class="improvement-icon">
                <i class="bi bi-brain"></i>
              </div>
              <div class="improvement-content">
                <h5>Advanced Architectures</h5>
                <ul>
                  <li>Vision Transformer (ViT) integration</li>
                  <li>EfficientNetV2 for better accuracy</li>
                  <li>Ensemble methods for improved performance</li>
                  <li>Few-shot learning capabilities</li>
                </ul>
              </div>
            </div>
            
            <div class="improvement-item">
              <div class="improvement-icon">
                <i class="bi bi-globe"></i>
              </div>
              <div class="improvement-content">
                <h5>Geographic Expansion</h5>
                <ul>
                  <li>Region-specific plant databases</li>
                  <li>Local flora identification</li>
                  <li>Seasonal plant recognition</li>
                  <li>Endemic species support</li>
                </ul>
              </div>
            </div>
            
            <div class="improvement-item">
              <div class="improvement-icon">
                <i class="bi bi-camera"></i>
              </div>
              <div class="improvement-content">
                <h5>Enhanced Features</h5>
                <ul>
                  <li>Plant health assessment</li>
                  <li>Disease detection</li>
                  <li>Growth stage identification</li>
                  <li>Care recommendations</li>
                </ul>
              </div>
            </div>
            
            <div class="improvement-item">
              <div class="improvement-icon">
                <i class="bi bi-people"></i>
              </div>
              <div class="improvement-content">
                <h5>Community Features</h5>
                <ul>
                  <li>User-contributed plant data</li>
                  <li>Expert verification system</li>
                  <li>Plant identification challenges</li>
                  <li>Knowledge sharing platform</li>
                </ul>
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
                <h5>Low Accuracy Predictions</h5>
                <p><strong>Problem:</strong> Model returns low confidence predictions</p>
                <p><strong>Solution:</strong> Check image quality, lighting, and angle</p>
              </div>
              <div class="issue-item">
                <h5>Slow Inference</h5>
                <p><strong>Problem:</strong> Model takes too long to process</p>
                <p><strong>Solution:</strong> Optimize image size and model quantization</p>
              </div>
              <div class="issue-item">
                <h5>Model Loading Errors</h5>
                <p><strong>Problem:</strong> TensorFlow Lite model fails to load</p>
                <p><strong>Solution:</strong> Verify model file integrity and format</p>
              </div>
              <div class="issue-item">
                <h5>Memory Issues</h5>
                <p><strong>Problem:</strong> App crashes due to memory overflow</p>
                <p><strong>Solution:</strong> Implement proper memory management</p>
              </div>
            </div>
          </div>
          
          <div class="debug-tools">
            <h4>Debug Tools</h4>
            <div class="tools-grid">
              <div class="tool-item">
                <h5>Model Profiler</h5>
                <p>Analyze model performance and bottlenecks</p>
              </div>
              <div class="tool-item">
                <h5>Accuracy Monitor</h5>
                <p>Track prediction accuracy in production</p>
              </div>
              <div class="tool-item">
                <h5>Error Logging</h5>
                <p>Log and analyze prediction errors</p>
              </div>
              <div class="tool-item">
                <h5>Performance Metrics</h5>
                <p>Monitor inference time and resource usage</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="doc-section">
        <h2 id="contributing">
          <i class="bi bi-people"></i>
          Contributing to ML
        </h2>
        <div class="contributing-guide">
          <div class="contribution-areas">
            <h4>Contribution Areas</h4>
            <div class="areas-grid">
              <div class="area-item">
                <i class="bi bi-database"></i>
                <h5>Dataset Enhancement</h5>
                <p>Add new plant species and improve data quality</p>
              </div>
              <div class="area-item">
                <i class="bi bi-cpu"></i>
                <h5>Model Optimization</h5>
                <p>Improve model architecture and performance</p>
              </div>
              <div class="area-item">
                <i class="bi bi-code-slash"></i>
                <h5>API Development</h5>
                <p>Enhance API endpoints and integration</p>
              </div>
              <div class="area-item">
                <i class="bi bi-phone"></i>
                <h5>Mobile Integration</h5>
                <p>Optimize mobile app performance</p>
              </div>
            </div>
          </div>
          
          <div class="development-setup">
            <h4>Development Setup</h4>
            <div class="setup-steps">
              <div class="setup-step">
                <h5>1. Environment Setup</h5>
                <code>pip install tensorflow keras numpy matplotlib</code>
              </div>
              <div class="setup-step">
                <h5>2. Dataset Preparation</h5>
                <p>Organize plant images in class folders</p>
              </div>
              <div class="setup-step">
                <h5>3. Model Training</h5>
                <code>python train_plant_model.py</code>
              </div>
              <div class="setup-step">
                <h5>4. Model Conversion</h5>
                <code>python convert_to_tflite.py</code>
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
.ml-docs {
  max-width: 100%;
  padding: 0 2rem;
}

.page-header {
  text-align: center;
  margin-bottom: 3rem;
  padding: 3rem 2rem;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
  border-radius: 20px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  backdrop-filter: blur(10px);
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

.page-header h1 {
  font-size: 2.5rem;
  font-weight: 800;
  color: #1a1a1a;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.lead-text {
  font-size: 1.25rem;
  color: #4a5568;
  line-height: 1.6;
  max-width: 700px;
  margin: 0 auto;
}

.doc-section {
  margin-bottom: 3rem;
  padding: 2.5rem;
  background: rgba(255, 255, 255, 0.7);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
}

.doc-section:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 40px rgba(102, 126, 234, 0.15);
}

.doc-section h2 {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid rgba(102, 126, 234, 0.1);
}

.doc-section h2 i {
  color: #667eea;
  font-size: 1.5rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 16px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.08);
}

.feature-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
  border-color: rgba(102, 126, 234, 0.2);
}

.feature-item i {
  color: #667eea;
  font-size: 1.5rem;
  flex-shrink: 0;
}

.architecture-details {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2.5rem;
}

.model-card {
  padding: 2.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  text-align: center;
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
}

.model-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(102, 126, 234, 0.15);
}

.model-icon {
  width: 100px;
  height: 100px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 2rem auto;
  color: white;
  font-size: 2.5rem;
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
}

.model-card h3 {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.model-specs {
  margin-top: 2rem;
  text-align: left;
}

.spec-item {
  margin-bottom: 0.75rem;
  color: #4a5568;
  padding: 0.5rem 0;
  border-bottom: 1px solid rgba(102, 126, 234, 0.1);
}

.spec-item:last-child {
  border-bottom: none;
}

.architecture-flow {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  padding: 2.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
}

.flow-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

.flow-step {
  text-align: center;
  padding: 2rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 16px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.08);
}

.flow-step:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
  background: rgba(102, 126, 234, 0.08);
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
  font-size: 1.2rem;
  margin: 0 auto 1.5rem auto;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
}

.flow-step h5 {
  font-size: 1.2rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.flow-step p {
  color: #4a5568;
  font-size: 0.95rem;
  line-height: 1.5;
}

.info-box {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border: 1px solid rgba(102, 126, 234, 0.1);
  border-radius: 12px;
  margin-bottom: 2rem;
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
}

.dataset-stats, .data-augmentation {
  margin-bottom: 2rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.stat-item {
  text-align: center;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.stat-item i {
  color: #667eea;
  font-size: 2rem;
  margin-bottom: 1rem;
}

.stat-item h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.stat-item p {
  color: #4a5568;
  font-size: 0.9rem;
}

.augmentation-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.aug-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.aug-item i {
  color: #667eea;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.metrics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 2.5rem;
}

.metric-card {
  text-align: center;
  padding: 2.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
}

.metric-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 48px rgba(102, 126, 234, 0.2);
  border-color: rgba(102, 126, 234, 0.2);
}

.metric-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem auto;
  color: white;
  font-size: 2rem;
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
}

.metric-card h4 {
  font-size: 1.2rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.metric-value {
  font-size: 2.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.75rem;
}

.metric-card p {
  color: #4a5568;
  font-size: 0.95rem;
  line-height: 1.5;
}

.training-progress {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.progress-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.progress-item {
  padding: 1rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.progress-item h5 {
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.progress-item p {
  color: #4a5568;
  font-size: 0.9rem;
}

.deployment-steps {
  margin-bottom: 2rem;
}

.step-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.deployment-step {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
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
  flex-shrink: 0;
}

.step-content h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.step-content p {
  color: #4a5568;
  margin-bottom: 0.75rem;
}

.step-content code {
  background: rgba(102, 126, 234, 0.1);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-family: 'Fira Mono', monospace;
  font-size: 0.9rem;
  color: #667eea;
}

.deployment-specs {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.specs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.spec-item {
  padding: 1rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.spec-item h5 {
  font-size: 1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.spec-item p {
  color: #4a5568;
  font-size: 0.9rem;
}

.integration-methods {
  margin-bottom: 2rem;
}

.method-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.method-card {
  padding: 2rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 16px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  text-align: center;
}

.method-card i {
  color: #667eea;
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.method-card h5 {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 1rem;
}

.method-card p {
  color: #4a5568;
  margin-bottom: 1.5rem;
}

.method-card ul {
  text-align: left;
  list-style: none;
  padding: 0;
}

.method-card li {
  padding: 0.5rem 0;
  color: #4a5568;
  border-bottom: 1px solid rgba(102, 126, 234, 0.1);
}

.method-card li:last-child {
  border-bottom: none;
}

.method-card li:before {
  content: "✓";
  color: #667eea;
  font-weight: bold;
  margin-right: 0.5rem;
}

.api-endpoints {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.endpoint-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 1rem;
}

.endpoint-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.endpoint-item code {
  background: rgba(102, 126, 234, 0.1);
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-family: 'Fira Mono', monospace;
  font-size: 0.9rem;
  color: #667eea;
  font-weight: 600;
}

.endpoint-item span {
  color: #4a5568;
  font-size: 0.9rem;
}

.flutter-integration {
  margin-bottom: 2rem;
}

.integration-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.integration-step {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.integration-step h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.integration-step code {
  background: rgba(102, 126, 234, 0.1);
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-family: 'Fira Mono', monospace;
  font-size: 0.9rem;
  color: #667eea;
  font-weight: 600;
  display: block;
  margin-top: 0.5rem;
}

.mobile-features {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.features-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.feature-item i {
  color: #667eea;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.feature-item span {
  color: #4a5568;
  font-size: 0.9rem;
}

.model-updates {
  margin-bottom: 2rem;
}

.update-strategy {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.update-methods {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.update-method {
  padding: 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.update-method h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.update-method p {
  color: #4a5568;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.update-method ul {
  list-style: none;
  padding: 0;
}

.update-method li {
  padding: 0.25rem 0;
  color: #4a5568;
  font-size: 0.9rem;
}

.update-method li:before {
  content: "•";
  color: #667eea;
  font-weight: bold;
  margin-right: 0.5rem;
}

.data-privacy {
  margin-bottom: 2rem;
}

.privacy-features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.privacy-card {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
  text-align: center;
}

.privacy-card i {
  color: #667eea;
  font-size: 2rem;
  margin-bottom: 1rem;
}

.privacy-card h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.privacy-card p {
  color: #4a5568;
  font-size: 0.9rem;
}

.future-improvements {
  margin-bottom: 2rem;
}

.improvement-roadmap {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.improvement-item {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.improvement-item h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.improvement-item ul {
  list-style: none;
  padding: 0;
}

.improvement-item li {
  padding: 0.25rem 0;
  color: #4a5568;
  font-size: 0.9rem;
}

.improvement-item li:before {
  content: "→";
  color: #667eea;
  font-weight: bold;
  margin-right: 0.5rem;
}

.troubleshooting {
  margin-bottom: 2rem;
}

.troubleshooting-guide {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.issue-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.issue-item {
  padding: 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.issue-item h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.issue-item p {
  color: #4a5568;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.issue-item code {
  background: rgba(102, 126, 234, 0.1);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-family: 'Fira Mono', monospace;
  font-size: 0.85rem;
  color: #667eea;
}

.contributing {
  margin-bottom: 2rem;
}

.contribution-guide {
  background: rgba(255, 255, 255, 0.8);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.contribution-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1rem;
}

.contribution-step {
  padding: 1.5rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.contribution-step h5 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.75rem;
}

.contribution-step p {
  color: #4a5568;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.contribution-step code {
  background: rgba(102, 126, 234, 0.1);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-family: 'Fira Mono', monospace;
  font-size: 0.85rem;
  color: #667eea;
}

/* Responsive Design */
@media (max-width: 768px) {
  .ml-docs {
    padding: 0 1rem;
  }
  
  .page-header {
    padding: 2rem 1rem;
  }
  
  .page-header h1 {
    font-size: 2rem;
  }
  
  .doc-section {
    padding: 1.5rem;
  }
  
  .architecture-details {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .metrics-grid,
  .method-grid,
  .integration-steps,
  .features-grid,
  .flow-steps,
  .stats-grid,
  .augmentation-list,
  .update-methods,
  .privacy-features,
  .improvement-grid,
  .issues-grid,
  .tools-grid,
  .areas-grid,
  .setup-steps {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .metric-card,
  .method-card,
  .integration-step,
  .update-method,
  .privacy-card,
  .improvement-item,
  .issue-item,
  .contribution-step {
    padding: 1.5rem;
  }
  
  .model-card,
  .architecture-flow {
    padding: 1.5rem;
  }
  
  .model-icon {
    width: 80px;
    height: 80px;
    font-size: 2rem;
  }
  
  .metric-icon {
    width: 60px;
    height: 60px;
    font-size: 1.5rem;
  }
}
</style>
