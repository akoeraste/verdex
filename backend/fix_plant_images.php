<?php

require_once 'vendor/autoload.php';

$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use App\Models\Plant;

echo "=== Fixing Plant Image URLs ===\n\n";

// Get available storage folders
$storagePath = storage_path('app/public/plants');
$availableFolders = [];
if (is_dir($storagePath)) {
    $folders = scandir($storagePath);
    foreach ($folders as $folder) {
        if ($folder !== '.' && $folder !== '..' && is_dir($storagePath . '/' . $folder)) {
            $availableFolders[] = $folder;
        }
    }
}

echo "Available folders: " . implode(', ', $availableFolders) . "\n\n";

// Get all plants
$plants = Plant::all();
$folderIndex = 0;

foreach ($plants as $plant) {
    echo "Processing plant: {$plant->scientific_name}\n";
    
    // Get current image URLs - handle both string and array
    $currentUrls = [];
    if (is_string($plant->image_urls)) {
        $currentUrls = json_decode($plant->image_urls, true) ?? [];
    } elseif (is_array($plant->image_urls)) {
        $currentUrls = $plant->image_urls;
    }
    
    // Check if any of the current URLs point to non-existent folders
    $needsUpdate = false;
    foreach ($currentUrls as $url) {
        $folderName = extractFolderFromUrl($url);
        if (!in_array($folderName, $availableFolders)) {
            $needsUpdate = true;
            break;
        }
    }
    
    if ($needsUpdate) {
        // Assign images from available folders
        $newUrls = [];
        $folderName = $availableFolders[$folderIndex % count($availableFolders)];
        
        // Get images from this folder
        $folderPath = $storagePath . '/' . $folderName;
        $images = glob($folderPath . '/*.jpg');
        
        foreach ($images as $image) {
            $filename = basename($image);
            $newUrls[] = "/storage/plants/{$folderName}/{$filename}";
        }
        
        // Update the plant
        $plant->update(['image_urls' => $newUrls]);
        echo "  Updated to use folder: {$folderName}\n";
        echo "  New URLs: " . json_encode($newUrls) . "\n";
        
        $folderIndex++;
    } else {
        echo "  No update needed\n";
    }
    
    echo "---\n";
}

echo "Done!\n";

function extractFolderFromUrl($url) {
    // Extract folder name from URL like "/storage/plants/banana/banana540.jpg"
    $parts = explode('/', $url);
    foreach ($parts as $i => $part) {
        if ($part === 'plants' && isset($parts[$i + 1])) {
            return $parts[$i + 1];
        }
    }
    return '';
} 