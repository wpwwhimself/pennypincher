<?php

namespace App\Http\Controllers;

use App\Models\Account;
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

        return response()->json($data, 201);
    }

    public function edit($id, Request $rq) {
        $data = Account::find($id);
        foreach ($rq->all() as $key => $val) {
            $data->{Str::snake($key)} = $val;
        }
        $data->save();

        return response()->json($data);
    }

    public function delete($id, Request $rq) {
        $data = Account::find($id);
        $data->delete();

        return response()->json($data);
    }
}
