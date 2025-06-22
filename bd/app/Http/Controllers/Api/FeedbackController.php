<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use App\Models\Plant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class FeedbackController extends Controller
{
    // POST /api/feedback
    public function store(Request $request)
    {
        $validated = $request->validate([
            'plant_id' => ['required', 'exists:plants,id'],
            'is_correct' => ['required', 'boolean'],
            'comment' => ['nullable', 'string', 'max:1000'],
        ]);

        // Create feedback (user_id is optional)
        $feedback = Feedback::create([
            'user_id' => $request->user()->id,
            'plant_id' => $validated['plant_id'],
            'is_correct' => $validated['is_correct'],
            'comment' => $validated['comment'],
        ]);

        return response()->json($feedback, 201);
    }

    // GET /api/feedback
    public function index(Request $request)
    {
        $query = Feedback::with('plant');

        // Filter by user if authenticated
        if ($request->user()) {
            $query->where('user_id', $request->user()->id);
        }

        // Filter by correctness
        if ($request->has('is_correct')) {
            $query->where('is_correct', $request->boolean('is_correct'));
        }

        // Filter by plant
        if ($request->has('plant_id')) {
            $query->where('plant_id', $request->plant_id);
        }

        // Get paginated results
        $feedback = $query->latest()->paginate(15);

        // Load translations for each plant
        $feedback->getCollection()->transform(function ($item) use ($request) {
            $item->plant->translation = $this->getPlantTranslation(
                $item->plant->slug,
                $request->lang ?? 'en'
            );
            return $item;
        });

        return response()->json($feedback);
    }

    // GET /api/feedback/stats
    public function stats(Request $request)
    {
        $stats = [
            'total' => Feedback::count(),
            'correct' => Feedback::where('is_correct', true)->count(),
            'incorrect' => Feedback::where('is_correct', false)->count(),
            'with_comments' => Feedback::whereNotNull('comment')->count(),
        ];

        // Add per-plant stats if plant_id is provided
        if ($request->has('plant_id')) {
            $plantId = $request->plant_id;
            $stats['plant'] = [
                'total' => Feedback::where('plant_id', $plantId)->count(),
                'correct' => Feedback::where('plant_id', $plantId)
                    ->where('is_correct', true)
                    ->count(),
                'incorrect' => Feedback::where('plant_id', $plantId)
                    ->where('is_correct', false)
                    ->count(),
                'with_comments' => Feedback::where('plant_id', $plantId)
                    ->whereNotNull('comment')
                    ->count(),
            ];
        }

        return response()->json($stats);
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
