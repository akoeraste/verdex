<?php

// Minimal index.php for Railway deployment
header('Content-Type: application/json');

// Check if Laravel is available
if (file_exists(__DIR__.'/../vendor/autoload.php')) {
    try {
        require __DIR__.'/../vendor/autoload.php';
        
        // Try to start Laravel
        $app = require_once __DIR__.'/../bootstrap/app.php';
        
        // If we get here, Laravel is working
        echo json_encode([
            'status' => 'success',
            'message' => 'Laravel application is running!',
            'timestamp' => date('Y-m-d H:i:s'),
            'environment' => $_ENV['APP_ENV'] ?? 'unknown'
        ]);
        
    } catch (Exception $e) {
        // Laravel failed to start
        echo json_encode([
            'status' => 'partial',
            'message' => 'Laravel is installed but failed to start',
            'timestamp' => date('Y-m-d H:i:s'),
            'error' => $e->getMessage()
        ]);
    }
} else {
    // Laravel is not installed yet
    echo json_encode([
        'status' => 'building',
        'message' => 'Application is being built, please wait...',
        'timestamp' => date('Y-m-d H:i:s'),
        'php_version' => PHP_VERSION
    ]);
}
