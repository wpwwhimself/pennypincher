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

    public function getTransferCategoryRelationAttribute() {
        return Category::where("name", self::$TRANSFER_PREFIX.$this->name);
    }
    public function getTransferCategoryAttribute() {
        return $this->transfer_category_relation->first();
    }
    public function getBalanceAttribute() {
        return round(
            Transaction::where("account_id", $this->id)->sum("amount")
            - Transaction::where("category_id", $this->transfer_category->id)->sum("amount"),
            2
        );
    }
}
