<template>
  <div class="feedback-admin">
    <!-- Header -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <i class="bi bi-chat-dots me-2"></i>
          Feedback Management
        </h1>
        <p class="page-subtitle">Manage and respond to user feedback</p>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-section mb-4">
      <div class="row">
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon bg-primary">
              <i class="bi bi-chat-dots"></i>
            </div>
            <div class="stat-content">
              <h3>{{ stats.total }}</h3>
              <p>Total Feedback</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon bg-warning">
              <i class="bi bi-clock"></i>
            </div>
            <div class="stat-content">
              <h3>{{ stats.pending }}</h3>
              <p>Pending Response</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon bg-success">
              <i class="bi bi-check-circle"></i>
            </div>
            <div class="stat-content">
              <h3>{{ stats.responded }}</h3>
              <p>Responded</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card">
            <div class="stat-icon bg-info">
              <i class="bi bi-star"></i>
            </div>
            <div class="stat-content">
              <h3>{{ stats.average_rating }}/5</h3>
              <p>Average Rating</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters-section mb-4">
      <div class="card">
        <div class="card-body">
          <div class="row">
            <div class="col-md-3">
              <label class="form-label">Status</label>
              <select v-model="filters.status" class="form-select" @change="loadFeedback">
                <option value="">All</option>
                <option value="pending">Pending</option>
                <option value="responded">Responded</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">Category</label>
              <select v-model="filters.category" class="form-select" @change="loadFeedback">
                <option value="">All Categories</option>
                <option value="general_feedback">General Feedback</option>
                <option value="bug_report">Bug Report</option>
                <option value="feature_request">Feature Request</option>
                <option value="plant_identification">Plant Identification</option>
                <option value="user_interface">User Interface</option>
                <option value="performance">Performance</option>
                <option value="other">Other</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">Rating</label>
              <select v-model="filters.rating" class="form-select" @change="loadFeedback">
                <option value="">All Ratings</option>
                <option value="1">1 - Poor</option>
                <option value="2">2 - Fair</option>
                <option value="3">3 - Good</option>
                <option value="4">4 - Very Good</option>
                <option value="5">5 - Excellent</option>
              </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
              <button @click="clearFilters" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-clockwise me-1"></i>
                Clear Filters
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Feedback List -->
    <div class="feedback-list">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Feedback List</h5>
          <div class="d-flex gap-2">
            <button @click="loadFeedback" class="btn btn-outline-primary btn-sm" :disabled="loading">
              <i class="bi bi-arrow-clockwise me-1"></i>
              Refresh
            </button>
          </div>
        </div>
        <div class="card-body p-0">
          <div v-if="loading" class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>
          </div>
          
          <div v-else-if="feedback.length === 0" class="text-center py-4">
            <i class="bi bi-chat-dots text-muted" style="font-size: 3rem;"></i>
            <p class="text-muted mt-2">No feedback found</p>
          </div>
          
          <div v-else class="feedback-items">
            <div v-for="item in feedback" :key="item.id" class="feedback-item">
              <div class="feedback-header">
                <div class="feedback-meta">
                  <div class="user-info">
                    <span class="user-name">{{ item.user?.name || 'Anonymous' }}</span>
                    <span class="user-email" v-if="item.user?.email">({{ item.user.email }})</span>
                  </div>
                  <div class="feedback-details">
                    <span class="category badge bg-secondary">{{ formatCategory(item.category) }}</span>
                    <span class="rating">
                      <i v-for="n in 5" :key="n" 
                         :class="n <= item.rating ? 'bi bi-star-fill text-warning' : 'bi bi-star text-muted'"></i>
                      <span class="rating-text ms-1">({{ item.rating_text }})</span>
                    </span>
                    <span class="status" :class="item.is_responded ? 'badge bg-success' : 'badge bg-warning'">
                      {{ item.is_responded ? 'Responded' : 'Pending' }}
                    </span>
                  </div>
                  <div class="feedback-date">
                    <i class="bi bi-clock me-1"></i>
                    {{ item.formatted_created_at }}
                  </div>
                </div>
                <div class="feedback-actions">
                  <button @click="viewFeedback(item)" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-eye me-1"></i>
                    View
                  </button>
                  <button v-if="!item.is_responded" @click="respondToFeedback(item)" class="btn btn-sm btn-success">
                    <i class="bi bi-reply me-1"></i>
                    Respond
                  </button>
                </div>
              </div>
              
              <div class="feedback-content">
                <div class="message">
                  <strong>Message:</strong>
                  <p>{{ item.message }}</p>
                </div>
                <div v-if="item.contact" class="contact">
                  <strong>Contact:</strong> {{ item.contact }}
                </div>
                <div v-if="item.comment" class="response">
                  <strong>Response:</strong>
                  <p>{{ item.comment }}</p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Pagination -->
          <div v-if="pagination.last_page > 1" class="pagination-wrapper p-3">
            <nav>
              <ul class="pagination justify-content-center mb-0">
                <li class="page-item" :class="{ disabled: pagination.current_page === 1 }">
                  <a class="page-link" href="#" @click.prevent="changePage(pagination.current_page - 1)">
                    Previous
                  </a>
                </li>
                <li v-for="page in paginationPages" :key="page" 
                    class="page-item" :class="{ active: page === pagination.current_page }">
                  <a class="page-link" href="#" @click.prevent="changePage(page)">{{ page }}</a>
                </li>
                <li class="page-item" :class="{ disabled: pagination.current_page === pagination.last_page }">
                  <a class="page-link" href="#" @click.prevent="changePage(pagination.current_page + 1)">
                    Next
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- View Feedback Modal -->
    <div class="modal fade" id="viewFeedbackModal" tabindex="-1">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Feedback Details</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body" v-if="selectedFeedback">
            <div class="feedback-detail">
              <div class="row">
                <div class="col-md-6">
                  <h6>User Information</h6>
                  <p><strong>Name:</strong> {{ selectedFeedback.user?.name || 'Anonymous' }}</p>
                  <p v-if="selectedFeedback.user?.email"><strong>Email:</strong> {{ selectedFeedback.user.email }}</p>
                  <p v-if="selectedFeedback.contact"><strong>Contact:</strong> {{ selectedFeedback.contact }}</p>
                </div>
                <div class="col-md-6">
                  <h6>Feedback Information</h6>
                  <p><strong>Category:</strong> {{ formatCategory(selectedFeedback.category) }}</p>
                  <p><strong>Rating:</strong> 
                    <span v-for="n in 5" :key="n" 
                          :class="n <= selectedFeedback.rating ? 'bi bi-star-fill text-warning' : 'bi bi-star text-muted'"></span>
                    ({{ selectedFeedback.rating_text }})
                  </p>
                  <p><strong>Date:</strong> {{ selectedFeedback.formatted_created_at }}</p>
                </div>
              </div>
              
              <div class="mt-3">
                <h6>Message</h6>
                <div class="message-content p-3 bg-light rounded">
                  {{ selectedFeedback.message }}
                </div>
              </div>
              
              <div v-if="selectedFeedback.comment" class="mt-3">
                <h6>Response</h6>
                <div class="response-content p-3 bg-success bg-opacity-10 rounded">
                  {{ selectedFeedback.comment }}
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button v-if="!selectedFeedback?.is_responded" 
                    @click="respondToFeedback(selectedFeedback)" 
                    class="btn btn-success">
              <i class="bi bi-reply me-1"></i>
              Respond
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Respond Modal -->
    <div class="modal fade" id="respondModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Respond to Feedback</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div v-if="feedbackToRespond" class="feedback-summary mb-3">
              <h6>Original Feedback:</h6>
              <p class="text-muted">{{ feedbackToRespond.message }}</p>
            </div>
            
            <div class="form-group">
              <label class="form-label">Your Response</label>
              <textarea v-model="responseText" 
                        class="form-control" 
                        rows="5" 
                        placeholder="Enter your response to this feedback..."></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button @click="submitResponse" 
                    class="btn btn-success" 
                    :disabled="!responseText.trim() || submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-1"></span>
              Submit Response
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import { Modal } from 'bootstrap';

