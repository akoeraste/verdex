<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateLanguageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $languageId = $this->route('language')->id ?? null;
        return [
            'code' => ['required', 'string', 'max:10', 'unique:languages,code,' . $languageId],
            'name' => ['required', 'string', 'max:255'],
        ];
    }
} 