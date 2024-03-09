<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;

    protected $fillable = [
        "name",
        "description",
        "color",
        "parent_id",
    ];

    public function transactions() {
        return $this->hasMany(Transaction::class)->orderByDesc("date");
    }
    public function parent() {
        return $this->belongsTo(self::class, "parent_id");
    }
    public function subcategories() {
        return $this->hasMany(Category::class, "parent_id");
    }
}