// Reactive data
const loading = ref(false);
const submitting = ref(false);
const feedback = ref([]);
const stats = ref({
  total: 0,
  pending: 0,
  responded: 0,
  average_rating: 0
});
const pagination = ref({});
const filters = ref({
  status: '',
  category: '',
  rating: ''
});
const selectedFeedback = ref(null);
const feedbackToRespond = ref(null);
const responseText = ref('');

// Computed
const paginationPages = computed(() => {
  if (!pagination.value.last_page) return [];
  const pages = [];
  const current = pagination.value.current_page;
  const last = pagination.value.last_page;
  
  for (let i = Math.max(1, current - 2); i <= Math.min(last, current + 2); i++) {
    pages.push(i);
  }
  return pages;
});

// Methods
const loadFeedback = async (page = 1) => {
  loading.value = true;
  try {
    const params = { page, ...filters.value };
    const response = await axios.get('/api/feedback', { params });
    feedback.value = response.data.data;
    pagination.value = response.data.meta;
  } catch (error) {
    console.error('Error loading feedback:', error);
  } finally {
    loading.value = false;
  }
};

const loadStats = async () => {
  try {
    const response = await axios.get('/api/feedback-stats');
    stats.value = response.data;
  } catch (error) {
    console.error('Error loading stats:', error);
  }
};

