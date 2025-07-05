<template>
  <DocumentationLayout>
    <div>
      <h1 id="overview">🤖 ML Pipeline Documentation</h1>
      <p class="doc-intro">The Verdex Machine Learning Pipeline is a comprehensive system for plant identification using TensorFlow Lite. This guide covers model architecture, training, deployment, and integration with the mobile application.</p>
      
      <div class="ml-stats">
        <div class="stat-card">
          <i class="bi bi-cpu"></i>
          <h3>30 Plant Classes</h3>
          <p>Comprehensive plant identification</p>
        </div>
        <div class="stat-card">
          <i class="bi bi-speedometer2"></i>
          <h3>&lt;500ms Inference</h3>
          <p>Real-time on-device processing</p>
        </div>
        <div class="stat-card">
          <i class="bi bi-check-circle"></i>
          <h3>&gt;80% Accuracy</h3>
          <p>High precision identification</p>
        </div>
        <div class="stat-card">
          <i class="bi bi-phone"></i>
          <h3>On-Device</h3>
          <p>No internet required for inference</p>
        </div>
      </div>

      <h2 id="architecture">🏗️ Model Architecture</h2>
      <div class="architecture-overview">
        <div class="arch-diagram">
          <div class="arch-stage">
            <h4>Input Processing</h4>
            <div class="stage-components">
              <div class="component">Image Capture</div>
              <div class="component">Preprocessing</div>
              <div class="component">Resize (224x224)</div>
            </div>
          </div>
          <div class="arch-arrow">→</div>
          <div class="arch-stage">
            <h4>Feature Extraction</h4>
            <div class="stage-components">
              <div class="component">MobileNetV3</div>
              <div class="component">Convolutional Layers</div>
              <div class="component">Feature Maps</div>
            </div>
          </div>
          <div class="arch-arrow">→</div>
          <div class="arch-stage">
            <h4>Classification</h4>
            <div class="stage-components">
              <div class="component">Global Pooling</div>
              <div class="component">Dense Layers</div>
              <div class="component">Softmax Output</div>
            </div>
          </div>
        </div>
      </div>

      <h2 id="model-specs">📊 Model Specifications</h2>
      <div class="specs-grid">
        <div class="spec-card">
          <h4>Model Details</h4>
          <div class="spec-item">
            <span class="spec-label">Base Model:</span>
            <span class="spec-value">MobileNetV3-Small</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">Input Size:</span>
            <span class="spec-value">224x224x3</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">Output Classes:</span>
            <span class="spec-value">30</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">Model Size:</span>
            <span class="spec-value">~8MB</span>
          </div>
        </div>
        
        <div class="spec-card">
          <h4>Performance Metrics</h4>
          <div class="spec-item">
            <span class="spec-label">Accuracy:</span>
            <span class="spec-value">82.5%</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">Inference Time:</span>
            <span class="spec-value">&lt;500ms</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">Memory Usage:</span>
            <span class="spec-value">~50MB</span>
          </div>
          <div class="spec-item">
            <span class="spec-label">FPS:</span>
            <span class="spec-value">2-3</span>
          </div>
        </div>
      </div>

      <h2 id="training">🎯 Training Pipeline</h2>
      <div class="training-pipeline">
        <div class="pipeline-step">
          <div class="step-number">1</div>
          <div class="step-content">
            <h4>Data Collection</h4>
            <p>Gather plant images from various sources including botanical databases, field photography, and user submissions.</p>
            <ul>
              <li>30 plant species</li>
              <li>500+ images per class</li>
              <li>Diverse lighting conditions</li>
              <li>Multiple angles and stages</li>
            </ul>
          </div>
        </div>
        
        <div class="pipeline-step">
          <div class="step-number">2</div>
          <div class="step-content">
            <h4>Data Preprocessing</h4>
            <p>Clean and prepare the dataset for training with augmentation and normalization.</p>
            <ul>
              <li>Image resizing to 224x224</li>
              <li>Data augmentation (rotation, flip, zoom)</li>
              <li>Normalization (0-1 range)</li>
              <li>Train/validation split (80/20)</li>
            </ul>
          </div>
        </div>
        
        <div class="pipeline-step">
          <div class="step-number">3</div>
          <div class="step-content">
            <h4>Model Training</h4>
            <p>Train the MobileNetV3 model with transfer learning and fine-tuning techniques.</p>
            <ul>
              <li>Transfer learning from ImageNet</li>
              <li>Fine-tuning on plant dataset</li>
              <li>Learning rate scheduling</li>
              <li>Early stopping and checkpointing</li>
            </ul>
          </div>
        </div>
        
        <div class="pipeline-step">
          <div class="step-number">4</div>
          <div class="step-content">
            <h4>Model Optimization</h4>
            <p>Convert and optimize the model for mobile deployment using TensorFlow Lite.</p>
            <ul>
              <li>Quantization (INT8)</li>
              <li>Model compression</li>
              <li>Pruning techniques</li>
              <li>Performance validation</li>
            </ul>
          </div>
        </div>
      </div>

      <h2 id="deployment">📱 Mobile Deployment</h2>
      <div class="deployment-section">
        <div class="deployment-card">
          <h4>Flutter Integration</h4>
          <div class="code-block">
            <h5>Model Loading</h5>
            <pre><code>import 'package:tflite_flutter/tflite_flutter.dart';

