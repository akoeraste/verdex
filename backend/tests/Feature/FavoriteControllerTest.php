<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Plant;
use App\Models\Favorite;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FavoriteControllerTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create();
        $this->token = $this->user->createToken('test-token')->plainTextToken;
    }

    public function test_user_can_get_their_favorites()
    {
        $plant1 = Plant::factory()->create();
        $plant2 = Plant::factory()->create();
        
        Favorite::factory()->create([
            'user_id' => $this->user->id,
            'plant_id' => $plant1->id,
        ]);
        Favorite::factory()->create([
            'user_id' => $this->user->id,
            'plant_id' => $plant2->id,
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/favorites');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data'
            ]);

        $this->assertCount(2, $response->json('data'));
    }

    public function test_user_can_add_plant_to_favorites()
    {
        $plant = Plant::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/favorites', [
            'plant_id' => $plant->id,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'user_id' => $this->user->id,
                    'plant_id' => $plant->id,
                ]
            ]);

        $this->assertDatabaseHas('favorites', [
            'user_id' => $this->user->id,
            'plant_id' => $plant->id,
        ]);
    }

    public function test_user_can_add_same_plant_to_favorites_twice()
    {
        $plant = Plant::factory()->create();
        
        // Add plant to favorites first time
        $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/favorites', [
            'plant_id' => $plant->id,
        ]);

        // Add the same plant again (should not create duplicate)
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/favorites', [
            'plant_id' => $plant->id,
        ]);

        $response->assertStatus(200)
            ->assertJson(['success' => true]);

        // Should only have one favorite record
        $this->assertDatabaseCount('favorites', 1);
    }

    public function test_user_can_remove_plant_from_favorites()
    {
        $plant = Plant::factory()->create();
        $favorite = Favorite::factory()->create([
            'user_id' => $this->user->id,
            'plant_id' => $plant->id,
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->deleteJson("/api/favorites/{$plant->id}");

        $response->assertStatus(200)
            ->assertJson(['success' => true]);

        $this->assertDatabaseMissing('favorites', [
            'id' => $favorite->id,
        ]);
    }

    public function test_user_can_check_if_plant_is_favorited()
    {
        $plant = Plant::factory()->create();
        Favorite::factory()->create([
            'user_id' => $this->user->id,
            'plant_id' => $plant->id,
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/favorites/{$plant->id}");

        $response->assertStatus(200)
            ->assertJson([
                'is_favorite' => true,
            ]);
    }

    public function test_user_can_check_if_plant_is_not_favorited()
    {
        $plant = Plant::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/favorites/{$plant->id}");

        $response->assertStatus(200)
            ->assertJson([
                'is_favorite' => false,
            ]);
    }

    public function test_user_can_remove_nonexistent_favorite()
    {
        $plant = Plant::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->deleteJson("/api/favorites/{$plant->id}");

        $response->assertStatus(200)
            ->assertJson(['success' => true]);
    }

    public function test_user_cannot_add_nonexistent_plant_to_favorites()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/favorites', [
            'plant_id' => 99999,
        ]);

        $response->assertStatus(500);
    }

    public function test_unauthenticated_user_cannot_access_favorites()
    {
        $plant = Plant::factory()->create();

        // Try to get favorites
        $response = $this->getJson('/api/favorites');
        $response->assertStatus(401);

        // Try to add favorite
        $response = $this->postJson('/api/favorites', [
            'plant_id' => $plant->id,
        ]);
        $response->assertStatus(401);

        // Try to remove favorite
        $response = $this->deleteJson("/api/favorites/{$plant->id}");
        $response->assertStatus(401);

        // Try to check favorite status
        $response = $this->getJson("/api/favorites/{$plant->id}");
        $response->assertStatus(401);
    }

    public function test_favorites_validation_works_correctly()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/favorites', [
            'plant_id' => '', // Invalid
        ]);

        $response->assertStatus(500);
    }
} 