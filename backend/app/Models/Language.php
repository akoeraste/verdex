<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;

class Language extends Model
{
    use HasFactory, LogsActivity;

    protected $fillable = ['code', 'name'];

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()->logOnly(['code', 'name']);
    }

    public function plantTranslations()
    {
        return $this->hasMany(PlantTranslation::class, 'language_code', 'code');
    }
} 