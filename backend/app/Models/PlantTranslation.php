<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;

class PlantTranslation extends Model
{
    use HasFactory, LogsActivity;

    protected $fillable = [
        'plant_id', 'language_code', 'common_name', 'description', 'uses', 'audio_url'
    ];

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()->logOnly([
            'plant_id', 'language_code', 'common_name', 'description', 'uses', 'audio_url'
        ]);
    }

    public function plant()
    {
        return $this->belongsTo(Plant::class);
    }

    public function language()
    {
        return $this->belongsTo(Language::class, 'language_code', 'code');
    }
} 