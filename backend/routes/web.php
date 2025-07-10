<?php

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

Route::get('/', function () {
    return view('welcome');
});

// Health check route for Railway
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'environment' => config('app.env'),
        'version' => '1.0.0'
    ]);
});

Route::get('/health.php', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'environment' => config('app.env'),
        'version' => '1.0.0'
    ]);
});
