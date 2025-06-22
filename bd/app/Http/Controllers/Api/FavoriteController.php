<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Plant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class FavoriteController extends Controller
{
    // GET /api/favorites
    public function index(Request $request)
    {
        $favorites = $request->user()
            ->favorites()
            ->with('plant')
            ->paginate(15);

        // Load translations for each plant
        $favorites->getCollection()->transform(function ($favorite) use ($request) {
            $favorite->plant->translation = $this->getPlantTranslation(
                $favorite->plant->slug, 
                $request->lang ?? 'en'
            );
            return $favorite;
        });

        return response()->json($favorites);
    }

    // POST /api/favorites
    public function store(Request $request)
    {
        $validated = $request->validate([
            'plant_id' => ['required', 'exists:plants,id'],
        ]);

        // Check if already favorited
        $exists = $request->user()
            ->favorites()
            ->where('plant_id', $validated['plant_id'])
            ->exists();

        if ($exists) {
            return response()->json([
                'message' => 'Plant is already in favorites'
            ], 422);
        }

        $favorite = $request->user()
            ->favorites()
            ->create($validated);

        return response()->json($favorite, 201);
    }

    // DELETE /api/favorites/{plant_id}
    public function destroy(Request $request, $plantId)
    {
        $deleted = $request->user()
            ->favorites()
            ->where('plant_id', $plantId)
            ->delete();

        if (!$deleted) {
            return response()->json([
                'message' => 'Favorite not found'
            ], 404);
        }

        return response()->json(null, 204);
    }

    // GET /api/favorites/check/{plant_id}
    public function check(Request $request, $plantId)
    {
        $isFavorited = $request->user()
            ->favorites()
            ->where('plant_id', $plantId)
            ->exists();

        return response()->json([
            'is_favorited' => $isFavorited
        ]);
    }

    // Helper method to get plant translation
    private function getPlantTranslation($slug, $lang)
    {
        $translationPath = resource_path("lang/{$lang}/plants.json");
        
        if (!File::exists($translationPath)) {
            return null;
        }

        $translations = json_decode(File::get($translationPath), true);
        
        return $translations['plants'][$slug] ?? null;
    }
}