const changePage = (page) => {
  if (page >= 1 && page <= pagination.value.last_page) {
    loadFeedback(page);
  }
};

const clearFilters = () => {
  filters.value = {
    status: '',
    category: '',
    rating: ''
  };
  loadFeedback();
};

const formatCategory = (category) => {
  const categories = {
    'general_feedback': 'General Feedback',
    'bug_report': 'Bug Report',
    'feature_request': 'Feature Request',
    'plant_identification': 'Plant Identification',
    'user_interface': 'User Interface',
    'performance': 'Performance',
    'other': 'Other'
  };
  return categories[category] || category;
};

const viewFeedback = (item) => {
  selectedFeedback.value = item;
  const modal = new Modal(document.getElementById('viewFeedbackModal'));
  modal.show();
};

const respondToFeedback = (item) => {
  feedbackToRespond.value = item;
  responseText.value = '';
  const modal = new Modal(document.getElementById('respondModal'));
  modal.show();
};

const submitResponse = async () => {
  if (!responseText.value.trim()) return;
  
  submitting.value = true;
  try {
    await axios.put(`/api/feedback/${feedbackToRespond.value.id}/respond`, {
      comment: responseText.value
    });
    
    // Close modal and refresh
    const modal = Modal.getInstance(document.getElementById('respondModal'));
    modal.hide();
    
    await loadFeedback(pagination.value.current_page);
    await loadStats();
    
    // Show success message
    // You can add a toast notification here
  } catch (error) {
    console.error('Error submitting response:', error);
  } finally {
    submitting.value = false;
  }
};

// Lifecycle
onMounted(() => {
  loadFeedback();
  loadStats();
});
</script>

<style scoped>
.feedback-admin {
  padding: 1.5rem;
}

.page-header {
  margin-bottom: 2rem;
}

.page-title {
  font-size: 2rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 0.5rem;
}

.page-subtitle {
  color: #666;
  font-size: 1rem;
}

.stats-section .stat-card {
  background: white;
  border-radius: 0.5rem;
  padding: 1.5rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
  margin-bottom: 1rem;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1rem;
  font-size: 1.5rem;
  color: white;
}

.stat-content h3 {
  font-size: 2rem;
  font-weight: 600;
  margin: 0;
  color: #333;
}

.stat-content p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.feedback-item {
  border-bottom: 1px solid #eee;
  padding: 1.5rem;
}

.feedback-item:last-child {
  border-bottom: none;
}

.feedback-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1rem;
}

.feedback-meta {
  flex: 1;
}

.user-name {
  font-weight: 600;
  color: #333;
}

.user-email {
  color: #666;
  font-size: 0.9rem;
}

.feedback-details {
  margin: 0.5rem 0;
  display: flex;
  gap: 0.5rem;
  align-items: center;
  flex-wrap: wrap;
}

.feedback-date {
  color: #666;
  font-size: 0.9rem;
}

.feedback-actions {
  display: flex;
  gap: 0.5rem;
}

.feedback-content {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 0.5rem;
}

.feedback-content .message,
.feedback-content .contact,
.feedback-content .response {
  margin-bottom: 1rem;
}

.feedback-content .response {
  background: #d4edda;
  padding: 0.75rem;
  border-radius: 0.25rem;
  border-left: 4px solid #28a745;
}

.rating {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.rating-text {
  font-size: 0.9rem;
  color: #666;
}

.pagination-wrapper {
  border-top: 1px solid #eee;
}

@media (max-width: 768px) {
  .feedback-header {
    flex-direction: column;
    gap: 1rem;
  }
  
  .feedback-actions {
    align-self: stretch;
  }
  
  .feedback-actions .btn {
    flex: 1;
  }
}
</style> 