<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePlantRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'scientific_name' => 'required|string|unique:plants,scientific_name',
            'plant_category_id' => 'required|exists:plant_categories,id',
            'image' => 'nullable|image',
            'translations' => 'required|array|min:1',
            'translations.*.language_code' => 'required|exists:languages,code',
            'translations.*.common_name' => 'required|string',
            'translations.*.description' => 'required|string',
            'translations.*.uses' => 'required|string',
            'translations.*.audio_url' => 'nullable|file|mimes:mp3,wav',
        ];
    }
} 