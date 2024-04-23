<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class AccountController extends Controller
{
    public function list($id = null) {
        $data = $id
            ? Account::find($id)
            : Account::all();

        return response()->json($data);
    }

    public function create(Request $rq) {
        $data = Account::create([
            "name" => $rq->name,
            "description" => $rq->description,
            "color" => $rq->color,
        ]);

        Category::create([
            "name" => Account::$TRANSFER_PREFIX.$data->name,
            "parent_id" => 1,
        ]);

        return response()->json($data, 201);
    }

    public function edit($id, Request $rq) {
        $data = Account::find($id);
        $cat = $data->transfer_category;

        foreach ($rq->all() as $key => $val) {
            $data->{Str::snake($key)} = $val;
        }
        $data->save();

        $cat->update(["name" => Account::$TRANSFER_PREFIX.$rq->name]);

        return response()->json($data);
    }

    public function delete($id, Request $rq) {
        $data = Account::find($id);
        $data->transfer_category->delete();
        $data->delete();

        return response()->json($data);
    }
}
