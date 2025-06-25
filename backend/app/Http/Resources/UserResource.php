<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id'   => $this->id,
            'username' => $this->username,
            'email' => $this->email,
            'language_preference' => $this->language_preference,
            'avatar' => $this->avatar,
            'role_id' => $this->roles,
            'roles' => $this->roles,
            'created_at' => $this->created_at->toDateString()
        ];
    }
}
