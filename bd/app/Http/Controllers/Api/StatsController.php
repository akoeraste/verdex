<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Plant;
use App\Models\Favorite;
use App\Models\Feedback;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StatsController extends Controller
{
    // GET /api/stats
    public function index(Request $request)
    {
        // Basic counts
        $stats = [
            'users' => [
                'total' => User::count(),
                'verified' => User::whereNotNull('email_verified_at')->count(),
                'with_avatar' => User::whereNotNull('avatar')->count(),
            ],
            'plants' => [
                'total' => Plant::count(),
                'with_audio' => DB::table('audio_files')->distinct('plant_id')->count(),
                'with_images' => Plant::whereNotNull('image_urls')->count(),
            ],
            'favorites' => [
                'total' => Favorite::count(),
                'unique_users' => DB::table('favorites')->distinct('user_id')->count(),
                'unique_plants' => DB::table('favorites')->distinct('plant_id')->count(),
            ],
            'feedback' => [
                'total' => Feedback::count(),
                'correct' => Feedback::where('is_correct', true)->count(),
                'incorrect' => Feedback::where('is_correct', false)->count(),
                'with_comments' => Feedback::whereNotNull('comment')->count(),
            ],
        ];

        // Add user-specific stats if authenticated
        if ($request->user()) {
            $userId = $request->user()->id;
            $stats['user'] = [
                'favorites_count' => Favorite::where('user_id', $userId)->count(),
                'feedback_count' => Feedback::where('user_id', $userId)->count(),
                'correct_identifications' => Feedback::where('user_id', $userId)
                    ->where('is_correct', true)
                    ->count(),
            ];
        }

        // Add language distribution
        $stats['languages'] = [
            'user_preferences' => User::select('language_preference', DB::raw('count(*) as count'))
                ->groupBy('language_preference')
                ->get(),
            'audio_files' => DB::table('audio_files')
                ->select('language', DB::raw('count(*) as count'))
                ->groupBy('language')
                ->get(),
        ];

        // Add recent activity (last 7 days)
        $sevenDaysAgo = now()->subDays(7);
        $stats['recent_activity'] = [
            'new_users' => User::where('created_at', '>=', $sevenDaysAgo)->count(),
            'new_favorites' => Favorite::where('created_at', '>=', $sevenDaysAgo)->count(),
            'new_feedback' => Feedback::where('created_at', '>=', $sevenDaysAgo)->count(),
        ];

        return response()->json($stats);
    }
}
