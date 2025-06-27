<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FeedbackResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'user' => $this->whenLoaded('user', function () {
                return [
                    'id' => $this->user->id,
                    'name' => $this->user->name,
                    'email' => $this->user->email,
                    'username' => $this->user->username,
                ];
            }),
            'plant_id' => $this->plant_id,
            'plant' => $this->whenLoaded('plant', function () {
                return [
                    'id' => $this->plant->id,
                    'name' => $this->plant->name,
                    'scientific_name' => $this->plant->scientific_name,
                ];
            }),
            'category' => $this->category,
            'rating' => $this->rating,
            'rating_text' => $this->rating_text,
            'message' => $this->message,
            'contact' => $this->contact,
            'comment' => $this->comment,
            'status' => $this->status,
            'is_responded' => $this->isResponded(),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'formatted_created_at' => $this->created_at->diffForHumans(),
            'formatted_updated_at' => $this->updated_at->diffForHumans(),
        ];
    }
} 