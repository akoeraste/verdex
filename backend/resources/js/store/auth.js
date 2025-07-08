import {defineStore} from 'pinia'
import axios from 'axios';
import {ref} from "vue";

export const useAuthStore = defineStore('auth', () => {
    const authenticated = ref(false)
    const user = ref({})

    // Set Authorization header from localStorage if token exists
    const token = localStorage.getItem('access_token');
    if (token) {
        axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }

    const login = (() => {
        return axios.get('/api/user').then(({data}) => {
            if (data.success) {
                user.value = data.data
                authenticated.value = true
            } else {
                user.value = {}
                authenticated.value = false
            }
        }).catch((error) => {
            user.value = {}
            authenticated.value = false
        })
    })

    const getUser = (() => {
        return axios.get('/api/user').then(({data}) => {
            if (data.success) {
                user.value = data.data
                authenticated.value = true
                // router.push({name: 'dashboard'})
            } else {
                user.value = {}
                authenticated.value = false
            }
        }).catch((error) => {
            user.value = {}
            authenticated.value = false
        })
    })

    const logout = (() => {
        user.value = {}
        authenticated.value = false
    })

    return {authenticated, user, login, getUser, logout}
}, {
    persist: true
})
