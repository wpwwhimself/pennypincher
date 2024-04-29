<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class TransactionController extends Controller
{
    public function list(Request $rq, $id = null) {
        if ($id) return response()->json(Transaction::find($id));

        $perPage = $rq->perPage ?? 20;
        $page = $rq->page ?? 1;

        $data = Transaction::with("account", "category.parent")
            ->orderByDesc("date")
            ->orderByDesc("created_at");

        if ($rq->has("account"))
            $data = $data->where("account_id", $rq->account);
        if ($rq->has("category"))
            $data = $data->where("category_id", $rq->category)
                ->orWhereIn(
                    "category_id",
                    Category::find($rq->category)
                        ->subcategories
                        ->pluck("id")
                );

        $count = $data->count();

        $data = $data->limit($perPage)
            ->offset(($page - 1) * $perPage)
            ->get()
        ;
        if (!$rq->has("noGroup")) $data = $data->groupBy("date");

        return response()->json([
            "pageCount" => ceil($count / $perPage),
            "data" => $data,
        ]);
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
