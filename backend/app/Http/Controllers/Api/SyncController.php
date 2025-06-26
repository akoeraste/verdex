<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Plant;
use App\Models\User;
use App\Models\Post;
use App\Models\Category;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class SyncController extends Controller
{
    public function allDownload()
    {
        $plants = Plant::with(['plantCategory', 'translations'])->get();
        
        $formattedPlants = $plants->map(function ($plant) {
            // Get English translation for common name
            $englishTranslation = $plant->translations->where('language_code', 'en')->first();
            $commonName = $englishTranslation ? $englishTranslation->common_name : $plant->scientific_name;
            
            return [
                'id' => $plant->id,
                'scientific_name' => $plant->scientific_name,
                'name' => $commonName,
                'description' => $englishTranslation ? $englishTranslation->description : '',
                'family' => $plant->family ?? '',
                'category' => $plant->plantCategory ? $plant->plantCategory->name : '',
                'genus' => $plant->genus ?? '',
                'species' => $plant->species ?? '',
                'toxicity_level' => $plant->toxicity_level ?? '',
                'uses' => $englishTranslation ? $englishTranslation->uses : '',
                'tags' => [], // Tags not implemented in backend yet
                'image_url' => $plant->image_urls && count($plant->image_urls) > 0 ? $plant->image_urls[0] : '',
                'created_at' => $plant->created_at,
                'updated_at' => $plant->updated_at,
            ];
        });

        return response()->json([
            'plants' => $formattedPlants,
            'users' => User::all(),
            'posts' => Post::all(),
            'categories' => Category::all(),
            'roles' => Role::all(),
            'permissions' => Permission::all(),
        ]);
    }

    public function allUpload(Request $request)
    {
        $tables = ['plants', 'users', 'posts', 'categories', 'roles', 'permissions'];
        foreach ($tables as $table) {
            $items = $request->input($table, []);
            $modelClass = null;
            switch ($table) {
                case 'plants': $modelClass = Plant::class; break;
                case 'users': $modelClass = User::class; break;
                case 'posts': $modelClass = Post::class; break;
                case 'categories': $modelClass = Category::class; break;
                case 'roles': $modelClass = Role::class; break;
                case 'permissions': $modelClass = Permission::class; break;
            }
            if ($modelClass) {
                foreach ($items as $item) {
                    if ($table === 'plants') {
                        // Special handling for plants
                        $plant = Plant::find($item['id']) ?? new Plant();
                        $plant->id = $item['id'];
                        $plant->scientific_name = $item['scientific_name'] ?? $item['name'] ?? '';
                        $plant->family = $item['family'] ?? '';
                        $plant->genus = $item['genus'] ?? '';
                        $plant->species = $item['species'] ?? '';
                        $plant->toxicity_level = $item['toxicity_level'] ?? '';
                        
                        // Handle category mapping
                        if (isset($item['category']) && $item['category']) {
                            $category = \App\Models\PlantCategory::where('name', $item['category'])->first();
                            $plant->plant_category_id = $category ? $category->id : null;
                        }
                        
                        $plant->save();
                        
                        // Handle translations if provided
                        if (isset($item['description']) || isset($item['uses'])) {
                            $englishTranslation = $plant->translations()->where('language_code', 'en')->first();
                            if ($englishTranslation) {
                                $englishTranslation->update([
                                    'common_name' => $item['name'] ?? $plant->scientific_name,
                                    'description' => $item['description'] ?? $englishTranslation->description,
                                    'uses' => $item['uses'] ?? $englishTranslation->uses,
                                ]);
                            } else {
                                $plant->translations()->create([
                                    'language_code' => 'en',
                                    'common_name' => $item['name'] ?? $plant->scientific_name,
                                    'description' => $item['description'] ?? '',
                                    'uses' => $item['uses'] ?? '',
                                ]);
                            }
                        }
                    } else {
                        // Standard handling for other models
                        $model = $modelClass::find($item['id']) ?? new $modelClass();
                        foreach ($item as $key => $value) {
                            $model->$key = $value;
                        }
                        $model->save();
                    }
                }
            }
        }
        return response()->json(['success' => true]);
    }
} 