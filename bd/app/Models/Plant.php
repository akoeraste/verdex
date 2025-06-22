<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Plant extends Model
{
    use HasFactory;

    protected $fillable = [
        'scientific_name',
        'common_name',
        'family',
        'description',
        'uses',
        'toxicity_level',
        'image_urls',
        'slug',
    ];

    protected $casts = [
        'uses' => 'array',
        'image_urls' => 'array',
    ];

    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }

    public function feedback()
    {
        return $this->hasMany(Feedback::class);
    }

    public function audioFiles()
    {
        return $this->hasMany(AudioFile::class);
    }
}
