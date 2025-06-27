<?php

use App\Http\Controllers\Api\ActivityLogController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BrowserSessionController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\PermissionController;
use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Auth\ResetPasswordController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Auth\ForgotPasswordController;


Route::post('forget-password', [ForgotPasswordController::class, 'sendResetLinkEmail'])->name('forget.password.post');
Route::post('reset-password', [ResetPasswordController::class, 'reset'])->name('password.reset');
Route::post('send-temp-password', [ForgotPasswordController::class, 'sendTempPassword']);

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

Route::group(['middleware' => 'auth:sanctum'], function() {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::apiResource('users', UserController::class);
    Route::apiResource('posts', PostController::class);
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('roles', RoleController::class);
    Route::get('role-list', [RoleController::class, 'getList']);
    Route::get('role-permissions/{id}', [PermissionController::class, 'getRolePermissions']);
    Route::put('/role-permissions', [PermissionController::class, 'updateRolePermissions']);
    Route::apiResource('permissions', PermissionController::class);
    Route::get('category-list', [CategoryController::class, 'getList']);
    Route::get('/user', [ProfileController::class, 'user']);
    Route::put('/user', [ProfileController::class, 'update']);
    Route::post('/change-password', [ProfileController::class, 'changePassword']);

    // Browser Sessions
    Route::get('browser-sessions', [BrowserSessionController::class, 'index']);
    Route::post('logout-other-devices', [BrowserSessionController::class, 'logoutOtherDevices']);

    // Activity log
    Route::get('activity-logs', ActivityLogController::class);

    Route::get('abilities', function(Request $request) {
        return $request->user()->roles()->with('permissions')
            ->get()
            ->pluck('permissions')
            ->flatten()
            ->pluck('name')
            ->unique()
            ->values()
            ->toArray();
    });

    Route::apiResource('plants', \App\Http\Controllers\Api\PlantController::class);
    Route::put('plants/{plant}/translations', [\App\Http\Controllers\Api\PlantController::class, 'updateTranslations']);
    Route::post('plants/{plant}/translations', [\App\Http\Controllers\Api\PlantController::class, 'storeTranslation']);
    Route::put('plants/{plant}/translations/{translation}', [\App\Http\Controllers\Api\PlantController::class, 'updateTranslation']);
    Route::delete('plants/{plant}/translations/{translation}', [\App\Http\Controllers\Api\PlantController::class, 'destroyTranslation']);
    Route::get('plant-categories-list', [\App\Http\Controllers\Api\PlantController::class, 'getCategories']);
    Route::get('languages-list', [\App\Http\Controllers\Api\PlantController::class, 'getLanguages']);
    Route::apiResource('languages', \App\Http\Controllers\Api\LanguageController::class);
    Route::apiResource('plant-categories', \App\Http\Controllers\Api\PlantCategoryController::class);

    // Database backup
    Route::get('backup/download', [\App\Http\Controllers\Api\BackupController::class, 'download']);

    // Plant sync endpoints
    Route::get('plants/sync', [\App\Http\Controllers\Api\PlantController::class, 'syncDownload']);
    Route::post('plants/sync', [\App\Http\Controllers\Api\PlantController::class, 'syncUpload']);

    // Unified sync endpoints
    Route::get('sync/all', [\App\Http\Controllers\Api\SyncController::class, 'allDownload']);
    Route::post('sync/all', [\App\Http\Controllers\Api\SyncController::class, 'allUpload']);

    // Favorites
    Route::get('favorites', [\App\Http\Controllers\Api\FavoriteController::class, 'index']);
    Route::post('favorites', [\App\Http\Controllers\Api\FavoriteController::class, 'store']);
    Route::delete('favorites/{plant_id}', [\App\Http\Controllers\Api\FavoriteController::class, 'destroy']);
    Route::get('favorites/{plant_id}', [\App\Http\Controllers\Api\FavoriteController::class, 'show']);

    // Feedback admin routes
    Route::get('feedback', [\App\Http\Controllers\Api\FeedbackController::class, 'index']);
    Route::get('feedback/{feedback}', [\App\Http\Controllers\Api\FeedbackController::class, 'show']);
    Route::put('feedback/{feedback}/respond', [\App\Http\Controllers\Api\FeedbackController::class, 'respond']);
    Route::get('feedback-stats', [\App\Http\Controllers\Api\FeedbackController::class, 'stats']);

    // Notification routes
    Route::get('notifications', [\App\Http\Controllers\Api\NotificationController::class, 'index']);
    Route::get('notifications/unread-count', [\App\Http\Controllers\Api\NotificationController::class, 'unreadCount']);
    Route::put('notifications/{id}/read', [\App\Http\Controllers\Api\NotificationController::class, 'markAsRead']);
    Route::put('notifications/mark-all-read', [\App\Http\Controllers\Api\NotificationController::class, 'markAllAsRead']);
    Route::delete('notifications/{id}', [\App\Http\Controllers\Api\NotificationController::class, 'destroy']);
    Route::delete('notifications', [\App\Http\Controllers\Api\NotificationController::class, 'clearAll']);

    Route::post('feedback', [\App\Http\Controllers\Api\FeedbackController::class, 'store']);
});

Route::get('category-list', [CategoryController::class, 'getList']);
Route::get('get-posts', [PostController::class, 'getPosts']);
Route::get('get-category-posts/{id}', [PostController::class, 'getCategoryByPosts']);
Route::get('get-post/{id}', [PostController::class, 'getPost']);

Route::get('dashboard/stats', [\App\Http\Controllers\Api\DashboardController::class, 'stats']);

// Public plant endpoints for Flutter app
Route::get('plants/app/all', [\App\Http\Controllers\Api\PlantController::class, 'getAllForApp']);
Route::get('plants/app/search', [\App\Http\Controllers\Api\PlantController::class, 'searchForApp']);
