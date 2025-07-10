<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Simple health check that doesn't depend on Laravel
echo json_encode([
    'status' => 'healthy',
    'timestamp' => date('Y-m-d H:i:s'),
    'environment' => $_ENV['APP_ENV'] ?? 'production',
    'php_version' => PHP_VERSION,
    'message' => 'Railway health check passed',
    'laravel_ready' => file_exists(__DIR__ . '/../vendor/autoload.php')
]); 