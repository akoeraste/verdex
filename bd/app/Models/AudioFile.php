<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class AudioFile extends Model
{
    use HasFactory;

    protected $fillable = [
        'plant_id',
        'language_id',
        'audio_url',
        'description',
    ];

    public function plant()
    {
        return $this->belongsTo(Plant::class);
    }

    public function language()
    {
        return $this->belongsTo(Language::class);
    }
}
