import { ref, inject } from 'vue'
import { useRouter } from 'vue-router'
import {useAuthStore} from "@/store/auth";

export default function useProfile() {

    const profile = ref({
        name: '',
        email: '',
    })

    const store = useAuthStore()
    const router = useRouter()
    const validationErrors = ref({})
    const isLoading = ref(false)
    const swal = inject('$swal')

    const getProfile = async () => {
        profile.value = store.user
        // axios.get('/api/user')
        //     .then(({data}) => {
        //         profile.value = data.data;
        //     })
    }

    const updateProfile = async (profile) => {
        if (isLoading.value) return;

        isLoading.value = true
        validationErrors.value = {}

        axios.post('/api/user', profile, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        })
            .then(({data}) => {
                store.user = data
                swal({
                    icon: 'success',
                    title: 'Profile updated successfully'
                })
            })
            .catch(error => {
                if (error.response?.data) {
                    validationErrors.value = error.response.data.errors
                }
            })
            .finally(() => isLoading.value = false)
    }

    const changePassword = async (passwords) => {
        if (isLoading.value) return;

        isLoading.value = true
        validationErrors.value = {}

        return axios.post('/api/change-password', passwords)
            .then(() => {
                swal({
                    icon: 'success',
                    title: 'Password changed successfully'
                })
            })
            .catch(error => {
                if (error.response?.data) {
                    validationErrors.value = error.response.data.errors
                }
            })
            .finally(() => isLoading.value = false)
    }

    return {
        profile,
        getProfile,
        updateProfile,
        changePassword,
        validationErrors,
        isLoading
    }
}
