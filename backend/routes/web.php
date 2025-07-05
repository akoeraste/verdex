<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;

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

// Health check route for Railway
Route::get('/', function() {
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

Route::get('admin/{any?}', function() {
    return view('main-view');
})->name('admin')->where('any', '.*');

//Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');


Route::view('/{any?}', 'main-view')
    ->name('dashboard')
    ->where('any', '.*');
