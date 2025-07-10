<?php
header('Content-Type: application/json');

// Completely independent test endpoint
echo json_encode([
    'status' => 'working',
    'timestamp' => date('Y-m-d H:i:s'),
    'environment' => $_ENV['APP_ENV'] ?? 'unknown',
    'php_version' => PHP_VERSION,
    'message' => 'PHP server is running successfully!',
    'server' => $_SERVER['SERVER_SOFTWARE'] ?? 'PHP Built-in Server'
]); 