class PlantClassifierService {
  late Interpreter _interpreter;
  
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/model/plant_classifier_mobile.tflite'
    );
  }
}</code></pre>
          </div>
        </div>
        
        <div class="deployment-card">
          <h4>Inference Process</h4>
          <div class="code-block">
            <h5>Image Classification</h5>
            <pre><code>Future<Map<String, double>> classifyImage(
  Uint8List imageBytes
) async {
  // Preprocess image
  var input = preprocessImage(imageBytes);
  
  // Run inference
  var output = List.filled(30, 0.0);
  _interpreter.run(input, output);
  
  // Post-process results
  return processResults(output);
}</code></pre>
          </div>
        </div>
      </div>

      <h2 id="plant-classes">🌿 Plant Classes</h2>
      <div class="plant-classes">
        <div class="class-category">
          <h4>Common Garden Plants</h4>
          <div class="class-grid">
            <div class="plant-class">Rose</div>
            <div class="plant-class">Tulip</div>
            <div class="plant-class">Sunflower</div>
            <div class="plant-class">Daisy</div>
            <div class="plant-class">Lily</div>
            <div class="plant-class">Orchid</div>
          </div>
        </div>
        
        <div class="class-category">
          <h4>Herbs & Vegetables</h4>
          <div class="class-grid">
            <div class="plant-class">Basil</div>
            <div class="plant-class">Mint</div>
            <div class="plant-class">Tomato</div>
            <div class="plant-class">Pepper</div>
            <div class="plant-class">Lettuce</div>
            <div class="plant-class">Carrot</div>
          </div>
        </div>
        
        <div class="class-category">
          <h4>Fruit Trees</h4>
          <div class="class-grid">
            <div class="plant-class">Apple</div>
            <div class="plant-class">Orange</div>
            <div class="plant-class">Lemon</div>
            <div class="plant-class">Banana</div>
            <div class="plant-class">Mango</div>
            <div class="plant-class">Strawberry</div>
          </div>
        </div>
        
        <div class="class-category">
          <h4>Indoor Plants</h4>
          <div class="class-grid">
            <div class="plant-class">Snake Plant</div>
            <div class="plant-class">Peace Lily</div>
            <div class="plant-class">Pothos</div>
            <div class="plant-class">Fiddle Leaf</div>
            <div class="plant-class">ZZ Plant</div>
            <div class="plant-class">Monstera</div>
          </div>
        </div>
      </div>

      <h2 id="performance">📈 Performance Optimization</h2>
      <div class="performance-section">
        <div class="perf-card">
          <i class="bi bi-speedometer2"></i>
          <h4>Speed Optimization</h4>
          <ul>
            <li>Model quantization (INT8)</li>
            <li>GPU acceleration</li>
            <li>Batch processing</li>
            <li>Memory pooling</li>
          </ul>
        </div>
        
        <div class="perf-card">
          <i class="bi bi-battery-charging"></i>
          <h4>Battery Optimization</h4>
          <ul>
            <li>Efficient inference</li>
            <li>Background processing</li>
            <li>Power-aware scheduling</li>
            <li>Minimal CPU usage</li>
          </ul>
        </div>
        
        <div class="perf-card">
          <i class="bi bi-phone"></i>
          <h4>Memory Optimization</h4>
          <ul>
            <li>Model compression</li>
            <li>Memory-efficient tensors</li>
            <li>Garbage collection</li>
            <li>Resource pooling</li>
          </ul>
        </div>
      </div>

      <h2 id="testing">🧪 Model Testing</h2>
      <div class="testing-section">
        <div class="test-metrics">
          <div class="metric-card">
            <h4>Accuracy Testing</h4>
            <div class="metric-value">82.5%</div>
            <p>Overall classification accuracy on test set</p>
          </div>
          
          <div class="metric-card">
            <h4>Precision</h4>
            <div class="metric-value">85.2%</div>
            <p>True positive rate across all classes</p>
          </div>
          
          <div class="metric-card">
            <h4>Recall</h4>
            <div class="metric-value">79.8%</div>
            <p>Sensitivity for plant identification</p>
          </div>
          
          <div class="metric-card">
            <h4>F1-Score</h4>
            <div class="metric-value">82.4%</div>
            <p>Harmonic mean of precision and recall</p>
          </div>
        </div>
      </div>

      <h2 id="future">🔮 Future Enhancements</h2>
      <div class="future-section">
        <div class="enhancement-card">
          <i class="bi bi-plus-circle"></i>
          <h4>Extended Plant Database</h4>
          <p>Expand to 100+ plant species with regional variations</p>
        </div>
        
        <div class="enhancement-card">
          <i class="bi bi-camera"></i>
          <h4>Real-time Video Analysis</h4>
          <p>Continuous plant identification from video streams</p>
        </div>
        
        <div class="enhancement-card">
          <i class="bi bi-geo-alt"></i>
          <h4>Location-based Filtering</h4>
          <p>Filter results based on geographic location</p>
        </div>
        
        <div class="enhancement-card">
          <i class="bi bi-lightbulb"></i>
          <h4>Disease Detection</h4>
          <p>Identify plant diseases and health issues</p>
        </div>
      </div>
    </div>
  </DocumentationLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import DocumentationLayout from './DocumentationLayout.vue';

