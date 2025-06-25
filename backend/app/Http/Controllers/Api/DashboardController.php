<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Plant;
use App\Models\User;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function stats(Request $request)
    {
        // In a real app, replace stubs with real queries
        return response()->json([
            'total_plants' => Plant::count(),
            'total_users' => User::count(),
            'total_identifications' => 1024, // stub
            'total_feedback' => 87, // stub
            'identifications_last_7_days' => [12, 19, 14, 20, 16, 22, 18], // stub
            'feedback_overview' => [
                'positive' => 60,
                'negative' => 25,
                'neutral' => 15,
            ],
        ]);
    }
} 