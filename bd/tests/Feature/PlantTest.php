<?php

namespace Tests\Feature;

use App\Models\Plant;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class PlantTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create some test plants
        Plant::factory()->create([
            'slug' => 'neem',
            'scientific_name' => 'Azadirachta indica',
            'family' => 'Meliaceae',
            'uses' => ['Medicinal', 'Ornamental']
        ]);

        Plant::factory()->create([
            'slug' => 'hibiscus',
            'scientific_name' => 'Hibiscus rosa-sinensis',
            'family' => 'Malvaceae',
            'uses' => ['Ornamental']
        ]);
    }

    public function test_can_list_plants()
    {
        $response = $this->getJson('/api/plants');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'slug',
                        'scientific_name',
                        'family',
                        'genus',
                        'species',
                        'origin',
                        'image_urls',
                        'habitat',
                        'uses',
                        'toxicity_level',
                        'created_at',
                        'updated_at'
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
            ]);
    }

    public function test_can_search_plants()
    {
        $response = $this->getJson('/api/plants?search=neem');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.scientific_name', 'Azadirachta indica');
    }

    public function test_can_filter_plants_by_family()
    {
        $response = $this->getJson('/api/plants?family=Meliaceae');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.family', 'Meliaceae');
    }

    public function test_can_get_plant_details()
    {
        $response = $this->getJson('/api/plants/neem?lang=en');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'id',
                'slug',
                'scientific_name',
                'family',
                'genus',
                'species',
                'origin',
                'image_urls',
                'habitat',
                'uses',
                'toxicity_level',
                'translation' => [
                    'common_name',
                    'description',
                    'audio'
                ],
                'created_at',
                'updated_at'
            ]);
    }

    public function test_can_get_plant_families()
    {
        $response = $this->getJson('/api/plants/families');

        $response->assertStatus(200)
            ->assertJson([
                'Meliaceae',
                'Malvaceae'
            ]);
    }

    public function test_can_get_toxicity_levels()
    {
        $response = $this->getJson('/api/plants/toxicity-levels');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'levels'
            ]);
    }

    public function test_returns_404_for_nonexistent_plant()
    {
        $response = $this->getJson('/api/plants/nonexistent');

        $response->assertStatus(404);
    }

    public function test_returns_404_for_invalid_language()
    {
        $response = $this->getJson('/api/plants/neem?lang=invalid');

        $response->assertStatus(404);
    }

    public function test_can_filter_plants_by_uses()
    {
        $response = $this->getJson('/api/plants?uses=Medicinal');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.uses', ['Medicinal', 'Ornamental']);
    }
}
