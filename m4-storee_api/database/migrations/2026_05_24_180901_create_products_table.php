<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->longText('title');
            $table->integer('new_price');
            $table->integer('old_price')->nullable();
            $table->longText('description')->nullable();
            $table->string('caliber')->nullable();
            $table->string('capacity')->nullable();
            $table->string('category');
            $table->string('product_type')->nullable();
            $table->string('product_type2')->nullable();
            $table->string('length')->nullable();
            $table->string('model')->nullable();
            $table->string('weight')->nullable();
            $table->string('manufacturing_countrey')->nullable();
            $table->string('manufacturing_company')->nullable();
            $table->boolean('usage');
            $table->integer('sold')->default(0);
            $table->double('rating')->default(2.4);
            $table->boolean('best_offer')->default(false);
            $table->timestamps();
        });

        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
