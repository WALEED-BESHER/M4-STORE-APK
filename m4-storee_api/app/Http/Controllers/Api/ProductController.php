<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Http\Resources\ProductResource;
use App\Models\ProductImage;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'new_price' => 'required',
            'category' => 'required',
            'images.*' => 'required|image|mimes:jpg,jpeg,png,webp',
        ]);

        // إنشاء المنتج
        $product = Product::create([
            'title' => $request->title,
            'new_price' => $request->new_price,
            'old_price' => $request->old_price,
            'description' => $request->description,
            'caliber' => $request->caliber,
            'capacity' => $request->capacity,
            'category' => $request->category,
            'product_type' => $request->product_type,
            'product_type2' => $request->product_type2,
            'length' => $request->length,
            'model' => $request->model,
            'weight' => $request->weight,
            'manufacturing_countrey' => $request->manufacturing_countrey,
            'manufacturing_company' => $request->manufacturing_company,
            'usage' => $request->usage,
            'rating' => $request->rating,
            'best_offer' => $request->best_offer,
        ]);

        // حفظ الصور
        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $imageName = time() . '_' . $image->getClientOriginalName();

                $image->storeAs(
                    'products',
                    $imageName,
                    'public'
                );

                ProductImage::create([
                    'product_id' => $product->id,
                    'image' => 'products/' . $imageName,
                ]);
            }
        }

        return response()->json([
            'message' => 'Product Created Successfully'
        ]);
    }
    public function index()
    {
        $products = Product::with('images')->get();

        return ProductResource::collection($products);
    }
}
