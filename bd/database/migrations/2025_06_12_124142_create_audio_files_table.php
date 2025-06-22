<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audio_files', function (Blueprint $table) {
            $table->id();
            $table->foreignId('plant_id')->constrained()->onDelete('cascade');
            $table->foreignId('language_id')->constrained('languages')->onDelete('cascade');
            $table->string('audio_url');
            $table->string('description')->nullable();
            $table->timestamps();

            // Add unique constraint to prevent duplicate audio files for same plant and language
            $table->unique(['plant_id', 'language_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audio_files');
    }
}; 