<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\ProductController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::post('signup', [AuthController::class, "Signup"]);
Route::post('login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->get('profile', function (Request $r) {
    return $r->user();
});
Route::middleware('auth:sanctum')->post('logout', [AuthController::class, 'logout']);
Route::post("/sendOtp",[AuthController::class,"sendOtp"]);

Route::post("/verifyOtp",[AuthController::class,"verifyOtp"]);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/update-profile', [AuthController::class, 'updateProfile']);
});
// جلب المنتجات
Route::get('/products',
    [ProductController::class,'index']
);
// حذف المنتجات
Route::delete(
    '/products/{id}',
    [ProductController::class, 'destroy']
);
// اضافه منتجات
Route::post('/products/store',
    [ProductController::class,'store']
);
// تعديل المنتجات
Route::post(
    '/products/update/{id}',
    [ProductController::class,'update']
);