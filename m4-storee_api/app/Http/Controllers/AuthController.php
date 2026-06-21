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
use Illuminate\Support\Facades\DB;
use App\Models\Location;

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
            "complete_information" => 0,
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
                "message" => "لا يوجد حساب مرتبط بهذا البريد الإلكتروني"
            ]);
        }
        //التحقق من كلمه المرور
        if (!Hash::check($r->password, $user->password)) {
            return response()->json([
                "status" => "error",
                "message" => "البريد الإلكتروني أو كلمة المرور غير صحيح يرجى التاكد واعاده المحاولة"
            ]);
        }
        // حذف التوكنات السابقه
        $user->tokens()->delete();
        // إنشاء توكن جديد
        $token = $user->createToken("mobile_app")->plainTextToken;
        return response()->json([
            "status" => "success", 
            "token" => $token,
            "users" => $user,

            "verification" => $user->verification,
            "activation" => $user->activation,
            "complete_information" => $user->complete_information,
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


    public function sendOtp(Request $r)
    {
        $r->validate([
            "email" => "required|email",
            "type" => "required|in:verification,forget-password"
        ]);
        $email = $r->email;
        $type = $r->type;

        $times = [
            59,
            179,
            649,
            3540,
            17700,
            42480,
            84960
        ];

        $otp = Otp::where("email", $email)->where("type",$type)->first();
        // إذا لا يوجد OTP
        if (!$otp) {
            $code = rand(1000, 9999);
            $otp = Otp::create([
                "email" => $email,
                "type" => $type,
                "code" => $code,
                "expires_at" => now()->addMinutes(5),
                "resend_count" => 0,
                "blocked_until" => now(),
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
            new SendOtpMail($otp->code,$type)
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

    public function checkemail(Request $r){
        $r->validate([
            "email" => "required|email",
        ]);


        $user = User::where("email",$r->email)->first();
        if (!$user) {
            return response()->json([
                "status" => "error",
                "message" => "لا يوجد حساب مرتبط بهذا البريد الإلكتروني"
            ]);
        }
            
        return response()->json([
            "status" => "success",
        ]);
        
    }

    
    public function verifyOtp(Request $r)
    {
        $r->validate([
            "email" => "required|email",
            "code" => "required",
            "type" => "required|in:verification,forget-password"
        ]);

        $otp = Otp::where("email", $r->email)
            ->where("code", $r->code)
            ->where("type", $r->type)
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

        if($r->type === "verification"){
            $user->verification = 1;
            $user->save();
            // حذف OTP
            $otp->delete();
            return response()->json([
                "status" => "success",
                "message" => "تم التحقق بنجاح"
            ]);

        }

        if($r->type === "forget-password"){
            $otp->save();
            return response()->json([
                "status" => "success",
                "message" => "تم التحقق من الكود، الآن يمكنك تعيين كلمة المرور الجديدة"
            ]);
        }
    }
    // نسيان كلمه السر
    public function forgetPassword(Request $r)
    {
        $r->validate([
            "email" => "required|email",
            "code" => "required",
            "password" => "required|min:5",
            "type" => "required|in:forget-password",
        ]);

        $otp = Otp::where("email", $r->email)
            ->where("code", $r->code)
            ->where("type", "forget-password")
            ->first();
            
        if (!$otp) {
            return response()->json([
                "status" => "error",
                "message" => "لم يتم التحقق من الكود أو الكود غير صحيح"
            ]);
        }

        if (Carbon::now()->gt($otp->expires_at)) {
            $otp->delete();

            return response()->json([
                "status" => "error",
                "message" => "انتهت صلاحية الكود"
            ]);
        }

        $user = User::where("email", $r->email)->first();

        if (!$user) {
            return response()->json([
                "status" => "error",
                "message" => "المستخدم غير موجود"
            ]);
        }

        $user->password = Hash::make($r->password);
        $user->save();

        $otp->delete();

        return response()->json([
            "status" => "success",
            "message" => "تم تغيير كلمة المرور بنجاح"
        ]);
    }

    // جلب بيانات البروفايل 
    public function profile(Request $r)
    {
        $user = $r->user()->load('latestLocation');
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

    // جلب بيانات الحسابات
    public function getUsers()
    {
        $users = User::orderBy('id','desc')->get();

        return response()->json([
            "status" => "success",
            "users" => UserResource::collection($users)
        ]);
    }
    // تفعيل وتعديل الحساب
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
    // رفع وسحب الادمن
    public function toggleAdmin($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json([
                "status" => "error",
                "message" => "المستخدم غير موجود"
            ], 404);
        }
        $user->admin = !$user->admin;
        $user->save();
        return response()->json([
            "status" => "success",
            "message" => $user->admin
                ? " تم رفع المستخدم الى ادمن"
                : "تم سحب صلاحية الادمن",
            "admin" => $user->admin
        ]);
    }
    // حذف المستخدم من dashboard
    public function deleteUser($id)
    {
        $user = User::find($id);
        if(!$user){
            return response()->json([
                "status" => "error",
                "message" => "المستخدم غير موجود"
            ],404);
        }
        $user->tokens()->delete();
        $user->delete();
        return response()->json([
            "status" => "success",
            "message" => "تم حذف المستخدم بنجاح"
        ]);
    }

    // تغير كلمه السر من داخل الحساب
    public function changePassword(Request $r)
    {
        $r->validate([
            "oldpassword" => "required",
            "newpassword" => "required|min:5",
        ]);
        $user = $r->user();
        // فحص كلمة المرور القديمة
        if (!Hash::check($r->oldpassword,$user->password)) {
            return response()->json([
                "status" => "error",
                "message" => "كلمة المرور السابقة غير صحيحة"
            ]);
        }
        // تحديث كلمة المرور
        $user->password = Hash::make(
            $r->newpassword
        );
        $user->save();
        return response()->json([
            "status" => "success",
            "message" => "تم تغيير كلمة المرور بنجاح"
        ]);
    }

    //
    public function completeInformation(Request $r)
    {
        $r->validate([
            "first_name" => "required|min:2|max:25",
            "last_name" => "nullable|max:25",
            "phone_number2" => "nullable|max:20",
            "address" => "required|min:3|max:255",
            "latitude" => "required|numeric",
            "longitude" => "required|numeric",
        ]);

        $user = $r->user();

        $user->first_name = $r->first_name;
        $user->last_name = $r->last_name;
        $user->phone_number2 = $r->phone_number2;
        $user->complete_information = 1;
        $user->save();

        $user->locations()->update([
            'active'=> 0,
        ]);
        $user->locations()->create([
            "address" => $r->address,
            "latitude" => $r->latitude,
            "longitude" => $r->longitude,
            "active" => 1,
        ]);

        return response()->json([
            "status" => "success",
            "message" => "تم حفظ المعلومات بنجاح",
            "user" => $user
        ]);
    }

    // جلب عناوين المستخدم الحالي 
    public function getUserLocations(Request $r)
    {
        $locations = $r->user()
            ->locations()
            ->orderByDesc('id','asc')
            ->get();

        return response()->json([
            'status' => 'success',
            'locations' => $locations,
        ]);
    }

    // إضافة عنوان جديد
    public function addNewLocation(Request $r)
    {
        $r->validate([
            "address" => "required|string|max:255",
            "latitude" => "required|numeric",
            "longitude" => "required|numeric",
        ]);

        $user = $r->user();

        $location = DB::transaction(function () use ($user, $r) {
            // أي عنوان قديم يصبح غير نشط
            $user->locations()->update([
                'active' => 0,
            ]);

            // العنوان الجديد يصبح active
            return $user->locations()->create([
                "address" => $r->address,
                "latitude" => $r->latitude,
                "longitude" => $r->longitude,
                "active" => 1,
            ]);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'تمت إضافة العنوان بنجاح',
            'location' => $location,
        ]);
    }

    // جعل عنوان معين active والباقي false
    public function setActiveLocation(Request $r, $id)
    {
        $user = $r->user();

        $location = $user->locations()->where('id', $id)->first();

        if (!$location) {
            return response()->json([
                'status' => 'error',
                'message' => 'العنوان غير موجود',
            ], 404);
        }

        DB::transaction(function () use ($user, $location) {
            $user->locations()->update([
                'active' => 0,
            ]);

            $location->update([
                'active' => 1,
            ]);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'تم تعيين العنوان كعنوان نشط',
        ]);
    }

    // حذف عنوان
    public function deleteLocation(Request $r, $id)
    {
        $user = $r->user();

        // عدد عناوين المستخدم
        $locationsCount = $user->locations()->count();
        // إذا كان لديه عنوان واحد فقط لا نحذف
        if ($locationsCount <= 1) {
            return response()->json([
                'status' => 'error',
                'message' => 'لا يمكنك حذف هذا العنوان لأنك يجب أن تحتفظ بعنوان واحد على الأقل',
            ], 400);
        }

        $location = $user->locations()->where('id', $id)->first();

        if (!$location) {
            return response()->json([
                'status' => 'error',
                'message' => 'العنوان غير موجود',
            ], 404);
        }

        $wasActive = $location->active;

        $location->delete();

        // إذا حذفت العنوان النشط، اجعل أحدث عنوان متبقي active
        if ($wasActive) {
            $newActive = $user->locations()->latest('id')->first();

            if ($newActive) {
                $newActive->update(['active' => 1]);
            }
        }

        return response()->json([
            'status' => 'success',
            'message' => 'تم حذف العنوان بنجاح',
        ]);
    }

    public function updateLocation(Request $r, $id)
    {
        $r->validate([
            "address" => "required|string|max:255",
            "latitude" => "required|numeric",
            "longitude" => "required|numeric",
        ]);

        $user = $r->user();

        $location = $user->locations()->where('id', $id)->first();

        if (!$location) {
            return response()->json([
                "status" => "error",
                "message" => "العنوان غير موجود"
            ], 404);
        }

        $location->address = $r->address;
        $location->latitude = $r->latitude;
        $location->longitude = $r->longitude;
        $location->save();

        return response()->json([
            "status" => "success",
            "message" => "تم تعديل الموقع بنجاح",
            "location" => $location
        ]);
    }




}
