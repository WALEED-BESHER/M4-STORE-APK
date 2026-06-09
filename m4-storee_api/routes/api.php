<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\FavoritesController;

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

Route::post("/checkemail",[AuthController::class,"checkemail"]);
Route::post("/forget-password",[AuthController::class,"forgetPassword"]);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/update-profile', [AuthController::class, 'updateProfile']);
});
// جلب المنتجات
Route::middleware('auth:sanctum')->get('/products',
    [ProductController::class,'index']
);
// Route::get('/products',
//     [ProductController::class,'index']
// );
// حذف المنتجات
Route::delete('/products/{id}',[ProductController::class, 'destroy']);
// اضافه منتجات
Route::post('/products/store',
    [ProductController::class,'store']
);
// تعديل المنتجات
Route::post(
    '/products/update/{id}',
    [ProductController::class,'update']
);
// جلب بيانات المستخدمين الى صفحه اداره المستخدمين
Route::get('/admin/users',[AuthController::class,'getUsers']);
// تفعيل + تعطيل الحسابات
Route::post('/admin/users/{id}/toggle-activation',[AuthController::class,'toggleActivation']);
// رفع وسحب الادمن
Route::post('/admin/users/{id}/toggle-Admin',[AuthController::class,'toggleAdmin']);
// حذف الحساب
Route::delete('/admin/users/{id}',[AuthController::class, 'deleteUser']);
// اضافه وحذف المنتجات الى المفضله + جلب معلومات المفضله
Route::middleware('auth:sanctum')->group(function () {
    // اضافه وحذف المنتجات الى المفضله
    Route::post(
        '/favorites/toggle',
        [FavoritesController::class, 'toggle']
    );
    // جلب معلومات المفضله
    Route::get(
        '/favorites',
        [FavoritesController::class, 'index']
    );
});
// تغير كلمه السر
Route::middleware('auth:sanctum')->post(
    '/change-password',[AuthController::class,'changePassword']
);


