<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\PlantCategory;

class PlantCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            'Medicinal',
            'Tubers',
            'Grains',
            'Fruits',
            'Vegetables',
            'Spices',
        ];
        foreach ($categories as $name) {
            if (class_exists(PlantCategory::class)) {
                PlantCategory::firstOrCreate(['name' => $name]);
            } else {
                DB::table('plant_categories')->updateOrInsert(['name' => $name]);
            }
        }
    }
} 