// Define sidebar sections for search functionality
const sidebarSections = [
  {
    id: 'overview',
    title: 'Overview',
    items: [
      { id: 'overview', label: 'ML Pipeline Overview' },
      { id: 'architecture', label: 'Model Architecture' },
      { id: 'model-specs', label: 'Model Specifications' }
    ]
  },
  {
    id: 'development',
    title: 'Development',
    items: [
      { id: 'training', label: 'Training Pipeline' },
      { id: 'deployment', label: 'Mobile Deployment' }
    ]
  },
  {
    id: 'data',
    title: 'Data & Classes',
    items: [
      { id: 'plant-classes', label: 'Plant Classes' },
      { id: 'performance', label: 'Performance Optimization' }
    ]
  },
  {
    id: 'evaluation',
    title: 'Evaluation',
    items: [
      { id: 'testing', label: 'Model Testing' },
      { id: 'future', label: 'Future Enhancements' }
    ]
  }
];

onMounted(() => {
  // Set sidebar sections for this page
  if (window.$router) {
    window.$router.currentRoute.value.meta.sidebarSections = sidebarSections;
  }
});
</script>

<style scoped>
.doc-intro {
  font-size: 1.1rem;
  color: #4a4e69;
  line-height: 1.6;
  margin-bottom: 2rem;
}

.ml-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
  transition: transform 0.2s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-card i {
  font-size: 2rem;
  color: #43e97b;
  margin-bottom: 1rem;
}

.stat-card h3 {
  font-size: 1.2rem;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 0.5rem;
}

.stat-card p {
  color: #4a4e69;
  font-size: 0.9rem;
}

