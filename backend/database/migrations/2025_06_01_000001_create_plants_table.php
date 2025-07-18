<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('plants', function (Blueprint $table) {
            $table->id();
            $table->string('scientific_name')->unique();
            $table->unsignedBigInteger('plant_category_id')->nullable();
            $table->string('family')->nullable();
            $table->string('genus')->nullable();
            $table->string('species')->nullable();
            $table->json('image_urls')->nullable();
            $table->string('toxicity_level')->nullable();
            $table->timestamps();

            $table->foreign('plant_category_id')->references('id')->on('plant_categories')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('plants');
    }
}; 