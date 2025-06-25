<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Config;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;
use App\Http\Controllers\Controller;

class BackupController extends Controller
{
    public function download(Request $request)
    {
        // Only allow authenticated users
        if (!Auth::check()) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $dbHost = env('DB_HOST');
        $dbPort = env('DB_PORT', 3306);
        $dbUser = env('DB_USERNAME');
        $dbPass = env('DB_PASSWORD');
        $dbName = env('DB_DATABASE');
        $fileName = 'verdex-backup-' . date('Y-m-d_H-i-s') . '.sql';
        $filePath = storage_path('app/' . $fileName);

        $command = [
            'mysqldump',
            '-h', $dbHost,
            '-P', $dbPort,
            '-u', $dbUser,
            '-p' . $dbPass,
            $dbName,
            '--result-file=' . $filePath,
            '--single-transaction',
            '--quick',
            '--lock-tables=false',
        ];

        try {
            $process = new Process($command);
            $process->setTimeout(60);
            $process->run();

            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            if (!file_exists($filePath)) {
                return response()->json(['message' => 'Backup file not found.'], 500);
            }

            return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
        } catch (\Exception $e) {
            Log::error('Backup failed: ' . $e->getMessage());
            return response()->json(['message' => 'Backup failed: ' . $e->getMessage()], 500);
        }
    }
} 