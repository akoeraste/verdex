<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Feedback extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category',
        'rating',
        'message',
        'contact',
        'plant_id',
        'comment',
        'status',
    ];

    protected $casts = [
        'rating' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function plant()
    {
        return $this->belongsTo(Plant::class);
    }

    // Helper methods
    public function isResponded()
    {
        return !empty($this->comment);
    }

    public function getStatusAttribute()
    {
        return $this->isResponded() ? 'responded' : 'pending';
    }

    public function getRatingTextAttribute()
    {
        $ratings = [
            1 => 'Poor',
            2 => 'Fair', 
            3 => 'Good',
            4 => 'Very Good',
            5 => 'Excellent'
        ];
        
        return $ratings[$this->rating] ?? 'Not rated';
    }
} 