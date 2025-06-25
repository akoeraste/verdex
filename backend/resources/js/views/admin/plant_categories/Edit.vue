<template>
  <div class="modern-form-container">
    <div class="modern-form-card">
      <h2 class="modern-form-title">Edit Plant Category</h2>
      <form v-if="plantCategory" @submit.prevent="submitForm" class="modern-form">
        <div class="modern-form-group">
          <label for="name" class="modern-form-label">Name</label>
          <input v-model="name" id="name" type="text" class="modern-form-input">
          <div class="modern-form-error" v-if="errors.name">{{ errors.name[0] }}</div>
        </div>
        <div class="modern-form-actions">
          <button :disabled="isLoading" class="modern-form-btn">
            <span v-if="isLoading">Processing...</span>
            <span v-else>Save</span>
          </button>
        </div>
      </form>
      <div v-else>Loading...</div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { usePlantCategories } from '@/composables/plant_categories';

const route = useRoute();
const router = useRouter();
const { plantCategory, getPlantCategory, updatePlantCategory, errors, isLoading } = usePlantCategories();

const name = ref('');

onMounted(async () => {
  await getPlantCategory(route.params.id);
  if (plantCategory.value) {
    name.value = plantCategory.value.name;
  }
});

watch(plantCategory, (val) => {
  if (val) {
    name.value = val.name;
  }
});

async function submitForm() {
  try {
    await updatePlantCategory(route.params.id, { name: name.value });
    router.push({ name: 'plant_categories.index' });
  } catch (e) {}
}
</script>
<style scoped>
</style> 