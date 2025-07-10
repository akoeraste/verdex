<?php
header('Content-Type: application/json');

// Simple test endpoint that doesn't depend on Laravel
echo json_encode([
    'status' => 'working',
    'timestamp' => date('Y-m-d H:i:s'),
    'environment' => $_ENV['APP_ENV'] ?? 'unknown',
    'php_version' => PHP_VERSION,
    'message' => 'PHP server is running!'
]); 