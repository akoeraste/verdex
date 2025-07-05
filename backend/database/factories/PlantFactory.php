<?php

namespace Database\Factories;

use App\Models\Plant;
use App\Models\PlantCategory;
use App\Models\Language;
use App\Models\PlantTranslation;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Plant>
 */
class PlantFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'scientific_name' => fake()->unique()->words(2, true),
            'family' => fake()->words(1, true),
            'genus' => fake()->words(1, true),
            'species' => fake()->words(1, true),
            'toxicity_level' => fake()->randomElement(['low', 'medium', 'high']),
            'plant_category_id' => PlantCategory::factory(),
            'image_urls' => json_encode([]),
        ];
    }

    /**
     * Configure the model factory.
     *
     * @return $this
     */
    public function configure()
    {
        return $this->afterCreating(function (Plant $plant) {
            // Create at least one translation for the plant
            $language = Language::first() ?? Language::factory()->create();
            
            PlantTranslation::factory()->create([
                'plant_id' => $plant->id,
                'language_code' => $language->code,
                'common_name' => fake()->words(2, true),
                'description' => fake()->paragraph(),
                'uses' => fake()->paragraph(),
            ]);
        });
    }

    /**
     * Indicate that the plant has a specific category.
     */
    public function forCategory(PlantCategory $category)
    {
        return $this->state(fn (array $attributes) => [
            'plant_category_id' => $category->id,
        ]);
    }

    /**
     * Indicate that the plant has images.
     */
    public function withImages()
    {
        return $this->state(fn (array $attributes) => [
            'image_urls' => json_encode([
                '/storage/plants/sample/image1.jpg',
                '/storage/plants/sample/image2.jpg',
            ]),
        ]);
    }
} 