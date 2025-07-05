<?php

namespace App\Console\Commands;

use App\Models\Plant;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class FixPlantImagesCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'plants:fix-images {--dry-run : Show what would be changed without making changes}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Fix broken plant image URLs by reassigning from available storage folders';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $isDryRun = $this->option('dry-run');
        
        $this->info('=== Fixing Plant Image URLs ===');
        if ($isDryRun) {
            $this->warn('DRY RUN MODE - No changes will be made');
        }
        $this->newLine();

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

        if (empty($availableFolders)) {
            $this->error('No available storage folders found!');
            return 1;
        }

        $this->info('Available folders: ' . implode(', ', $availableFolders));
        $this->newLine();

        // Get all plants
        $plants = Plant::all();
        $folderIndex = 0;
        $updatedCount = 0;

        $progressBar = $this->output->createProgressBar($plants->count());
        $progressBar->start();

        foreach ($plants as $plant) {
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
                $folderName = $this->extractFolderFromUrl($url);
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
                
                if (!$isDryRun) {
                    // Update the plant
                    $plant->update(['image_urls' => $newUrls]);
                }
                
                $updatedCount++;
                $this->newLine();
                $this->line("  Updated: {$plant->scientific_name} -> {$folderName} (" . count($newUrls) . " images)");
                
                $folderIndex++;
            }
            
            $progressBar->advance();
        }

        $progressBar->finish();
        $this->newLine(2);

        if ($isDryRun) {
            $this->info("Dry run completed. {$updatedCount} plants would be updated.");
        } else {
            $this->info("Completed! {$updatedCount} plants updated.");
        }

        return 0;
    }

    /**
     * Extract folder name from URL
     */
    private function extractFolderFromUrl($url)
    {
        // Extract folder name from URL like "/storage/plants/banana/banana540.jpg"
        $parts = explode('/', $url);
        foreach ($parts as $i => $part) {
            if ($part === 'plants' && isset($parts[$i + 1])) {
                return $parts[$i + 1];
            }
        }
        return '';
    }
} 