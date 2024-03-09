<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TransferCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table("categories")->insert([
            "id" => 1,
            "name" => "Transfer",
            "description" => "Przelew własny – przeniesienie pieniędzy pomiędzy kontami",
            "color" => "#9b32a8",
        ]);
    }
}
