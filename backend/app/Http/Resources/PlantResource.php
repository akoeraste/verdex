<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PlantResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'scientific_name' => $this->scientific_name,
            'plant_category' => $this->plantCategory,
            'image_url' => $this->image_url,
            'translations' => PlantTranslationResource::collection($this->translations),
            'created_at' => $this->created_at->toDateString(),
        ];
    }
} 