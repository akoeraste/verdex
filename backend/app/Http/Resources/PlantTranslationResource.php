<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PlantTranslationResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'language_code' => $this->language_code,
            'common_name' => $this->common_name,
            'description' => $this->description,
            'uses' => $this->uses,
            'audio_url' => $this->audio_url,
        ];
    }
} 