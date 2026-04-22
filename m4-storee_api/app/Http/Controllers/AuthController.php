<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function Signup(Request $r)
    {
        $r->validate([
            "firstName" => "required|min:3|max:50",
            "lastName" => "nullable|max:50",
            "email" => "required|email|unique:users,email",
            "phone_number" => "required|unique:users,phone_number",
            "password" => "required|min:5"
        ]);
        $user = User::create([
            "first_name" => $r->firstName,
            "last_name" => $r->lastName,
            "email" => $r->email,
            "phone_number" => $r->phone_number,
            "password" => Hash::make($r->password),
        ]);
        return response()->json(["status" => "success"]);
    }

    public function login(Request $r)
    {
        $r->validate([
            "email" => "required|email",
            "password" => "required"
        ]);
        //استعلم لي في قاعده البيانات عن من يملك هذا الايميل
        $user = User::where("email", $r->email)->first();
        // التحقق هل المستخدم موجود
        if (!$user) {
            return response()->json(["status" => "error", "message" => "User not found"]);
        }
        //التحقق من كلمه المرور
        if (Hash::check($r->password, $user->password)) {
            $token = $user->createToken("mobile_app")->plainTextToken;
            return response()->json(["status" => "success", "token" => $token, "users" => $user]);
        } else {
            return response()->json(["status" => "error", "message" => " Password Incorrect"]);
        }
    }

    public function logout(Request $r)
    {
        // حذف التوكن الحالي
        $r->user()->tokens()->delete();
        return response()->json([
            "status" => "success",
            "message" => "Logged out"
        ]);
    }
}
