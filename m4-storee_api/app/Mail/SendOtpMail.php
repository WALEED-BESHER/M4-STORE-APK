<?php

namespace App\Mail;

use Illuminate\Mail\Mailable;

class SendOtpMail extends Mailable
{
    public $otp;
    public $type;

    public function __construct($otp , $type)
    {
        $this->otp = $otp;
        $this->type = $type;
    }

    public function build()
    {
        $subject = $this->type === 'forget-password' ? 'استعاده كلمه المرور' : 'التحقق من ملكيه الحساب';
        return $this
            ->subject($subject)
            ->view("emails.otp")
            ->with([
                'otp'=> $this->otp,
                'type'=> $this->type,
            ]);
    }
}