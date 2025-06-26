<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Feedback;
use Illuminate\Support\Facades\Auth;

class FeedbackController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'category' => 'nullable|string',
            'rating' => 'nullable|integer|min:1|max:5',
            'message' => 'nullable|string',
            'contact' => 'nullable|string',
            'plant_id' => 'nullable|exists:plants,id',
            'comment' => 'nullable|string',
        ]);

        $feedback = Feedback::create([
            'user_id' => Auth::id(),
            'category' => $validated['category'] ?? null,
            'rating' => $validated['rating'] ?? null,
            'message' => $validated['message'] ?? null,
            'contact' => $validated['contact'] ?? null,
            'plant_id' => $validated['plant_id'] ?? null,
            'comment' => $validated['comment'] ?? null,
        ]);

        return response()->json(['success' => true, 'data' => $feedback], 201);
    }
} 