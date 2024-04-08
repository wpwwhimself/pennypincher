<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    public function list($id = null) {
        $data = $id
            ? Category::with("subcategories", "parent")->find($id)
            : Category::with("subcategories")->whereNull("parent_id")->get();

        return response()->json($data);
    }

    public function create(Request $rq) {
        $data = Category::create([
            "name" => $rq->name,
            "description" => $rq->description,
            "color" => $rq->color,
            "parent_id" => $rq->parentId,
        ]);

        return response()->json($data, 201);
    }

    public function edit($id, Request $rq) {
        $data = Category::find($id);
        foreach ($rq->all() as $key => $val) {
            $data->{Str::snake($key)} = $val;
        }
        $data->save();

        return response()->json($data);
    }

    public function delete($id, Request $rq) {
        $data = Category::find($id);
        $data->delete();

        return response()->json($data);
    }
}
