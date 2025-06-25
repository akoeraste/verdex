<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePlantRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        $plantId = $this->route('plant') ? $this->route('plant')->id : null;
        
        // Debug logging
        \Log::info('UpdatePlantRequest validation', [
            'plant_id' => $plantId,
            'scientific_name' => $this->input('scientific_name'),
            'plant_category_id' => $this->input('plant_category_id'),
            'translations' => $this->input('translations'),
            'images_count' => $this->hasFile('images') ? count($this->file('images')) : 0
        ]);
        
        return [
            'scientific_name' => 'required|string',
            'plant_category_id' => 'required|exists:plant_categories,id',
            'family' => 'nullable|string|max:255',
            'genus' => 'nullable|string|max:255',
            'species' => 'nullable|string|max:255',
            'toxicity_level' => 'nullable|string|max:50',
            'images.*' => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048',
            'translations' => 'required|array|min:1',
            'translations.*.language_code' => 'required|exists:languages,code',
            'translations.*.common_name' => 'required|string|max:255',
            'translations.*.description' => 'required|string',
            'translations.*.uses' => 'required|string',
            'translations.*.audio_file' => 'nullable|file|mimes:mp3,wav,ogg|max:10240', // 10MB max for audio
        ];
    }

    public function messages()
    {
        return [
            'scientific_name.required' => 'Scientific name is required.',
            'scientific_name.unique' => 'This scientific name already exists.',
            'plant_category_id.required' => 'Plant category is required.',
            'plant_category_id.exists' => 'Selected plant category is invalid.',
            'images.*.image' => 'Each file must be an image.',
            'images.*.mimes' => 'Images must be JPEG, PNG, or WebP format.',
            'images.*.max' => 'Each image must be less than 2MB.',
            'translations.required' => 'At least one translation is required.',
            'translations.min' => 'At least one translation is required.',
            'translations.*.language_code.required' => 'Language is required.',
            'translations.*.language_code.exists' => 'Selected language is invalid.',
            'translations.*.common_name.required' => 'Common name is required.',
            'translations.*.description.required' => 'Description is required.',
            'translations.*.uses.required' => 'Uses information is required.',
        ];
    }
} 