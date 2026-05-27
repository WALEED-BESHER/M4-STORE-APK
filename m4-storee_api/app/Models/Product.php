<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
        'title',
        'new_price',
        'old_price',
        'description',
        'caliber',
        'capacity',
        'category',
        'product_type',
        'product_type2',
        'length',
        'model',
        'weight',
        'manufacturing_countrey',
        'manufacturing_company',
        'usage',
        'sold',
        'rating',
        'best_offer',
    ];
    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }
}
