<?php

namespace Tests\Feature;

use App\Models\Plant;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class FavoriteTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $plant;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->plant = Plant::factory()->create();
        $this->token = $this->user->createToken('test-token')->plainTextToken;
    }

    public function test_user_can_add_favorite()
    {
        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/favorites', [
                'plant_id' => $this->plant->id
            ]);

        $response->assertStatus(201)
            ->assertJson([
                'message' => 'Plant added to favorites'
            ]);

        $this->assertDatabaseHas('favorites', [
            'user_id' => $this->user->id,
            'plant_id' => $this->plant->id
        ]);
    }

    public function test_user_can_remove_favorite()
    {
        // First add a favorite
        $this->user->favorites()->create(['plant_id' => $this->plant->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->deleteJson('/api/favorites/' . $this->plant->id);

        $response->assertStatus(200)
            ->assertJson([
                'message' => 'Plant removed from favorites'
            ]);

        $this->assertDatabaseMissing('favorites', [
            'user_id' => $this->user->id,
            'plant_id' => $this->plant->id
        ]);
    }

    public function test_user_can_list_favorites()
    {
        // Add some favorites
        $plants = Plant::factory()->count(3)->create();
        foreach ($plants as $plant) {
            $this->user->favorites()->create(['plant_id' => $plant->id]);
        }

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->getJson('/api/favorites');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'plant' => [
                            'id',
                            'slug',
                            'scientific_name',
                            'family',
                            'image_urls'
                        ],
                        'created_at'
                    ]
                ],
                'meta' => [
                    'current_page',
                    'from',
                    'last_page',
                    'per_page',
                    'to',
                    'total'
                ]
            ])
            ->assertJsonCount(3, 'data');
    }

    public function test_user_can_check_favorite_status()
    {
        // Add a favorite
        $this->user->favorites()->create(['plant_id' => $this->plant->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->getJson('/api/favorites/check/' . $this->plant->id);

        $response->assertStatus(200)
            ->assertJson([
                'is_favorite' => true
            ]);
    }

    public function test_cannot_add_duplicate_favorite()
    {
        // First add a favorite
        $this->user->favorites()->create(['plant_id' => $this->plant->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/favorites', [
                'plant_id' => $this->plant->id
            ]);

        $response->assertStatus(422)
            ->assertJson([
                'message' => 'Plant is already in favorites'
            ]);
    }

    public function test_cannot_add_favorite_without_authentication()
    {
        $response = $this->postJson('/api/favorites', [
            'plant_id' => $this->plant->id
        ]);

        $response->assertStatus(401);
    }

    public function test_cannot_add_favorite_for_nonexistent_plant()
    {
        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/favorites', [
                'plant_id' => 99999
            ]);

        $response->assertStatus(404);
    }
}
