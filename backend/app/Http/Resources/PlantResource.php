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
            'plant_category_id' => $this->plant_category_id,
            'plant_category' => $this->plantCategory,
            'family' => $this->family,
            'genus' => $this->genus,
            'species' => $this->species,
            'toxicity_level' => $this->toxicity_level,
            'image_urls' => json_decode($this->image_urls) ?? [],
            'translations' => PlantTranslationResource::collection($this->translations),
            'created_at' => $this->created_at->toDateString(),
            'updated_at' => $this->updated_at->toDateString(),
        ];
    }
} 