<?php

use App\Http\Controllers\AccountController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::controller(AccountController::class)->prefix("accounts")->group(function() {
    Route::get("/{id?}", "list");
    Route::post("/create", "create");
    Route::post("/edit/{id}", "edit");
    Route::delete("/delete/{id}", "delete");
});
