<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    public function toArray($request)
    {
        return [

            "id" => $this->id,

            "images" => $this->images->map(function ($image) {
                return asset(
                    'storage/' . $image->image
                );
            }),
            "title" => $this->title,
            "newPrice" => $this->new_price,
            "oldPrice" => $this->old_price,
            "Description" => $this->description,
            "caliber" => $this->caliber,
            "capacity" => $this->capacity,
            "category" => $this->category,
            "ProductType" => $this->product_type,
            "ProductType2" => $this->product_type2,
            "length" => $this->length,
            "model" => $this->model,
            "weight" => $this->weight,
            "manufacturing_countrey" => $this->manufacturing_countrey,
            "manufacturing_company" => $this->manufacturing_company,
            "usage" => $this->usage,
            "sold" => $this->sold,
            "rating" => $this->rating,
            "bestOffer" => $this->best_offer,
            "date" => $this-> created_at,
        ];
    }
}
