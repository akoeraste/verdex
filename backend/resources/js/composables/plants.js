import { ref, reactive, watch } from 'vue'
import axios from 'axios'

const defaultPagination = {
  current_page: 1,
  last_page: 1,
  per_page: 5,
  total: 0
};

export function usePlants() {
    const plants = ref([])
    const plant = ref(null)
    const loading = ref(false)
    const error = ref(null)
    const categories = ref([])
    const languages = ref([])
    const pagination = ref({ ...defaultPagination })

    // Form data structure
    const formData = reactive({
        scientific_name: '',
        plant_category_id: '',
        family: '',
        genus: '',
        species: '',
        toxicity_level: '',
        images: [],
        translations: []
    })

    // Get all plants
    const getPlants = async (page = 1, search = '') => {
        loading.value = true
        error.value = null
        console.log('getPlants called with page:', page)
        try {
            let url = `/api/test/plants?page=${page}`
            if (search) {
                url += `&search=${search}`
            }
            const response = await axios.get(url)
            console.log('API Response:', response.data)
            plants.value = response.data.data
            pagination.value = {
                current_page: response.data.current_page ?? 1,
                last_page: response.data.last_page ?? 1,
                per_page: response.data.per_page ?? 5,
                total: response.data.total ?? 0
            }
            console.log('Plants loaded:', plants.value)
            console.log('Pagination data:', pagination.value)
        } catch (err) {
            console.error('Error fetching plants:', err)
            error.value = err.response?.data?.message || 'Failed to fetch plants'
            pagination.value = { ...defaultPagination }
        } finally {
            loading.value = false
        }
    }

    // Get single plant
    const getPlant = async (id) => {
        loading.value = true
        error.value = null
        try {
            console.log('Fetching plant with ID:', id)
            const response = await axios.get(`/web/plants/${id}`)
            console.log('Plant web API response:', response.data)
            plant.value = response.data.data
            console.log('Plant data set to:', plant.value)
            return response.data.data
        } catch (err) {
            console.error('Error fetching plant:', err)
            error.value = err.response?.data?.message || 'Failed to fetch plant'
        } finally {
            loading.value = false
        }
    }

    // Get categories for dropdown
    const getCategories = async () => {
        try {
            const response = await axios.get('/web/plant-categories-list')
            categories.value = response.data
        } catch (err) {
            console.error('Failed to fetch categories:', err)
        }
    }

    // Get languages for dropdown
    const getLanguages = async () => {
        try {
            const response = await axios.get('/web/languages-list')
            languages.value = response.data
        } catch (err) {
            console.error('Failed to fetch languages:', err)
        }
    }

    // Store plant
    const storePlant = async () => {
        loading.value = true
        error.value = null
        try {
            console.log('=== STORE PLANT START ===')
            console.log('Form data before processing:', formData)
            
            const data = new FormData()
            data.append('scientific_name', formData.scientific_name)
            data.append('plant_category_id', formData.plant_category_id)
            data.append('family', formData.family || '')
            data.append('genus', formData.genus || '')
            data.append('species', formData.species || '')
            data.append('toxicity_level', formData.toxicity_level || '')
            
            console.log('Basic fields added to FormData')
            
            // Append multiple images
            console.log('Images to upload:', formData.images)
            formData.images.forEach((image, index) => {
                console.log(`Adding image ${index}:`, image.name, image.size, image.type)
                data.append(`images[${index}]`, image)
            })
            
            // Append translations
            console.log('Translations to upload:', formData.translations)
            formData.translations.forEach((translation, index) => {
                console.log(`Adding translation ${index}:`, translation)
                data.append(`translations[${index}][language_code]`, translation.language_code)
                data.append(`translations[${index}][common_name]`, translation.common_name)
                data.append(`translations[${index}][description]`, translation.description)
                data.append(`translations[${index}][uses]`, translation.uses)
                
                // Append audio file if it exists
                if (translation.audio_file) {
                    console.log(`Adding audio file for translation ${index}:`, translation.audio_file.name, translation.audio_file.size, translation.audio_file.type)
                    data.append(`translations[${index}][audio_file]`, translation.audio_file)
                } else {
                    console.log(`No audio file for translation ${index}`)
                }
            })

            // Log the actual FormData contents
            console.log('=== FORMDATA CONTENTS ===')
            for (let [key, value] of data.entries()) {
                console.log('FormData entry:', key, value)
            }

            console.log('Sending request to /web/plants')
            const response = await axios.post('/web/plants', data, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            })
            
            console.log('=== STORE PLANT SUCCESS ===')
            console.log('Response:', response.data)
            
            resetForm()
            return response.data.data
        } catch (err) {
            console.error('=== STORE PLANT FAILED ===')
            console.error('Error:', err)
            console.error('Error response:', err.response?.data)
            console.error('Error status:', err.response?.status)
            if (err.response?.data?.errors) {
                console.error('Validation errors:', err.response.data.errors)
                // Format validation errors for display
                const errorMessages = []
                Object.keys(err.response.data.errors).forEach(field => {
                    err.response.data.errors[field].forEach(message => {
                        errorMessages.push(`${field}: ${message}`)
                    })
                })
                error.value = errorMessages.join(', ')
            } else {
                error.value = err.response?.data?.message || 'Failed to create plant'
            }
            throw err
        } finally {
            loading.value = false
        }
    }

    // Update plant
    const updatePlant = async (id) => {
        loading.value = true
        error.value = null
        try {
            // Debug: log formData before sending
            console.log('FormData before sending:', JSON.stringify(formData, null, 2));
            const data = new FormData()
            data.append('scientific_name', formData.scientific_name)
            data.append('plant_category_id', formData.plant_category_id)
            data.append('family', formData.family || '')
            data.append('genus', formData.genus || '')
            data.append('species', formData.species || '')
            data.append('toxicity_level', formData.toxicity_level || '')
            // Append multiple images
            formData.images.forEach((image, index) => {
                data.append(`images[${index}]`, image)
            })
            // Append translations - fix the array format for Laravel
            formData.translations.forEach((translation, index) => {
                data.append(`translations[${index}][language_code]`, translation.language_code)
                data.append(`translations[${index}][common_name]`, translation.common_name)
                data.append(`translations[${index}][description]`, translation.description)
                data.append(`translations[${index}][uses]`, translation.uses)
                // Append audio file if it exists
                if (translation.audio_file) {
                    data.append(`translations[${index}][audio_file]`, translation.audio_file)
                }
            })
            // Add method spoofing for PUT request
            data.append('_method', 'PUT');

            // Log the actual FormData contents
            for (let [key, value] of data.entries()) {
                console.log('FormData entry:', key, value)
            }
            const response = await axios.post(`/web/plants/${id}`, data, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            })
            console.log('Update successful:', response.data)
            resetForm()
            return response.data.data
        } catch (err) {
            console.error('Update failed with error:', err)
            console.error('Error response:', err.response?.data)
            console.error('Error status:', err.response?.status)
            if (err.response?.data?.errors) {
                console.error('Validation errors:', err.response.data.errors)
                // Format validation errors for display
                const errorMessages = []
                Object.keys(err.response.data.errors).forEach(field => {
                    err.response.data.errors[field].forEach(message => {
                        errorMessages.push(`${field}: ${message}`)
                    })
                })
                error.value = errorMessages.join(', ')
            } else {
                error.value = err.response?.data?.message || 'Failed to update plant'
            }
            throw err
        } finally {
            loading.value = false
        }
    }

    // Delete plant
    const deletePlant = async (id) => {
        loading.value = true
        error.value = null
        try {
            await axios.delete(`/web/plants/${id}`)
        } catch (err) {
            error.value = err.response?.data?.message || 'Failed to delete plant'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Add translation
    const addTranslation = () => {
        formData.translations.push({
            language_code: '',
            common_name: '',
            description: '',
            uses: '',
            audio_url: '',
            audio_file: null
        })
    }

    // Remove translation section
    const removeTranslation = (index) => {
        formData.translations.splice(index, 1)
    }

    // Add image
    const addImage = (file) => {
        formData.images.push(file)
    }

    // Remove image
    const removeImage = (index) => {
        formData.images.splice(index, 1)
    }

    // Reset form
    const resetForm = () => {
        formData.scientific_name = ''
        formData.plant_category_id = ''
        formData.family = ''
        formData.genus = ''
        formData.species = ''
        formData.toxicity_level = ''
        formData.images = []
        formData.translations = []
    }

    // Load plant data for editing
    const loadPlantForEdit = (plantData) => {
        formData.scientific_name = plantData.scientific_name || ''
        formData.plant_category_id = plantData.plant_category_id || ''
        formData.family = plantData.family || ''
        formData.genus = plantData.genus || ''
        formData.species = plantData.species || ''
        formData.toxicity_level = plantData.toxicity_level || ''
        formData.images = []
        formData.translations = Array.isArray(plantData.translations) ? plantData.translations.map(translation => ({
            language_code: translation.language_code || '',
            common_name: translation.common_name || '',
            description: translation.description || '',
            uses: translation.uses || '',
            audio_url: translation.audio_url || '',
            audio_file: null // For new audio file uploads
        })) : []
        console.log('Loaded formData for edit:', JSON.stringify(formData, null, 2));
    }

    return {
        plants,
        plant,
        loading,
        error,
        categories,
        languages,
        pagination,
        formData,
        getPlants,
        getPlant,
        getCategories,
        getLanguages,
        storePlant,
        updatePlant,
        deletePlant,
        addTranslation,
        removeTranslation,
        addImage,
        removeImage,
        resetForm,
        loadPlantForEdit
    }
} 