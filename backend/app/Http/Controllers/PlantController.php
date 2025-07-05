<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePlantRequest;
use App\Http\Requests\UpdatePlantRequest;
use App\Http\Resources\PlantResource;
use App\Models\Plant;
use App\Models\PlantCategory;
use App\Models\PlantTranslation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PlantController extends Controller
{
    public function index(Request $request)
    {
        $query = Plant::with(['plantCategory', 'translations']);

        if ($request->has('search')) {
            $searchTerm = $request->input('search');
            $query->where(function ($q) use ($searchTerm) {
                $q->where('scientific_name', 'like', "%{$searchTerm}%")
                    ->orWhere('family', 'like', "%{$searchTerm}%")
                    ->orWhere('genus', 'like', "%{$searchTerm}%")
                    ->orWhere('species', 'like', "%{$searchTerm}%")
                    ->orWhereHas('translations', function ($translationQuery) use ($searchTerm) {
                        $translationQuery->where('common_name', 'like', "%{$searchTerm}%")
                            ->orWhere('description', 'like', "%{$searchTerm}%")
                            ->orWhere('uses', 'like', "%{$searchTerm}%");
                    });
            });
        }

        $plants = $query->paginate(5);
        return response()->json([
            'data' => PlantResource::collection($plants),
            'current_page' => $plants->currentPage(),
            'last_page' => $plants->lastPage(),
            'per_page' => $plants->perPage(),
            'total' => $plants->total()
        ]);
    }

    public function store(StorePlantRequest $request)
    {
        // Comprehensive debugging
        \Log::info('=== PLANT STORE REQUEST START ===');
        \Log::info('Request all data:', $request->all());
        \Log::info('Files in request:', $request->allFiles());
        \Log::info('Has images:', ['has_images' => $request->hasFile('images')]);
        \Log::info('Image count:', ['count' => $request->hasFile('images') ? count($request->file('images')) : 0]);
        \Log::info('Translations:', $request->input('translations'));
        
        DB::beginTransaction();
        try {
            $plantData = $request->only([
                'scientific_name', 
                'plant_category_id', 
                'family', 
                'genus', 
                'species', 
                'toxicity_level'
            ]);
            
            \Log::info('Plant data to create:', $plantData);
            
            $plant = Plant::create($plantData);
            
            \Log::info('Plant created with ID:', ['id' => $plant->id]);

            // Create plant-specific folder name (sanitized)
            $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
            $plantFolderName = trim($plantFolderName, '_');

            // Handle multiple image uploads
            if ($request->hasFile('images')) {
                \Log::info('Processing images...');
                $imageUrls = [];
                
                foreach ($request->file('images') as $index => $image) {
                    \Log::info("Processing image {$index}:", [
                        'original_name' => $image->getClientOriginalName(),
                        'size' => $image->getSize(),
                        'mime_type' => $image->getMimeType()
                    ]);
                    
                    // Generate unique filename
                    $extension = $image->getClientOriginalExtension();
                    $filename = $plantFolderName . '_' . time() . '_' . $index . '.' . $extension;
                    
                    // Store in plant-specific folder
                    $imagePath = $image->storeAs("plants/{$plantFolderName}/images", $filename, 'public');
                    $imageUrl = '/storage/' . $imagePath;
                    $imageUrls[] = $imageUrl;
                    
                    \Log::info("Image saved:", ['path' => $imagePath, 'url' => $imageUrl]);
                }
                
                // Update plant with image URLs
                $plant->update(['image_urls' => json_encode($imageUrls)]);
                \Log::info("Plant updated with image URLs:", ['image_urls' => $imageUrls]);
            } else {
                \Log::info('No images found in request');
            }

            // Handle translations and audio files
            \Log::info('Processing translations...');
            foreach ($request->translations as $index => $translation) {
                \Log::info("Processing translation {$index}:", $translation);
                
                $translationData = [
                    'language_code' => $translation['language_code'],
                    'common_name' => $translation['common_name'],
                    'description' => $translation['description'],
                    'uses' => $translation['uses'],
                ];

                // Handle audio file upload for this translation
                if ($request->hasFile("translations.{$index}.audio_file")) {
                    \Log::info("Processing audio file for translation {$index}");
                    $audioFile = $request->file("translations.{$index}.audio_file");
                    \Log::info("Audio file details:", [
                        'original_name' => $audioFile->getClientOriginalName(),
                        'size' => $audioFile->getSize(),
                        'mime_type' => $audioFile->getMimeType()
                    ]);
                    
                    // Generate unique audio filename
                    $audioExtension = $audioFile->getClientOriginalExtension();
                    $audioFilename = $plantFolderName . '_' . $translation['language_code'] . '_' . time() . '.' . $audioExtension;
                    
                    // Store in plant-specific audio folder
                    $audioPath = $audioFile->storeAs("plants/{$plantFolderName}/audio", $audioFilename, 'public');
                    $translationData['audio_url'] = '/storage/' . $audioPath;
                    
                    \Log::info("Audio saved:", ['path' => $audioPath, 'url' => $translationData['audio_url']]);
                } else {
                    \Log::info("No audio file for translation {$index}");
                }

                $translationModel = $plant->translations()->create($translationData);
                \Log::info("Translation created with ID:", ['translation_id' => $translationModel->id]);
            }
            
            DB::commit();
            \Log::info('=== PLANT STORE REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            \Log::info('Final plant data:', [
                'id' => $freshPlant->id,
                'scientific_name' => $freshPlant->scientific_name,
                'translations_count' => $freshPlant->translations->count(),
                'image_urls' => $freshPlant->image_urls
            ]);
            
            return response()->json([
                'data' => new PlantResource($freshPlant),
                'message' => 'Plant created successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('=== PLANT STORE REQUEST FAILED ===');
            \Log::error('Error:', ['message' => $e->getMessage()]);
            \Log::error('Stack trace:', ['trace' => $e->getTraceAsString()]);
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function show(Plant $plant)
    {
        return response()->json([
            'data' => new PlantResource($plant->load(['plantCategory', 'translations']))
        ]);
    }

    public function update(UpdatePlantRequest $request, Plant $plant)
    {
        DB::beginTransaction();
        try {
            $plantData = $request->only([
                'scientific_name', 
                'plant_category_id', 
                'family', 
                'genus', 
                'species', 
                'toxicity_level'
            ]);
            
            $plant->update($plantData);

            // Handle image updates if provided
            if ($request->hasFile('images')) {
                $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
                $plantFolderName = trim($plantFolderName, '_');
                
                $imageUrls = [];
                foreach ($request->file('images') as $index => $image) {
                    $extension = $image->getClientOriginalExtension();
                    $filename = $plantFolderName . '_' . time() . '_' . $index . '.' . $extension;
                    $imagePath = $image->storeAs("plants/{$plantFolderName}/images", $filename, 'public');
                    $imageUrls[] = '/storage/' . $imagePath;
                }
                
                $plant->update(['image_urls' => json_encode($imageUrls)]);
            }

            // Handle translation updates
            if ($request->has('translations')) {
                foreach ($request->translations as $translation) {
                    if (isset($translation['id'])) {
                        // Update existing translation
                        $translationModel = $plant->translations()->find($translation['id']);
                        if ($translationModel) {
                            $translationModel->update([
                                'common_name' => $translation['common_name'],
                                'description' => $translation['description'],
                                'uses' => $translation['uses'],
                            ]);
                        }
                    } else {
                        // Create new translation
                        $plant->translations()->create([
                            'language_code' => $translation['language_code'],
                            'common_name' => $translation['common_name'],
                            'description' => $translation['description'],
                            'uses' => $translation['uses'],
                        ]);
                    }
                }
            }
            
            DB::commit();
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            return response()->json([
                'data' => new PlantResource($freshPlant),
                'message' => 'Plant updated successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function destroy(Plant $plant)
    {
        try {
            $plant->delete();
            return response()->json(['message' => 'Plant deleted successfully']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function getCategories()
    {
        $categories = PlantCategory::all();
        return response()->json($categories);
    }

    public function getLanguages()
    {
        $languages = [
            ['code' => 'en', 'name' => 'English'],
            ['code' => 'fr', 'name' => 'French'],
            ['code' => 'pg', 'name' => 'Pidgin']
        ];
        return response()->json($languages);
    }

    public function updateTranslations(Request $request, Plant $plant)
    {
        DB::beginTransaction();
        try {
            foreach ($request->translations as $translation) {
                if (isset($translation['id'])) {
                    // Update existing translation
                    $translationModel = $plant->translations()->find($translation['id']);
                    if ($translationModel) {
                        $translationModel->update([
                            'common_name' => $translation['common_name'],
                            'description' => $translation['description'],
                            'uses' => $translation['uses'],
                        ]);
                    }
                } else {
                    // Create new translation
                    $plant->translations()->create([
                        'language_code' => $translation['language_code'],
                        'common_name' => $translation['common_name'],
                        'description' => $translation['description'],
                        'uses' => $translation['uses'],
                    ]);
                }
            }
            
            DB::commit();
            
            $freshPlant = $plant->fresh(['translations']);
            return response()->json([
                'data' => new PlantResource($freshPlant),
                'message' => 'Translations updated successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
} 