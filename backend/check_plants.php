<?php

require_once 'vendor/autoload.php';

$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use App\Models\Plant;

echo "=== Plant Database Check ===\n\n";

// Get all plants
$plants = Plant::all();

echo "Total plants: " . $plants->count() . "\n\n";

foreach ($plants as $plant) {
    echo "ID: {$plant->id}\n";
    echo "Name: {$plant->scientific_name}\n";
    echo "Image URLs: " . json_encode($plant->image_urls) . "\n";
    echo "---\n";
}

echo "\n=== Available Storage Folders ===\n";
$storagePath = storage_path('app/public/plants');
if (is_dir($storagePath)) {
    $folders = scandir($storagePath);
    foreach ($folders as $folder) {
        if ($folder !== '.' && $folder !== '..' && is_dir($storagePath . '/' . $folder)) {
            echo "- {$folder}\n";
        }
    }
} 