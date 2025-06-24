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
    public function index()
    {
        $plants = Plant::with(['plantCategory', 'translations'])->paginate(50);
        return PlantResource::collection($plants);
    }

    public function store(StorePlantRequest $request)
    {
        DB::beginTransaction();
        try {
            $plant = Plant::create($request->only(['scientific_name', 'plant_category_id', 'image_url']));

            // Handle image upload
            if ($request->hasFile('image')) {
                $plant->addMediaFromRequest('image')->toMediaCollection('images');
                $plant->image_url = $plant->getFirstMediaUrl('images');
                $plant->save();
            }

            // Handle translations
            foreach ($request->translations as $translation) {
                $audioPath = null;
                if (isset($translation['audio_url']) && $translation['audio_url']) {
                    $audio = $translation['audio_url'];
                    $audioPath = $audio->store('plant_audio', 'public');
                }
                $plant->translations()->create([
                    'language_code' => $translation['language_code'],
                    'common_name' => $translation['common_name'],
                    'description' => $translation['description'],
                    'uses' => $translation['uses'],
                    'audio_url' => $audioPath,
                ]);
            }
            DB::commit();
            return new PlantResource($plant->fresh(['plantCategory', 'translations']));
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function show(Plant $plant)
    {
        return new PlantResource($plant->load(['plantCategory', 'translations']));
    }

    public function update(UpdatePlantRequest $request, Plant $plant)
    {
        DB::beginTransaction();
        try {
            $plant->update($request->only(['scientific_name', 'plant_category_id', 'image_url']));

            // Handle image upload
            if ($request->hasFile('image')) {
                $plant->clearMediaCollection('images');
                $plant->addMediaFromRequest('image')->toMediaCollection('images');
                $plant->image_url = $plant->getFirstMediaUrl('images');
                $plant->save();
            }

            // Handle translations (delete old, add new)
            $plant->translations()->delete();
            foreach ($request->translations as $translation) {
                $audioPath = null;
                if (isset($translation['audio_url']) && $translation['audio_url']) {
                    $audio = $translation['audio_url'];
                    $audioPath = $audio->store('plant_audio', 'public');
                }
                $plant->translations()->create([
                    'language_code' => $translation['language_code'],
                    'common_name' => $translation['common_name'],
                    'description' => $translation['description'],
                    'uses' => $translation['uses'],
                    'audio_url' => $audioPath,
                ]);
            }
            DB::commit();
            return new PlantResource($plant->fresh(['plantCategory', 'translations']));
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function destroy(Plant $plant)
    {
        $plant->delete();
        return response()->noContent();
    }
} 