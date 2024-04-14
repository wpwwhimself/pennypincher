<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        "date",
        "category_id",
        "account_id",
        "description",
        "amount",
    ];

    protected $dates = ["date"];

    public function account() {
        return $this->belongsTo(Account::class);
    }
    public function category() {
        return $this->belongsTo(Category::class);
    }
}
