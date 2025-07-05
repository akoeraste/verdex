<?php

namespace Database\Factories;

use App\Models\Plant;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\PlantTranslation>
 */
class PlantTranslationFactory extends Factory
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
            'language_code' => fake()->languageCode(),
            'common_name' => fake()->words(2, true),
            'description' => fake()->paragraph(),
            'uses' => fake()->paragraph(),
            'audio_url' => null,
        ];
    }
} 