<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
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

        $plants = $query->paginate(50);
        return PlantResource::collection($plants);
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
            
            return new PlantResource($freshPlant);
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
        return new PlantResource($plant->load(['plantCategory', 'translations']));
    }

    public function update(UpdatePlantRequest $request, Plant $plant)
    {
        // Debug logging
        \Log::info('PlantController update method', [
            'plant_id' => $plant->id,
            'request_data' => $request->all(),
            'scientific_name' => $request->input('scientific_name'),
            'plant_category_id' => $request->input('plant_category_id'),
            'translations' => $request->input('translations'),
            'has_images' => $request->hasFile('images'),
            'image_count' => $request->hasFile('images') ? count($request->file('images')) : 0
        ]);

        DB::beginTransaction();
        try {
            $plant->update($request->only([
                'scientific_name', 
                'plant_category_id', 
                'family', 
                'genus', 
                'species', 
                'toxicity_level'
            ]));

            // Create plant-specific folder name (sanitized)
            $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
            $plantFolderName = trim($plantFolderName, '_');

            // Handle multiple image uploads (add new ones)
            if ($request->hasFile('images')) {
                \Log::info('Processing new images for update...');
                $existingImageUrls = $plant->image_urls ? json_decode($plant->image_urls, true) : [];
                $newImageUrls = [];
                
                foreach ($request->file('images') as $index => $image) {
                    \Log::info("Processing new image {$index}:", [
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
                    $newImageUrls[] = $imageUrl;
                    
                    \Log::info("New image saved:", ['path' => $imagePath, 'url' => $imageUrl]);
                }
                
                // Combine existing and new image URLs
                $allImageUrls = array_merge($existingImageUrls, $newImageUrls);
                $plant->update(['image_urls' => json_encode($allImageUrls)]);
                \Log::info("Plant updated with combined image URLs:", ['image_urls' => $allImageUrls]);
            }

            // Handle translations (delete old, add new)
            $plant->translations()->delete();
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
                }

                $translationModel = $plant->translations()->create($translationData);
                \Log::info("Translation created with ID:", ['translation_id' => $translationModel->id]);
            }
            
            DB::commit();
            \Log::info('=== PLANT UPDATE REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            \Log::info('Final updated plant data:', [
                'id' => $freshPlant->id,
                'scientific_name' => $freshPlant->scientific_name,
                'translations_count' => $freshPlant->translations->count(),
                'image_urls' => $freshPlant->image_urls
            ]);
            
            return new PlantResource($freshPlant);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Plant update failed', [
                'plant_id' => $plant->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function destroy(Plant $plant)
    {
        $plant->delete();
        return response()->noContent();
    }

    // Get plant categories for dropdown
    public function getCategories()
    {
        $categories = PlantCategory::all();
        return response()->json($categories);
    }

    // Get languages for dropdown
    public function getLanguages()
    {
        $languages = \App\Models\Language::all();
        return response()->json($languages);
    }

    // Update plant translations
    public function updateTranslations(Request $request, Plant $plant)
    {
        \Log::info('=== UPDATE TRANSLATIONS REQUEST START ===');
        \Log::info('Plant ID:', ['id' => $plant->id]);
        \Log::info('Plant scientific name:', ['scientific_name' => $plant->scientific_name]);
        \Log::info('Request all data:', $request->all());
        \Log::info('Request files:', $request->allFiles());

        DB::beginTransaction();
        try {
            // Create plant-specific folder name (sanitized)
            $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
            $plantFolderName = trim($plantFolderName, '_');
            \Log::info('Plant folder name:', ['folder_name' => $plantFolderName]);

            // Get translations from request - handle both array and form data formats
            $translations = [];
            if ($request->has('translations')) {
                if (is_array($request->translations)) {
                    $translations = $request->translations;
                } else {
                    // Handle form data format: translations[0][language_code], translations[0][common_name], etc.
                    $allData = $request->all();
                    $translationIndexes = [];
                    
                    // Extract translation indexes from form data
                    foreach ($allData as $key => $value) {
                        if (preg_match('/^translations\[(\d+)\]\[(\w+)\]$/', $key, $matches)) {
                            $index = $matches[1];
                            $field = $matches[2];
                            if (!isset($translationIndexes[$index])) {
                                $translationIndexes[$index] = [];
                            }
                            $translationIndexes[$index][$field] = $value;
                        }
                    }
                    
                    // Convert to array format
                    foreach ($translationIndexes as $index => $translationData) {
                        $translations[] = $translationData;
                    }
                }
            }

            \Log::info('Processed translations:', ['count' => count($translations), 'translations' => $translations]);

            // Get existing translations to preserve audio URLs
            $existingTranslations = $plant->translations()->get()->keyBy('language_code');
            \Log::info('Existing translations:', $existingTranslations->toArray());

            // Process each translation - update existing or create new
            foreach ($translations as $index => $translationData) {
                \Log::info("Processing translation {$index}:", $translationData);
                
                $languageCode = $translationData['language_code'];
                $existingTranslation = $existingTranslations->get($languageCode);
                
                // Prepare update/create data
                $translationDataToSave = [
                    'plant_id' => $plant->id,
                    'language_code' => $languageCode,
                    'common_name' => $translationData['common_name'],
                    'description' => $translationData['description'],
                    'uses' => $translationData['uses'],
                ];

                // Handle audio file upload for this translation
                if ($request->hasFile("translations.{$index}.audio_file")) {
                    \Log::info("Processing new audio file for translation {$index}");
                    $audioFile = $request->file("translations.{$index}.audio_file");
                    \Log::info("Audio file details:", [
                        'original_name' => $audioFile->getClientOriginalName(),
                        'size' => $audioFile->getSize(),
                        'mime_type' => $audioFile->getMimeType()
                    ]);
                    
                    // Generate unique audio filename
                    $audioExtension = $audioFile->getClientOriginalExtension();
                    $audioFilename = $plantFolderName . '_' . $languageCode . '_' . time() . '.' . $audioExtension;
                    
                    // Store in plant-specific audio folder
                    $audioPath = $audioFile->storeAs("plants/{$plantFolderName}/audio", $audioFilename, 'public');
                    $audioUrl = '/storage/' . $audioPath;
                    
                    $translationDataToSave['audio_url'] = $audioUrl;
                    
                    \Log::info("New audio saved:", ['path' => $audioPath, 'url' => $audioUrl]);
                } else {
                    // Preserve existing audio URL if no new file uploaded
                    if ($existingTranslation && $existingTranslation->audio_url) {
                        $translationDataToSave['audio_url'] = $existingTranslation->audio_url;
                        \Log::info("Preserving existing audio URL:", ['url' => $existingTranslation->audio_url]);
                    } else {
                        \Log::info("No audio file for translation {$index} and no existing audio");
                    }
                }

                // Update existing translation or create new one
                if ($existingTranslation) {
                    \Log::info("Updating existing translation:", ['id' => $existingTranslation->id, 'language' => $languageCode]);
                    $existingTranslation->update($translationDataToSave);
                    $translation = $existingTranslation;
                } else {
                    \Log::info("Creating new translation for language:", $languageCode);
                    $translation = PlantTranslation::create($translationDataToSave);
                }

                \Log::info("Translation processed:", ['id' => $translation->id, 'language' => $translation->language_code]);
            }
            
            DB::commit();
            \Log::info('=== UPDATE TRANSLATIONS REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            \Log::info('Final updated plant data:', [
                'id' => $freshPlant->id,
                'scientific_name' => $freshPlant->scientific_name,
                'translations_count' => $freshPlant->translations->count(),
                'translations' => $freshPlant->translations->toArray()
            ]);
            return new PlantResource($freshPlant);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('=== UPDATE TRANSLATIONS REQUEST FAILED ===');
            \Log::error('Error:', ['message' => $e->getMessage()]);
            \Log::error('Stack trace:', ['trace' => $e->getTraceAsString()]);
            return response()->json([
                'error' => 'Failed to update translations',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // Store individual translation
    public function storeTranslation(Request $request, Plant $plant)
    {
        \Log::info('=== STORE INDIVIDUAL TRANSLATION REQUEST START ===');
        \Log::info('Plant ID:', ['id' => $plant->id]);
        \Log::info('Request data:', $request->all());
        \Log::info('Request files:', $request->allFiles());

        DB::beginTransaction();
        try {
            // Validate request
            $request->validate([
                'language_code' => 'required|exists:languages,code',
                'common_name' => 'required|string|max:255',
                'description' => 'required|string',
                'uses' => 'required|string',
                'audio_file' => 'nullable|file|mimes:mp3,wav,ogg|max:10240',
            ]);

            // Check if translation already exists for this language
            $existingTranslation = $plant->translations()->where('language_code', $request->language_code)->first();
            if ($existingTranslation) {
                return response()->json([
                    'error' => 'Translation for this language already exists',
                    'details' => 'Use update instead of create'
                ], 409);
            }

            // Create plant-specific folder name
            $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
            $plantFolderName = trim($plantFolderName, '_');

            // Prepare translation data
            $translationData = [
                'plant_id' => $plant->id,
                'language_code' => $request->language_code,
                'common_name' => $request->common_name,
                'description' => $request->description,
                'uses' => $request->uses,
            ];

            // Handle audio file upload
            if ($request->hasFile('audio_file')) {
                \Log::info('Processing audio file for new translation');
                $audioFile = $request->file('audio_file');
                
                // Generate unique audio filename
                $audioExtension = $audioFile->getClientOriginalExtension();
                $audioFilename = $plantFolderName . '_' . $request->language_code . '_' . time() . '.' . $audioExtension;
                
                // Store in plant-specific audio folder
                $audioPath = $audioFile->storeAs("plants/{$plantFolderName}/audio", $audioFilename, 'public');
                $audioUrl = '/storage/' . $audioPath;
                
                $translationData['audio_url'] = $audioUrl;
                
                \Log::info("Audio saved:", ['path' => $audioPath, 'url' => $audioUrl]);
            }

            // Create translation
            $translation = PlantTranslation::create($translationData);
            \Log::info("Translation created:", ['id' => $translation->id, 'language' => $translation->language_code]);
            
            DB::commit();
            \Log::info('=== STORE INDIVIDUAL TRANSLATION REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            return new PlantResource($freshPlant);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('=== STORE INDIVIDUAL TRANSLATION REQUEST FAILED ===');
            \Log::error('Error:', ['message' => $e->getMessage()]);
            \Log::error('Stack trace:', ['trace' => $e->getTraceAsString()]);
            return response()->json([
                'error' => 'Failed to create translation',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // Update individual translation
    public function updateTranslation(Request $request, Plant $plant, PlantTranslation $translation)
    {
        \Log::info('=== UPDATE INDIVIDUAL TRANSLATION REQUEST START ===');
        \Log::info('Plant ID:', ['id' => $plant->id]);
        \Log::info('Translation ID:', ['id' => $translation->id]);
        \Log::info('Request data:', $request->all());
        \Log::info('Request files:', $request->allFiles());

        DB::beginTransaction();
        try {
            // Validate request
            $request->validate([
                'common_name' => 'required|string|max:255',
                'description' => 'required|string',
                'uses' => 'required|string',
                'audio_file' => 'nullable|file|mimes:mp3,wav,ogg|max:10240',
            ]);

            // Verify translation belongs to plant
            if ($translation->plant_id !== $plant->id) {
                return response()->json([
                    'error' => 'Translation does not belong to this plant'
                ], 403);
            }

            // Create plant-specific folder name
            $plantFolderName = strtolower(preg_replace('/[^a-zA-Z0-9]+/', '_', $plant->scientific_name));
            $plantFolderName = trim($plantFolderName, '_');

            // Prepare update data
            $updateData = [
                'common_name' => $request->common_name,
                'description' => $request->description,
                'uses' => $request->uses,
            ];

            // Handle audio file upload
            if ($request->hasFile('audio_file')) {
                \Log::info('Processing new audio file for translation');
                $audioFile = $request->file('audio_file');
                
                // Generate unique audio filename
                $audioExtension = $audioFile->getClientOriginalExtension();
                $audioFilename = $plantFolderName . '_' . $translation->language_code . '_' . time() . '.' . $audioExtension;
                
                // Store in plant-specific audio folder
                $audioPath = $audioFile->storeAs("plants/{$plantFolderName}/audio", $audioFilename, 'public');
                $audioUrl = '/storage/' . $audioPath;
                
                $updateData['audio_url'] = $audioUrl;
                
                \Log::info("New audio saved:", ['path' => $audioPath, 'url' => $audioUrl]);
            }

            // Update translation
            $translation->update($updateData);
            \Log::info("Translation updated:", ['id' => $translation->id, 'language' => $translation->language_code]);
            
            DB::commit();
            \Log::info('=== UPDATE INDIVIDUAL TRANSLATION REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            return new PlantResource($freshPlant);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('=== UPDATE INDIVIDUAL TRANSLATION REQUEST FAILED ===');
            \Log::error('Error:', ['message' => $e->getMessage()]);
            \Log::error('Stack trace:', ['trace' => $e->getTraceAsString()]);
            return response()->json([
                'error' => 'Failed to update translation',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    // Delete individual translation
    public function destroyTranslation(Plant $plant, PlantTranslation $translation)
    {
        \Log::info('=== DELETE INDIVIDUAL TRANSLATION REQUEST START ===');
        \Log::info('Plant ID:', ['id' => $plant->id]);
        \Log::info('Translation ID:', ['id' => $translation->id]);

        try {
            // Verify translation belongs to plant
            if ($translation->plant_id !== $plant->id) {
                return response()->json([
                    'error' => 'Translation does not belong to this plant'
                ], 403);
            }

            // Delete translation
            $translation->delete();
            \Log::info("Translation deleted:", ['id' => $translation->id, 'language' => $translation->language_code]);
            
            \Log::info('=== DELETE INDIVIDUAL TRANSLATION REQUEST SUCCESS ===');
            
            $freshPlant = $plant->fresh(['plantCategory', 'translations']);
            return new PlantResource($freshPlant);
        } catch (\Exception $e) {
            \Log::error('=== DELETE INDIVIDUAL TRANSLATION REQUEST FAILED ===');
            \Log::error('Error:', ['message' => $e->getMessage()]);
            \Log::error('Stack trace:', ['trace' => $e->getTraceAsString()]);
            return response()->json([
                'error' => 'Failed to delete translation',
                'details' => $e->getMessage(),
            ], 500);
        }
    }
} 