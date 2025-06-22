<?php

namespace Database\Factories;

use App\Models\Plant;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Plant>
 */
class PlantFactory extends Factory
{
    protected $model = Plant::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $scientificName = $this->faker->unique()->words(2, true);
        return [
            'scientific_name' => $scientificName,
            'common_name' => $this->faker->words(2, true),
            'family' => $this->faker->randomElement(['Meliaceae', 'Rosaceae', 'Lamiaceae', 'Asteraceae']),
            'description' => $this->faker->paragraph,
            'uses' => $this->faker->randomElements(['Medicinal', 'Ornamental', 'Culinary', 'Industrial'], 2),
            'toxicity_level' => $this->faker->randomElement(['None', 'Low', 'Moderate', 'High']),
            'image_urls' => [$this->faker->imageUrl(), $this->faker->imageUrl()],
            'slug' => str_replace(' ', '-', strtolower($scientificName)),
        ];
    }
}
