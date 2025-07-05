import {useAuthStore} from "@/store/auth";

const AuthenticatedLayout = () => import('../layouts/Authenticated.vue')
const GuestLayout = ()  => import('../layouts/Guest.vue');

const PostsIndex  = ()  => import('../views/admin/posts/Index.vue');
const PostsCreate  = ()  => import('../views/admin/posts/Create.vue');
const PostsEdit  = ()  => import('../views/admin/posts/Edit.vue');

// Documentation pages
const DocumentationIndex = () => import('@/views/documentation/Index.vue');
const DocumentationConnect = () => import('@/views/documentation/Connect.vue');
const DocumentationBackend = () => import('@/views/documentation/Backend.vue');
const DocumentationApi = () => import('@/views/documentation/Api.vue');
const DocumentationFrontend = () => import('@/views/documentation/Frontend.vue');
const DocumentationML = () => import('@/views/documentation/ML.vue');
const DocumentationProjectStructure = () => import('@/views/documentation/ProjectStructure.vue');

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
        name: 'root',
        component: () => import('../views/login/Login.vue'),
        beforeEnter: (to, from, next) => {
            const auth = useAuthStore();
            if (auth.authenticated) {
                next('/admin');
            } else {
                next();
            }
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
                name: 'profile.settings',
                path: 'profile/settings',
                component: () => import('../views/admin/profile/Settings.vue'),
                meta: { breadCrumb: 'Settings' }
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
            {
                name: 'feedback.index',
                path: 'feedback',
                component: () => import('../views/admin/feedback/Index.vue'),
                meta: { breadCrumb: 'Feedback' }
            },
        ],
    },
    {
        name: 'documentation',
        path: '/documentation',
        component: DocumentationIndex,
    },
    {
        name: 'docs',
        path: '/docs',
        component: DocumentationIndex,
    },
    {
        name: 'documentation-ml',
        path: '/documentation/ml',
        component: DocumentationML,
        meta: {
            sidebarSections: [
                { id: 'ml', title: 'ML Docs', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'features', label: 'Features' },
                    { id: 'model-architecture', label: 'Model Architecture' },
                    { id: 'dataset', label: 'Dataset' },
                    { id: 'performance', label: 'Performance Metrics' },
                    { id: 'deployment', label: 'Model Deployment' },
                    { id: 'api-integration', label: 'API Integration' },
                    { id: 'mobile-integration', label: 'Mobile Integration' },
                    { id: 'model-updates', label: 'Model Updates' },
                    { id: 'data-privacy', label: 'Data Privacy' },
                    { id: 'future-improvements', label: 'Future Improvements' },
                    { id: 'troubleshooting', label: 'Troubleshooting' },
                    { id: 'contributing', label: 'Contributing to ML' },
                ]}
            ]
        },
    },
    {
        name: 'documentation-project-structure',
        path: '/documentation/project-structure',
        component: DocumentationProjectStructure,
        meta: {
            sidebarSections: [
                { id: 'project-structure', title: 'Project Structure', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'backend-structure', label: 'Backend Structure' },
                    { id: 'frontend-structure', label: 'Frontend Structure' },
                    { id: 'api-structure', label: 'API Structure' },
                    { id: 'database-schema', label: 'Database Schema' },
                    { id: 'ml-integration', label: 'ML Integration' },
                    { id: 'deployment-structure', label: 'Deployment Structure' },
                    { id: 'development-workflow', label: 'Development Workflow' },
                    { id: 'configuration', label: 'Configuration' },
                    { id: 'security', label: 'Security' },
                    { id: 'monitoring', label: 'Monitoring & Logging' },
                ]}
            ]
        },
    },
    
    {
        name: 'documentation-connect',
        path: '/documentation/connect',
        component: DocumentationConnect,
        meta: {
            sidebarSections: [
                { id: 'connect', title: 'Connect Docs', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'api-base-url', label: 'API Base URL' },
                    { id: 'authentication', label: 'Authentication' },
                    { id: 'api-calls', label: 'Making API Calls' },
                    { id: 'error-handling', label: 'Error Handling' },
                    { id: 'rate-limiting', label: 'Rate Limiting' },
                    { id: 'best-practices', label: 'Best Practices' },
                    { id: 'sdk-libraries', label: 'SDK & Libraries' },
                    { id: 'webhooks', label: 'Webhooks' },
                    { id: 'testing', label: 'Testing' },
                    { id: 'support', label: 'Support' },
                ]}
            ]
        },
    },
    {
        name: 'documentation-backend',
        path: '/documentation/backend',
        component: DocumentationBackend,
        meta: {
            sidebarSections: [
                { id: 'backend', title: 'Backend Docs', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'features', label: 'Features' },
                    { id: 'project-structure', label: 'Project Structure' },
                    { id: 'main-modules', label: 'Main Modules/Services' },
                    { id: 'database-schema', label: 'Database Schema' },
                    { id: 'auth', label: 'Authentication & Authorization' },
                    { id: 'api-structure', label: 'API Structure' },
                    { id: 'notifications', label: 'Notifications & Feedback' },
                    { id: 'caching', label: 'Caching & Performance' },
                    { id: 'testing', label: 'Testing' },
                    { id: 'deployment', label: 'Deployment' },
                    { id: 'contribution', label: 'Contribution Guidelines' },
                    { id: 'troubleshooting', label: 'Troubleshooting' },
                    { id: 'future', label: 'Future Improvements' },
                ]}
            ]
        },
    },
    {
        name: 'documentation-api',
        path: '/documentation/api',
        component: DocumentationApi,
        meta: {
            sidebarSections: [
                { id: 'api', title: 'API Docs', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'authentication', label: 'Authentication' },
                    { id: 'error-handling', label: 'Error Handling' },
                    { id: 'endpoints', label: 'Endpoints' },
                    { id: 'example-request', label: 'Example Request' },
                    { id: 'example-response', label: 'Example Response' },
                    { id: 'feedback-notification', label: 'Feedback & Notification' },
                    { id: 'pagination', label: 'Pagination' },
                    { id: 'status-codes', label: 'Status Codes' },
                    { id: 'versioning', label: 'Versioning' },
                    { id: 'best-practices', label: 'Best Practices' },
                ]}
            ]
        },
    },
    {
        name: 'documentation-frontend',
        path: '/documentation/frontend',
        component: DocumentationFrontend,
        meta: {
            sidebarSections: [
                { id: 'frontend', title: 'Frontend Docs', items: [
                    { id: 'overview', label: 'Overview' },
                    { id: 'features', label: 'Features' },
                    { id: 'project-structure', label: 'Project Structure' },
                    { id: 'main-screens', label: 'Main Screens' },
                    { id: 'state-management', label: 'State Management' },
                    { id: 'api-integration', label: 'API Integration' },
                    { id: 'caching', label: 'Caching' },
                    { id: 'localization', label: 'Localization' },
                    { id: 'notifications', label: 'Notifications' },
                    { id: 'build-run', label: 'Build & Run' },
                    { id: 'testing', label: 'Testing' },
                    { id: 'contribution', label: 'Contribution' },
                    { id: 'troubleshooting', label: 'Troubleshooting' },
                    { id: 'future', label: 'Future Improvements' },
                ]}
            ]
        },
    },
    {
        path: "/:pathMatch(.*)*",
        name: 'NotFound',
        component: () => import("../views/errors/404.vue"),
    },
];
