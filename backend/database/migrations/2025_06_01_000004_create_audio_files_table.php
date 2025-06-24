<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audio_files', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->foreignId('plant_id')->constrained('plants')->onDelete('cascade');
            $table->string('language', 8); // ISO code
            $table->string('audio_url');
            $table->timestamps();
            $table->unique(['plant_id', 'language']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audio_files');
    }
}; 