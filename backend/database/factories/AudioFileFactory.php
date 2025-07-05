<?php

namespace Database\Factories;

use App\Models\Plant;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\AudioFile>
 */
class AudioFileFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'plant_id' => Plant::factory(),
            'file_path' => 'audio/' . fake()->uuid() . '.mp3',
            'file_name' => fake()->words(2, true) . '.mp3',
            'file_size' => fake()->numberBetween(100000, 5000000),
            'duration' => fake()->numberBetween(30, 300),
            'language_code' => fake()->languageCode(),
        ];
    }
} 