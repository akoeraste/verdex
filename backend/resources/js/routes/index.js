import { createRouter, createWebHistory } from "vue-router";
import routes from './routes.js'
import { useAuthStore } from '@/store/auth';

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach((to, from, next) => {
    const auth = useAuthStore();
    
    // Allow all documentation routes (including sub-routes)
    if (to.path.startsWith('/docs') || to.path.startsWith('/documentation') || to.path === '/login') {
        next();
    } else if (!auth.authenticated) {
        next('/login');
    } else {
        next();
    }
});

export default router;
