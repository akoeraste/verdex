<template>
  <nav v-if="safePagination.last_page > 1" aria-label="Page navigation">
    <ul class="pagination">
      <li class="page-item" :class="{ disabled: safePagination.current_page === 1 }">
        <a class="page-link" href="#" @click.prevent="changePage(safePagination.current_page - 1)">
          Previous
        </a>
      </li>
      <li v-for="page in pages" :key="page" class="page-item" :class="{ active: page === safePagination.current_page }">
        <a class="page-link" href="#" @click.prevent="changePage(page)">
          {{ page }}
        </a>
      </li>
      <li class="page-item" :class="{ disabled: safePagination.current_page === safePagination.last_page }">
        <a class="page-link" href="#" @click.prevent="changePage(safePagination.current_page + 1)">
          Next
        </a>
      </li>
    </ul>
  </nav>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  pagination: {
    type: Object,
    required: true,
  },
});

const emit = defineEmits(['page-changed']);

const safePagination = computed(() => ({
  current_page: props.pagination.value?.current_page ?? 1,
  last_page: props.pagination.value?.last_page ?? 1,
  per_page: props.pagination.value?.per_page ?? 5,
  total: props.pagination.value?.total ?? 0
}));

const pages = computed(() => {
  const pagesArray = [];
  for (let i = 1; i <= safePagination.value.last_page; i++) {
    pagesArray.push(i);
  }
  return pagesArray;
});

const changePage = (page) => {
  if (page > 0 && page <= safePagination.value.last_page) {
    emit('page-changed', page);
  }
};
</script>

<style scoped>
.pagination {
  display: flex;
  list-style: none;
  padding: 0;
  margin-top: 1rem;
  justify-content: center;
}

.page-item {
  margin: 0 0.25rem;
}

.page-link {
  color: #43e97b;
  padding: 0.5rem 0.75rem;
  border: 1px solid #ddd;
  border-radius: 0.25rem;
  text-decoration: none;
  transition: all 0.2s;
  background: #fff;
}

.page-link:hover {
  background-color: #f0fdf4;
}

.page-item.active .page-link {
  background-color: #43e97b;
  color: white;
  border-color: #43e97b;
}

.page-item.disabled .page-link {
  color: #aaa;
  pointer-events: none;
  background-color: #f8f9fa;
}
</style> 