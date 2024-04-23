<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Account extends Model
{
    use HasFactory;

    public static $TRANSFER_PREFIX = "Z: ";

    protected $fillable = [
        "name",
        "description",
        "color",
    ];
    protected $appends = [
        "balance"
    ];

    public function transactions() {
        return $this->hasMany(Transaction::class)->orderByDesc("date");
    }

    public function getTransferCategoryAttribute() {
        return Category::where("name", self::$TRANSFER_PREFIX.$this->name);
    }
    public function getBalanceAttribute() {
        return $this->transactions->sum("amount");
    }
}
