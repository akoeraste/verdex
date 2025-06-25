<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePlantCategoryRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $plantCategoryId = $this->route('plantCategory')?->id;
        return [
            'name' => ['required', 'string', 'max:255', 'unique:plant_categories,name' . ($plantCategoryId ? ',' . $plantCategoryId : '')],
        ];
    }
} 