<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('plant_translations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('plant_id');
            $table->string('language_code', 8);
            $table->string('common_name');
            $table->text('description');
            $table->text('uses');
            $table->string('audio_url')->nullable();
            $table->timestamps();

            $table->foreign('plant_id')->references('id')->on('plants')->onDelete('cascade');
            $table->unique(['plant_id', 'language_code']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('plant_translations');
    }
}; 