<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Favorites;

class FavoritesController extends Controller
{
    public function toggle(Request $request)
    {
        $request->validate([
            "product_id" => "required|exists:products,id"
        ]);
        $user = $request->user();
        $favorite = Favorites::where(
            "user_id",
            $user->id
        )
        ->where(
            "product_id",
            $request->product_id
        )
        ->first(); 

        if ($favorite) {

            $favorite->delete();

            return response()->json([
                "status" => "removed"
            ]);
        }

        Favorites::create([
            "user_id" => $user->id,
            "product_id" => $request->product_id
        ]);

        return response()->json([
            "status" => "added"
        ]);
    }

    public function index(Request $request)
    {
        $favorites = $request->user()
            ->favorites()
            ->with('product.images')
            ->get();

        return response()->json([
            "status" => "success",
            "favorites" => $favorites
        ]);
    }
}

