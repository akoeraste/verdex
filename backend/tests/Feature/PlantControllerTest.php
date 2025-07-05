<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Plant;
use App\Models\PlantCategory;
use App\Models\Language;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PlantControllerTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create required seed data
        Language::factory()->create(['code' => 'en', 'name' => 'English']);
        PlantCategory::factory()->create(['name' => 'Herbs']);
        
        $this->user = User::factory()->create();
        $this->token = $this->user->createToken('test-token')->plainTextToken;
    }

    public function test_can_get_all_plants()
    {
        Plant::factory()->count(3)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/plants');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'scientific_name',
                        'family',
                        'genus',
                        'species',
                        'toxicity_level',
                        'created_at',
                        'updated_at',
                    ]
                ]
            ]);

        $this->assertCount(3, $response->json('data'));
    }

    public function test_can_get_single_plant()
    {
        $plant = Plant::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/plants/{$plant->id}");

        $response->assertStatus(200)
            ->assertJson([
                'data' => [
                    'id' => $plant->id,
                    'scientific_name' => $plant->scientific_name,
                    'family' => $plant->family,
                    'genus' => $plant->genus,
                    'species' => $plant->species,
                    'toxicity_level' => $plant->toxicity_level,
                ]
            ]);
    }

    public function test_can_create_plant()
    {
        $category = PlantCategory::factory()->create();
        $language = Language::factory()->create();

        $plantData = [
            'scientific_name' => 'Rosa canina',
            'family' => 'Rosaceae',
            'genus' => 'Rosa',
            'species' => 'canina',
            'toxicity_level' => 'low',
            'plant_category_id' => $category->id,
            'translations' => [
                [
                    'language_code' => $language->code,
                    'common_name' => 'Dog Rose',
                    'description' => 'A wild rose species',
                    'uses' => 'Medicinal and ornamental',
                ]
            ]
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/plants', $plantData);

        $response->assertStatus(200)
            ->assertJson([
                'data' => [
                    'scientific_name' => 'Rosa canina',
                    'family' => 'Rosaceae',
                    'genus' => 'Rosa',
                    'species' => 'canina',
                    'toxicity_level' => 'low',
                ]
            ]);

        $this->assertDatabaseHas('plants', [
            'scientific_name' => 'Rosa canina',
            'family' => 'Rosaceae',
        ]);
    }

    public function test_can_update_plant()
    {
        $plant = Plant::factory()->create();
        $category = PlantCategory::factory()->create();
        $language = Language::factory()->create();

        $updateData = [
            'scientific_name' => 'Updated Rosa canina',
            'family' => 'Updated Rosaceae',
            'genus' => 'Updated Rosa',
            'species' => 'updated_canina',
            'toxicity_level' => 'medium',
            'plant_category_id' => $category->id,
            'translations' => [
                [
                    'language_code' => $language->code,
                    'common_name' => 'Updated Dog Rose',
                    'description' => 'Updated description',
                    'uses' => 'Updated uses',
                ]
            ]
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->putJson("/api/plants/{$plant->id}", $updateData);

        $response->assertStatus(200)
            ->assertJson([
                'data' => [
                    'scientific_name' => 'Updated Rosa canina',
                    'family' => 'Updated Rosaceae',
                    'genus' => 'Updated Rosa',
                    'species' => 'updated_canina',
                    'toxicity_level' => 'medium',
                ]
            ]);
    }

    public function test_can_delete_plant()
    {
        $plant = Plant::factory()->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->deleteJson("/api/plants/{$plant->id}");

        $response->assertStatus(204);

        $this->assertDatabaseMissing('plants', [
            'id' => $plant->id,
        ]);
    }

    public function test_can_get_plant_categories()
    {
        PlantCategory::factory()->count(3)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/plant-categories-list');

        $response->assertStatus(200)
            ->assertJsonStructure([
                '*' => [
                    'id',
                    'name',
                    'created_at',
                    'updated_at',
                ]
            ]);

        // Account for the 1 category created in setUp() + 3 new ones = 4 total
        $this->assertCount(4, $response->json());
    }

    public function test_can_get_languages()
    {
        Language::factory()->count(3)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/languages-list');

        $response->assertStatus(200)
            ->assertJsonStructure([
                '*' => [
                    'id',
                    'code',
                    'name',
                    'created_at',
                    'updated_at',
                ]
            ]);

        // Account for the 1 language created in setUp() + 3 new ones = 4 total
        $this->assertCount(4, $response->json());
    }

    public function test_public_plant_endpoints_work_without_auth()
    {
        Plant::factory()->count(3)->create();

        $response = $this->getJson('/api/plants/app/all');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'scientific_name',
                        'family',
                        'genus',
                        'species',
                        'toxicity_level',
                    ]
                ]
            ]);

        $this->assertCount(3, $response->json('data'));
    }

    public function test_public_plant_search_works_without_auth()
    {
        $plant = Plant::factory()->create(['scientific_name' => 'Rosa canina']);

        $response = $this->getJson('/api/plants/app/search?search=Rosa');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'scientific_name',
                        'family',
                        'genus',
                        'species',
                        'toxicity_level',
                    ]
                ]
            ]);

        $this->assertCount(1, $response->json('data'));
    }
} 