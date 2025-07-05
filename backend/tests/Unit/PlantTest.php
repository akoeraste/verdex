<?php

namespace Tests\Unit;

use App\Models\Plant;
use App\Models\PlantCategory;
use App\Models\PlantTranslation;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PlantTest extends TestCase
{
    use RefreshDatabase;

    public function test_plant_can_be_created_with_valid_attributes()
    {
        $category = PlantCategory::factory()->create();
        
        $plant = Plant::factory()->create([
            'scientific_name' => 'Rosa canina',
            'plant_category_id' => $category->id,
            'family' => 'Rosaceae',
            'genus' => 'Rosa',
            'species' => 'canina',
            'image_urls' => ['image1.jpg', 'image2.jpg'],
            'toxicity_level' => 'low',
        ]);

        $this->assertDatabaseHas('plants', [
            'scientific_name' => 'Rosa canina',
            'plant_category_id' => $category->id,
            'family' => 'Rosaceae',
            'genus' => 'Rosa',
            'species' => 'canina',
            'toxicity_level' => 'low',
        ]);
    }

    public function test_plant_has_fillable_attributes()
    {
        $plant = new Plant();
        $fillable = $plant->getFillable();

        $this->assertContains('scientific_name', $fillable);
        $this->assertContains('plant_category_id', $fillable);
        $this->assertContains('family', $fillable);
        $this->assertContains('genus', $fillable);
        $this->assertContains('species', $fillable);
        $this->assertContains('image_urls', $fillable);
        $this->assertContains('toxicity_level', $fillable);
    }

    public function test_plant_has_correct_casts()
    {
        $plant = new Plant();
        $casts = $plant->getCasts();

        $this->assertEquals('array', $casts['image_urls']);
    }

    public function test_plant_belongs_to_plant_category()
    {
        $category = PlantCategory::factory()->create();
        $plant = Plant::factory()->create([
            'plant_category_id' => $category->id,
        ]);

        $this->assertInstanceOf(PlantCategory::class, $plant->plantCategory);
        $this->assertEquals($category->id, $plant->plantCategory->id);
    }

    public function test_plant_has_many_translations()
    {
        $plant = Plant::factory()->create();
        $this->assertCount(1, $plant->translations);

        $translation1 = PlantTranslation::factory()->create([
            'plant_id' => $plant->id,
        ]);
        $translation2 = PlantTranslation::factory()->create([
            'plant_id' => $plant->id,
        ]);

        // Refresh the plant model to reload the relationship
        $plant->refresh();
        $this->assertCount(3, $plant->translations);
        $this->assertTrue($plant->translations->contains($translation1));
        $this->assertTrue($plant->translations->contains($translation2));
    }

    public function test_plant_has_required_methods()
    {
        $plant = Plant::factory()->create();
        
        // Test that plant has the required methods
        $this->assertTrue(method_exists($plant, 'plantCategory'));
        $this->assertTrue(method_exists($plant, 'translations'));
        $this->assertTrue(method_exists($plant, 'getActivitylogOptions'));
    }

    public function test_plant_image_urls_are_stored_as_array()
    {
        $plant = Plant::factory()->create([
            'image_urls' => ['image1.jpg', 'image2.jpg', 'image3.jpg'],
        ]);

        $this->assertIsArray($plant->image_urls);
        $this->assertCount(3, $plant->image_urls);
        $this->assertContains('image1.jpg', $plant->image_urls);
    }
} 