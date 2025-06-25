import axios from 'axios';
import { ref } from 'vue';

export function useLanguages() {
    const languages = ref([]);
    const language = ref(null);
    const errors = ref({});
    const isLoading = ref(false);

    const getLanguages = async () => {
        isLoading.value = true;
        try {
            const res = await axios.get('/api/languages');
            languages.value = res.data.data;
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
        } finally {
            isLoading.value = false;
        }
    };

    const getLanguage = async (id) => {
        isLoading.value = true;
        try {
            const res = await axios.get(`/api/languages/${id}`);
            language.value = res.data.data;
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
        } finally {
            isLoading.value = false;
        }
    };

    const createLanguage = async (payload) => {
        isLoading.value = true;
        try {
            await axios.post('/api/languages', payload);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    const updateLanguage = async (id, payload) => {
        isLoading.value = true;
        try {
            await axios.put(`/api/languages/${id}`, payload);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    const deleteLanguage = async (id) => {
        isLoading.value = true;
        try {
            await axios.delete(`/api/languages/${id}`);
        } catch (e) {
            errors.value = e.response?.data?.errors || {};
            throw e;
        } finally {
            isLoading.value = false;
        }
    };

    return {
        languages,
        language,
        errors,
        isLoading,
        getLanguages,
        getLanguage,
        createLanguage,
        updateLanguage,
        deleteLanguage
    };
} 