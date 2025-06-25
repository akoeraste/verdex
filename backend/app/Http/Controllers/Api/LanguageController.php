<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Language;
use Illuminate\Http\Request;
use App\Http\Requests\StoreLanguageRequest;
use App\Http\Requests\UpdateLanguageRequest;

class LanguageController extends Controller
{
    public function index()
    {
        return response()->json(['data' => Language::all(['id', 'code', 'name'])]);
    }

    public function store(StoreLanguageRequest $request)
    {
        $language = Language::create($request->validated());
        return response()->json(['data' => $language], 201);
    }

    public function show(Language $language)
    {
        return response()->json(['data' => $language]);
    }

    public function update(UpdateLanguageRequest $request, Language $language)
    {
        $language->update($request->validated());
        return response()->json(['data' => $language]);
    }

    public function destroy(Language $language)
    {
        $language->delete();
        return response()->json(null, 204);
    }
} 