import {useAuthStore} from "@/store/auth";

const AuthenticatedLayout = () => import('../layouts/Authenticated.vue')
const GuestLayout = ()  => import('../layouts/Guest.vue');

const PostsIndex  = ()  => import('../views/admin/posts/Index.vue');
const PostsCreate  = ()  => import('../views/admin/posts/Create.vue');
const PostsEdit  = ()  => import('../views/admin/posts/Edit.vue');

function requireLogin(to, from, next) {
    const auth = useAuthStore()
    let isLogin = false;
    isLogin = !!auth.authenticated;

    if (isLogin) {
        next()
    } else {
        next('/login')
    }
}

function guest(to, from, next) {
    const auth = useAuthStore()
    let isLogin;
    isLogin = !!auth.authenticated;

    if (isLogin) {
        next('/admin')
    } else {
        next()
    }
}

export default [
    {
        path: '/',
        redirect: (to) => {
            const auth = useAuthStore();
            return auth.authenticated ? '/admin' : '/login';
        },
    },
    {
        path: '/login',
        name: 'auth.login',
        component: () => import('../views/login/Login.vue'),
        beforeEnter: guest,
    },
    {
        path: '/admin',
        component: AuthenticatedLayout,
        beforeEnter: requireLogin,
        children: [
            {
                name: 'admin.index',
                path: '',
                component: () => import('../views/admin/index.vue'),
                meta: { breadCrumb: 'Admin' }
            },
            {
                name: 'profile.index',
                path: 'profile',
                component: () => import('../views/admin/profile/index.vue'),
                meta: { breadCrumb: 'Profile' }
            },
            {
                name: 'posts.index',
                path: 'posts',
                component: PostsIndex,
                meta: { breadCrumb: 'Posts' }
            },
            {
                name: 'posts.create',
                path: 'posts/create',
                component: PostsCreate,
                meta: { breadCrumb: 'Add new post' }
            },
            {
                name: 'posts.edit',
                path: 'posts/edit/:id',
                component: PostsEdit,
                meta: { breadCrumb: 'Edit post' }
            },
            {
                name: 'categories.index',
                path: 'categories',
                component: () => import('../views/admin/categories/Index.vue'),
                meta: { breadCrumb: 'Categories' }
            },
            {
                name: 'categories.create',
                path: 'categories/create',
                component: () => import('../views/admin/categories/Create.vue'),
                meta: { breadCrumb: 'Add new category' }
            },
            {
                name: 'categories.edit',
                path: 'categories/edit/:id',
                component: () => import('../views/admin/categories/Edit.vue'),
                meta: { breadCrumb: 'Edit Category' }
            },
            {
                name: 'permissions.index',
                path: 'permissions',
                component: () => import('../views/admin/permissions/Index.vue'),
                meta: { breadCrumb: 'Permissions' }
            },
            {
                name: 'permissions.create',
                path: 'permissions/create',
                component: () => import('../views/admin/permissions/Create.vue'),
                meta: { breadCrumb: 'Create Permission' }
            },
            {
                name: 'permissions.edit',
                path: 'permissions/edit/:id',
                component: () => import('../views/admin/permissions/Edit.vue'),
                meta: { breadCrumb: 'Permission Edit' }
            },
            {
                name: 'roles.index',
                path: 'roles',
                component: () => import('../views/admin/roles/Index.vue'),
                meta: { breadCrumb: 'Roles' }
            },
            {
                name: 'roles.create',
                path: 'roles/create',
                component: () => import('../views/admin/roles/Create.vue'),
                meta: { breadCrumb: 'Create Role' }
            },
            {
                name: 'roles.edit',
                path: 'roles/edit/:id',
                component: () => import('../views/admin/roles/Edit.vue'),
                meta: { breadCrumb: 'Role Edit' }
            },
            {
                name: 'users.index',
                path: 'users',
                component: () => import('../views/admin/users/Index.vue'),
                meta: { breadCrumb: 'Users' }
            },
            {
                name: 'users.create',
                path: 'users/create',
                component: () => import('../views/admin/users/Create.vue'),
                meta: { breadCrumb: 'Add New' }
            },
            {
                name: 'users.edit',
                path: 'users/edit/:id',
                component: () => import('../views/admin/users/Edit.vue'),
                meta: { breadCrumb: 'User Edit' }
            },
            {
                name: 'browser_sessions.index',
                path: 'browser-sessions',
                component: () => import('../views/admin/browser-sessions/Index.vue'),
                meta: { breadCrumb: 'Browser Sessions' }
            },
            {
                name: 'activity_log.index',
                path: 'activity-log-logs',
                component: () => import('../views/admin/activity-log/Index.vue'),
                meta: { breadCrumb: 'Activity Logs' }
            },
            {
                name: 'plants.index',
                path: 'plants',
                component: () => import('../views/admin/plants/Index.vue'),
                meta: { breadCrumb: 'Plants' }
            },
            {
                name: 'plants.create',
                path: 'plants/create',
                component: () => import('../views/admin/plants/Create.vue'),
                meta: { breadCrumb: 'Add new plant' }
            },
            {
                name: 'plants.edit',
                path: 'plants/edit/:id',
                component: () => import('../views/admin/plants/Edit.vue'),
                meta: { breadCrumb: 'Edit plant' }
            },
            {
                name: 'languages.index',
                path: 'languages',
                component: () => import('../views/admin/languages/Index.vue'),
                meta: { breadCrumb: 'Languages' }
            },
            {
                name: 'languages.create',
                path: 'languages/create',
                component: () => import('../views/admin/languages/Create.vue'),
                meta: { breadCrumb: 'Add new language' }
            },
            {
                name: 'languages.edit',
                path: 'languages/edit/:id',
                component: () => import('../views/admin/languages/Edit.vue'),
                meta: { breadCrumb: 'Edit language' }
            },
            {
                name: 'plant_categories.index',
                path: 'plant-categories',
                component: () => import('../views/admin/plant_categories/Index.vue'),
                meta: { breadCrumb: 'Plant Categories' }
            },
            {
                name: 'plant_categories.create',
                path: 'plant-categories/create',
                component: () => import('../views/admin/plant_categories/Create.vue'),
                meta: { breadCrumb: 'Add new plant category' }
            },
            {
                name: 'plant_categories.edit',
                path: 'plant-categories/edit/:id',
                component: () => import('../views/admin/plant_categories/Edit.vue'),
                meta: { breadCrumb: 'Edit plant category' }
            },
            {
                name: 'usage_stats.index',
                path: 'usage-stats',
                component: () => import('../views/admin/usage-stats/Index.vue'),
                meta: { breadCrumb: 'Usage Stats' }
            },
            {
                name: 'search_trends.index',
                path: 'search-trends',
                component: () => import('../views/admin/search-trends/Index.vue'),
                meta: { breadCrumb: 'Search Trends' }
            },
            {
                name: 'plant_translations.index',
                path: 'plant-translations',
                component: () => import('../views/admin/plant_translations/Index.vue'),
                meta: { breadCrumb: 'Plant Translations' }
            },
            {
                name: 'plant_translations.edit',
                path: 'plant-translations/edit/:id',
                component: () => import('../views/admin/plant_translations/Edit.vue'),
                meta: { breadCrumb: 'Edit Plant Translation' }
            },
            {
                name: 'admin/backup',
                path: 'backup',
                component: () => import('../views/admin/backup.vue'),
                meta: { requiresAuth: true },
            },
        ]
    },
    {
        path: "/:pathMatch(.*)*",
        name: 'NotFound',
        component: () => import("../views/errors/404.vue"),
    },
];
