<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PlantCategory;
use Illuminate\Http\Request;
use App\Http\Requests\StorePlantCategoryRequest;

class PlantCategoryController extends Controller
{
    public function index()
    {
        return response()->json(['data' => PlantCategory::all(['id', 'name'])]);
    }

    public function store(StorePlantCategoryRequest $request)
    {
        $category = PlantCategory::create($request->validated());
        return response()->json(['data' => $category], 201);
    }

    public function show(PlantCategory $plantCategory)
    {
        return response()->json(['data' => $plantCategory]);
    }

    public function update(StorePlantCategoryRequest $request, PlantCategory $plantCategory)
    {
        $plantCategory->update($request->validated());
        return response()->json(['data' => $plantCategory]);
    }

    public function destroy(PlantCategory $plantCategory)
    {
        $plantCategory->delete();
        return response()->json(null, 204);
    }
} 