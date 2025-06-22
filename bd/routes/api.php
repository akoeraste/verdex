<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PlantController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\FeedbackController;
use App\Http\Controllers\Api\StatsController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User routes
    Route::get('/user', [AuthController::class, 'user']);
    Route::put('/user', [AuthController::class, 'update']);
    Route::post('/email/verification-notification', [AuthController::class, 'resendVerificationEmail']);

    // Plant routes
    Route::get('/plants', [PlantController::class, 'index']);
    Route::get('/plants/{slug}', [PlantController::class, 'show']);
    Route::get('/plants/families', [PlantController::class, 'families']);
    Route::get('/plants/toxicity-levels', [PlantController::class, 'toxicityLevels']);

    // Favorite routes
    Route::get('/favorites', [FavoriteController::class, 'index']);
    Route::post('/favorites', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{plant_id}', [FavoriteController::class, 'destroy']);
    Route::get('/favorites/check/{plant_id}', [FavoriteController::class, 'check']);

    // Feedback routes
    Route::get('/feedback', [FeedbackController::class, 'index']);
    Route::post('/feedback', [FeedbackController::class, 'store']);
    Route::get('/feedback/stats', [FeedbackController::class, 'stats']);

    // Stats route
    Route::get('/stats', [StatsController::class, 'index']);
}); 