import { createRouter, createWebHistory } from "vue-router";
import routes from './routes.js'
import { useAuthStore } from '@/store/auth';

const router = createRouter({
    history: createWebHistory(),
    routes
})

// Add global navigation guard for public documentation routes
const publicRoutes = [
    '/login',
    '/documentation',
    '/documentation/connect',
    '/documentation/backend',
    '/documentation/api',
    '/documentation/frontend'
];

router.beforeEach((to, from, next) => {
    const auth = useAuthStore();
    if (publicRoutes.includes(to.path)) {
        next();
    } else if (!auth.authenticated) {
        next('/login');
    } else {
        next();
    }
});

export default router;
