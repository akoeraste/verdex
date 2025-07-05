<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\Plant;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Feedback>
 */
class FeedbackFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'plant_id' => null,
            'category' => fake()->randomElement(['bug', 'feature', 'general']),
            'rating' => fake()->numberBetween(1, 5),
            'message' => fake()->paragraph(),
            'contact' => fake()->email(),
            'comment' => null,
        ];
    }

    /**
     * Indicate that the feedback is for a specific plant.
     */
    public function forPlant(Plant $plant)
    {
        return $this->state(fn (array $attributes) => [
            'plant_id' => $plant->id,
        ]);
    }

    /**
     * Indicate that the feedback has an admin response.
     */
    public function withResponse()
    {
        return $this->state(fn (array $attributes) => [
            'comment' => fake()->paragraph(),
        ]);
    }
} 