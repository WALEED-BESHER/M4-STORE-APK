<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Http\Request;
use App\Models\Otp;
use App\Mail\SendOtpMail;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;
use App\Http\Resources\UserResource;

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
            return response()->json([
                "status" => "error", 
                "message" => "User not found"
            ]);
        }
        //التحقق من كلمه المرور
        if (!Hash::check($r->password, $user->password)) {
            return response()->json([
                "status" => "error",
                "message" => "Password Incorrect"
            ]);
        }

        // إنشاء التوكن
        $token = $user->createToken("mobile_app")->plainTextToken;
        return response()->json([
            "status" => "success", 
            "token" => $token,
            "users" => $user,

            "verification" => $user->verification,
            "activation" => $user->activation,
        ]);
    }


    public function sendOtp(Request $r)
    {
        $r->validate([
            "email" => "required|email"
        ]);
        $email = $r->email;
        $times = [
            59,
            179,
            649,
            3540,
            17700,
            42480,
            84960
        ];
        $otp = Otp::where("email", $email)->first();
        // إذا لا يوجد OTP
        if (!$otp) {
            $code = rand(1000, 9999);
            $otp = Otp::create([
                "email" => $email,
                "code" => $code,
                "expires_at" => now()->addMinutes(5),
                "resend_count" => 0,
                "blocked_until" => now()
            ]);
        }
        // إذا الحظر لم ينتهِ
        if (
            $otp->blocked_until &&
            now()->lt($otp->blocked_until)
        ) {
            return response()->json([
                "status" => "blocked",
                "seconds" => now()
                    ->diffInSeconds($otp->blocked_until)
            ]);
        }
        // إذا انتهت صلاحية OTP
        if (now()->gt($otp->expires_at)) {
            $otp->code = rand(1000, 9999);
            $otp->expires_at = now()->addMinutes(5);
        }
        // إرسال الإيميل
        Mail::to($email)->send(
            new SendOtpMail($otp->code)
        );

        // اختيار الوقت
        $index = min(
            $otp->resend_count,
            count($times) - 1
        );

        $seconds = $times[$index];
        // تحديث الحظر
        $otp->blocked_until =
            now()->addSeconds($seconds);
        $otp->resend_count =
            $otp->resend_count + 1;
        $otp->save();
        return response()->json([
            "status" => "success",
            "seconds" => $seconds

        ]);
    }

    
    public function verifyOtp(Request $r)
    {
        $r->validate([
            "email" => "required|email",
            "code" => "required"
        ]);

        $otp = Otp::where("email", $r->email)
            ->where("code", $r->code)
            ->first();

        if (!$otp) {
            return response()->json([
                "status" => "error",
                "message" => "الكود غير صحيح"
            ]);
        }

        // التحقق من انتهاء الصلاحية
        if (Carbon::now()->gt($otp->expires_at)) {

            $otp->delete();

            return response()->json([
                "status" => "error",
                "message" => "انتهت صلاحية الكود"
            ]);
        }

        // تعديل verification
        $user = User::where("email", $r->email)->first();

        $user->verification = 1;

        $user->save();

        // حذف OTP
        $otp->delete();

        return response()->json([
            "status" => "success",
            "message" => "تم التحقق بنجاح"
        ]);
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

    // جلب بيانات البروفايل 
    public function profile(Request $r)
    {
        return response()->json([
            "status" => "success",
            "user" => $r->user()
        ]);
    }
    // تعديل البروفايل
    public function updateProfile(Request $r)
    {
        $user = $r->user();
        $r->validate([
            "first_name" => "required|min:2|max:25",
            "last_name" => "nullable|max:25",
            "email" => "required|email|unique:users,email," . $user->id,
            "phone_number" => "required|unique:users,phone_number," . $user->id,
            "phone_number2" => "nullable"
        ]);
        $user->first_name = $r->first_name;
        $user->last_name = $r->last_name;
        $user->email = $r->email;
        $user->phone_number = $r->phone_number;
        $user->phone_number2 = $r->phone_number2;
        $user->save();
        return response()->json([
            "status" => "success",
            "message" => "تم تحديث البيانات بنجاح",
            "user" => $user
        ]);
    } 

    public function getUsers()
    {
        $users = User::orderBy('id','desc')->get();

        return response()->json([
            "status" => "success",
            "users" => UserResource::collection($users)
        ]);
    }

    public function toggleActivation($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json([
                "status" => "error",
                "message" => "المستخدم غير موجود"
            ], 404);
        }
        $user->activation = !$user->activation;

        $user->save();

        return response()->json([
            "status" => "success",
            "message" => $user->activation
                ? "تم تفعيل الحساب"
                : "تم تعطيل الحساب",

            "activation" => $user->activation
        ]);
    }


}
