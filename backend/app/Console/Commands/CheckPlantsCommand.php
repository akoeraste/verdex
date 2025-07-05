<?php

namespace App\Console\Commands;

use App\Models\Plant;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class CheckPlantsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'plants:check';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Check plant database integrity and storage folders';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('=== Plant Database Check ===');
        $this->newLine();

        // Get all plants
        $plants = Plant::all();
        $this->info("Total plants: " . $plants->count());
        $this->newLine();

        $table = [];
        foreach ($plants as $plant) {
            $table[] = [
                'ID' => $plant->id,
                'Name' => $plant->scientific_name,
                'Images' => is_array($plant->image_urls) ? count($plant->image_urls) : 'N/A',
                'Category' => $plant->plantCategory?->name ?? 'N/A',
            ];
        }

        $this->table(['ID', 'Name', 'Images', 'Category'], $table);

        $this->newLine();
        $this->info('=== Storage Folders ===');
        
        $storagePath = storage_path('app/public/plants');
        if (is_dir($storagePath)) {
            $folders = scandir($storagePath);
            $validFolders = [];
            
            foreach ($folders as $folder) {
                if ($folder !== '.' && $folder !== '..' && is_dir($storagePath . '/' . $folder)) {
                    $validFolders[] = $folder;
                }
            }
            
            if (empty($validFolders)) {
                $this->warn('No plant folders found in storage');
            } else {
                $this->info('Available folders: ' . implode(', ', $validFolders));
            }
        } else {
            $this->error('Storage path does not exist: ' . $storagePath);
        }

        $this->newLine();
        $this->info('Check completed!');
    }
} 