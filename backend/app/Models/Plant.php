<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;

class Plant extends Model
{
    use HasFactory, LogsActivity;

    protected $fillable = [
        'scientific_name', 
        'plant_category_id', 
        'family', 
        'genus', 
        'species', 
        'image_urls', 
        'toxicity_level'
    ];

    protected $casts = [
        'image_urls' => 'array',
    ];

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()->logOnly([
            'scientific_name', 
            'plant_category_id', 
            'family', 
            'genus', 
            'species', 
            'toxicity_level'
        ]);
    }

    public function plantCategory()
    {
        return $this->belongsTo(PlantCategory::class, 'plant_category_id');
    }

    public function translations()
    {
        return $this->hasMany(PlantTranslation::class);
    }

    public function audioFiles()
    {
        return $this->hasMany(AudioFile::class);
    }
} 