.architecture-overview {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
  margin: 2rem 0;
}

.arch-diagram {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.arch-stage {
  text-align: center;
  min-width: 200px;
}

.arch-stage h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.stage-components {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.component {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  padding: 0.6rem 1rem;
  border-radius: 0.5rem;
  font-size: 0.9rem;
  font-weight: 500;
}

.arch-arrow {
  font-size: 1.5rem;
  color: #43e97b;
  font-weight: bold;
}

.specs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin: 2rem 0;
}

.spec-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.spec-card h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.spec-item {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #e2e8f0;
}

.spec-item:last-child {
  border-bottom: none;
}

.spec-label {
  color: #4a4e69;
  font-weight: 500;
}

.spec-value {
  color: #2e7d32;
  font-weight: 600;
}

.training-pipeline {
  display: grid;
  gap: 1.5rem;
  margin: 2rem 0;
}

.pipeline-step {
  display: flex;
  gap: 1rem;
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.step-number {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 1.1rem;
  flex-shrink: 0;
}

.step-content h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.step-content p {
  color: #4a4e69;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.step-content ul {
  margin: 0;
  padding-left: 1.5rem;
}

.step-content li {
  color: #4a4e69;
  font-size: 0.9rem;
  margin-bottom: 0.3rem;
}

.deployment-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 2rem;
  margin: 2rem 0;
}

.deployment-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.deployment-card h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.code-block h5 {
  color: #4a4e69;
  font-weight: 600;
  margin-bottom: 1rem;
}

pre {
  background: #1a1a1a;
  color: #e2e8f0;
  border-radius: 6px;
  padding: 1rem;
  font-size: 0.9rem;
  overflow-x: auto;
  margin: 0;
}

code {
  font-family: 'Fira Mono', 'Consolas', 'Menlo', monospace;
  color: #43e97b;
}

.plant-classes {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin: 2rem 0;
}

.class-category {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.class-category h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.class-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 0.5rem;
}

.plant-class {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  padding: 0.5rem;
  border-radius: 0.5rem;
  text-align: center;
  font-size: 0.9rem;
  font-weight: 500;
}

.performance-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.perf-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.perf-card i {
  font-size: 2rem;
  color: #43e97b;
  margin-bottom: 1rem;
}

.perf-card h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.perf-card ul {
  text-align: left;
  margin: 0;
  padding-left: 1.5rem;
}

.perf-card li {
  color: #4a4e69;
  font-size: 0.9rem;
  margin-bottom: 0.3rem;
}

.testing-section {
  margin: 2rem 0;
}

.test-metrics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
}

.metric-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
}

.metric-card h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 1rem;
}

.metric-value {
  font-size: 2rem;
  font-weight: 700;
  color: #43e97b;
  margin-bottom: 0.5rem;
}

.metric-card p {
  color: #4a4e69;
  font-size: 0.9rem;
}

.future-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.enhancement-card {
  background: white;
  padding: 1.5rem;
  border-radius: 1rem;
  text-align: center;
  box-shadow: 0 2px 12px rgba(34,34,59,0.05);
  transition: transform 0.2s ease;
}

.enhancement-card:hover {
  transform: translateY(-2px);
}

.enhancement-card i {
  font-size: 2rem;
  color: #43e97b;
  margin-bottom: 1rem;
}

.enhancement-card h4 {
  color: #2e7d32;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.enhancement-card p {
  color: #4a4e69;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .ml-stats {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .arch-diagram {
    flex-direction: column;
  }
  
  .arch-arrow {
    transform: rotate(90deg);
  }
  
  .specs-grid {
    grid-template-columns: 1fr;
  }
  
  .pipeline-step {
    flex-direction: column;
    text-align: center;
  }
  
  .deployment-section {
    grid-template-columns: 1fr;
  }
  
  .plant-classes {
    grid-template-columns: 1fr;
  }
  
  .performance-section {
    grid-template-columns: 1fr;
  }
  
  .test-metrics {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .future-section {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .ml-stats {
    grid-template-columns: 1fr;
  }
  
  .test-metrics {
    grid-template-columns: 1fr;
  }
}
</style> 