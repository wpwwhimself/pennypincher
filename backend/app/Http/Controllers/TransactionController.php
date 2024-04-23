<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class TransactionController extends Controller
{
    public function list($id = null) {
        $data = $id
            ? Transaction::find($id)
            : Transaction::with("account", "category.parent")
                ->orderByDesc("date")
                ->orderByDesc("created_at")
                ->paginate(20)
            ;

        return response()->json($data);
    }

    public function create(Request $rq) {
        $data = Transaction::create([
            "date" => $rq->date,
            "category_id" => $rq->category_id,
            "account_id" => $rq->account_id,
            "description" => $rq->description,
            "amount" => $rq->amount,
        ]);

        return response()->json($data, 201);
    }

    public function edit($id, Request $rq) {
        $data = Transaction::find($id);
        foreach ($rq->all() as $key => $val) {
            $data->{Str::snake($key)} = $val;
        }
        $data->save();

        return response()->json($data);
    }

    public function delete($id, Request $rq) {
        $data = Transaction::find($id);
        $data->delete();

        return response()->json($data);
    }
}
