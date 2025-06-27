<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Feedback;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\FeedbackResource;
use App\Notifications\FeedbackResponseNotification;
use App\Notifications\FeedbackSubmittedNotification;

class FeedbackController extends Controller
{
    public function store(Request $request)
    {
        \Log::info('Feedback submission: Authorization header', [
            'Authorization' => $request->header('Authorization')
        ]);
        \Log::info('Feedback submission: Auth user', [
            'user' => Auth::user()
        ]);
        $validated = $request->validate([
            'category' => 'nullable|string',
            'rating' => 'nullable|integer|min:1|max:5',
            'message' => 'nullable|string',
            'plant_id' => 'nullable|exists:plants,id',
            'comment' => 'nullable|string',
        ]);

        $user = Auth::user();
        if (!$user) {
            \Log::warning('Feedback submission failed: Auth::user() is null');
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        $feedback = Feedback::create([
            'user_id' => $user->id,
            'category' => $validated['category'] ?? null,
            'rating' => $validated['rating'] ?? null,
            'message' => $validated['message'] ?? null,
            'contact' => $user->email,
            'plant_id' => $validated['plant_id'] ?? null,
            'comment' => $validated['comment'] ?? null,
        ]);

        // Notify the user that their feedback was received
        $user->notify(new FeedbackSubmittedNotification($feedback));

        return response()->json(['success' => true, 'data' => $feedback], 201);
    }

    /**
     * Display a listing of the feedback (Admin only)
     */
    public function index(Request $request)
    {
        $this->authorize('viewAny', Feedback::class);

        $query = Feedback::with(['user', 'plant'])
            ->orderBy('created_at', 'desc');

        // Filter by status
        if ($request->has('status')) {
            if ($request->status === 'pending') {
                $query->whereNull('comment');
            } elseif ($request->status === 'responded') {
                $query->whereNotNull('comment');
            }
        }

        // Filter by category
        if ($request->has('category') && $request->category) {
            $query->where('category', $request->category);
        }

        // Filter by rating
        if ($request->has('rating') && $request->rating) {
            $query->where('rating', $request->rating);
        }

        $feedback = $query->paginate(15);

        return FeedbackResource::collection($feedback);
    }

    /**
     * Display the specified feedback (Admin only)
     */
    public function show(Feedback $feedback)
    {
        $this->authorize('view', $feedback);

        $feedback->load(['user', 'plant']);

        return new FeedbackResource($feedback);
    }

    /**
     * Respond to feedback (Admin only)
     */
    public function respond(Request $request, Feedback $feedback)
    {
        $this->authorize('respond', $feedback);

        $validated = $request->validate([
            'comment' => 'required|string|min:1',
        ]);

        $feedback->update([
            'comment' => $validated['comment'],
        ]);

        // Send notification to the user if they exist
        if ($feedback->user) {
            $feedback->user->notify(new FeedbackResponseNotification($feedback));
        }

        $feedback->load(['user', 'plant']);

        return new FeedbackResource($feedback);
    }

    /**
     * Get feedback statistics (Admin only)
     */
    public function stats()
    {
        $this->authorize('viewAny', Feedback::class);

        $stats = [
            'total' => Feedback::count(),
            'pending' => Feedback::whereNull('comment')->count(),
            'responded' => Feedback::whereNotNull('comment')->count(),
            'average_rating' => round(Feedback::whereNotNull('rating')->avg('rating'), 1),
            'categories' => Feedback::selectRaw('category, COUNT(*) as count')
                ->whereNotNull('category')
                ->groupBy('category')
                ->get(),
            'recent' => Feedback::with(['user'])
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get(),
        ];

        return response()->json($stats);
    }
} 