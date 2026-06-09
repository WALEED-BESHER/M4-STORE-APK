<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Otp extends Model
{
    protected $table = "otps";

    protected $fillable = [
        "email",
        "code",
        'type',
        "expires_at",
        "resend_count",
        "blocked_until"
    ];

    public $timestamps = false;
}