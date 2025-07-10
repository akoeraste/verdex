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
    return response()->json([
        'status' => 'healthy',
        'message' => 'Verdex Backend is running',
        'timestamp' => now(),
        'environment' => config('app.env'),
        'version' => '1.0.0'
    ]);
});

// Railway health check endpoint
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'environment' => config('app.env'),
        'version' => '1.0.0',
        'message' => 'Health check passed'
    ]);
});

// Test endpoint for debugging
Route::get('/test', function () {
    return response()->json([
        'status' => 'working',
        'timestamp' => now(),
        'environment' => config('app.env'),
        'version' => '1.0.0',
        'message' => 'Laravel is running!'
    ]);
});
