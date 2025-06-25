import axios from 'axios';
import { ref } from 'vue';

export function usePlantCategories() {
    const plantCategories = ref([]);
    const plantCategory = ref(null);
    const errors = ref({});
    const isLoading = ref(false);

    const getPlantCategories = async () => {
        isLoading.value = true;
        try {
            const res = await axios.get('/api/plant-categories');
            plantCategories.value = res.data.data || res.data;
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
        } finally {
            isLoading.value = false;
        }
    };

    const getPlantCategory = async (id) => {
        isLoading.value = true;
        try {
            const res = await axios.get(`/api/plant-categories/${id}`);
            plantCategory.value = res.data.data || res.data;
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
        } finally {
            isLoading.value = false;
        }
    };

    const createPlantCategory = async (payload) => {
        isLoading.value = true;
        try {
            await axios.post('/api/plant-categories', payload);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    const updatePlantCategory = async (id, payload) => {
        isLoading.value = true;
        try {
            await axios.put(`/api/plant-categories/${id}`, payload);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    const deletePlantCategory = async (id) => {
        isLoading.value = true;
        try {
            await axios.delete(`/api/plant-categories/${id}`);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    return {
        plantCategories,
        plantCategory,
        errors,
        isLoading,
        getPlantCategories,
        getPlantCategory,
        createPlantCategory,
        updatePlantCategory,
        deletePlantCategory
    };
} 