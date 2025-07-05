<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\PlantController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Landing page route
Route::get('/', function() {
    return view('landing');
})->name('landing');

// Health check route for Railway (moved to /health)
Route::get('/health', function() {
    return response()->json([
        'status' => 'healthy',
        'message' => 'Verdex Backend API is running',
        'version' => '1.0.0',
        'timestamp' => now()->toISOString()
    ]);
});

Route::post('login', [AuthenticatedSessionController::class, 'login']);
Route::post('register', [AuthenticatedSessionController::class, 'register']);
Route::post('logout', [AuthenticatedSessionController::class, 'logout']);

// Add GET routes for login and admin pages that serve the Vue app
Route::get('login', function() {
    return view('main-view');
})->name('login');

// Web routes for plants (session authenticated)
Route::middleware(['auth'])->group(function () {
    Route::get('web/plants', [PlantController::class, 'index']);
    Route::post('web/plants', [PlantController::class, 'store']);
    Route::get('web/plants/{plant}', [PlantController::class, 'show']);
    Route::put('web/plants/{plant}', [PlantController::class, 'update']);
    Route::delete('web/plants/{plant}', [PlantController::class, 'destroy']);
    Route::put('web/plants/{plant}/translations', [PlantController::class, 'updateTranslations']);
    Route::get('web/plant-categories-list', [PlantController::class, 'getCategories']);
    Route::get('web/languages-list', [PlantController::class, 'getLanguages']);
});

// Documentation routes (public access)
Route::get('docs', function() {
    return view('main-view');
})->name('docs');

Route::get('documentation', function() {
    return view('main-view');
})->name('documentation');

Route::get('documentation/{any?}', function() {
    return view('main-view');
})->name('documentation.any')->where('any', '.*');

Route::get('admin/{any?}', function() {
    return view('main-view');
})->name('admin')->where('any', '.*');

//Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');


Route::view('/{any?}', 'main-view')
    ->name('dashboard')
    ->where('any', '.*');
