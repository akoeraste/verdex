<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Favorite;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $favorites = Favorite::where('user_id', $user->id)->pluck('plant_id');
        return response()->json(['data' => $favorites]);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $plantId = $request->input('plant_id');
        $favorite = Favorite::firstOrCreate([
            'user_id' => $user->id,
            'plant_id' => $plantId,
        ]);
        return response()->json(['success' => true, 'data' => $favorite]);
    }

    public function destroy(Request $request, $plant_id)
    {
        $user = $request->user();
        Favorite::where('user_id', $user->id)->where('plant_id', $plant_id)->delete();
        return response()->json(['success' => true]);
    }

    public function show(Request $request, $plant_id)
    {
        $user = $request->user();
        $isFavorite = Favorite::where('user_id', $user->id)->where('plant_id', $plant_id)->exists();
        return response()->json(['is_favorite' => $isFavorite]);
    }
} 