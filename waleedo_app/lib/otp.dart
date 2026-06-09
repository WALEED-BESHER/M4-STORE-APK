import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Design System/Buttons/primary_button.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/api.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String type;
  const OtpPage({
    super.key,
    required this.email,
    required this.type,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();

  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();

  

  Timer? timer;
  int seconds = 55; // غيرها إلى 179 = 2:59 أو 659 = 10:59
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        f1.requestFocus();
      }
    );
    // if(widget.type == "verification"){
    //   sendOtp();
    // }
    sendOtp();
  }

  void resendCode() async {
    // المهمة التي ستقولها لي لاحقاً ضعها هنا

    await sendOtp();
    
  }

  void pasteOtp(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length == 4) {
      c1.text = value[0];
      c2.text = value[1];
      c3.text = value[2];
      c4.text = value[3];
      FocusScope.of(context).unfocus();
      verifyOtp();
    }
    else if (value.length == 3) {
      c1.text = value[0];
      c2.text = value[1];
      c3.text = value[2];
      FocusScope.of(context).requestFocus(f4);
    }
    else if (value.length == 2) {
      c1.text = value[0];
      c2.text = value[1];
      FocusScope.of(context).requestFocus(f3);
    }
  }   

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        t.cancel();
        setState(() {});
      }
    });
  }

  String formatTime(int totalSeconds) {
    if (totalSeconds < 60) {
      return "$totalSeconds ";
    }

    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;

    return "$min:${sec.toString().padLeft(2, '0')}";
  }



  Widget otpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? next,
    FocusNode? prev,
    bool allowPaste = false,
  }) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty &&
              prev != null) {
            prev.requestFocus();
            if (prev == f1) {
              c1.clear();
            } else if (prev == f2) {
              c2.clear();
            } else if (prev == f3) {
              c3.clear();
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: allowPaste ? 4 : 1,
          style: fonts.h6.copyWith(color: color.white),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor:
                focusNode.hasFocus ? color.b_hoverdred : color.dark2,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: color.dark3,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: color.p600,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            // لصق OTP كامل
            if (value.length > 1) {
              pasteOtp(value);
              return;
            } 
            // كتابة رقم
            if (value.isNotEmpty) {
              if (next != null) {
                next.requestFocus();
              } else {
                String otp =
                    c1.text +
                    c2.text +
                    c3.text +
                    c4.text;
                if (otp.length == 4) {
                  verifyOtp();
                }
              }
            }
            // حذف رقم من الحقل الحالي
            if (value.isEmpty && prev != null) {
              prev.requestFocus();
            }
          },
        ),
      ),
    );
  } 


  Future<void> verifyOtp() async {
    String otp =
        c1.text +
        c2.text +
        c3.text +
        c4.text;
    if (otp.length != 4) {
      return;
    }
    var url = Uri.parse(Api.verifyOtp);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "email": widget.email,
        "code": otp,
        "type": widget.type
      }),
    );
    var data = jsonDecode(response.body);
    if (data["status"] == "success") {
      if(widget.type == "verification"){
        p_snackbar.show(
          context: context,
          title: 'تم تسجيل الدخول بنجاح',
          timer: Duration(seconds: 3),
        );
        Navigator.pushReplacementNamed(context,"home");
      }
      else if(widget.type == "forget-password"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(
              email: widget.email,
              code: otp,
            ),
          ),
        );
      }
            
    } else {
      p_snackbar.show(
        context: context,
        title: data["message"],
        timer: Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  Future<void> sendOtp() async {
    var url = Uri.parse(Api.sendOtp);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "email": widget.email,
        "type": widget.type
      }),
    );
    var data = jsonDecode(response.body);
    if(data["status"] == "success" || data["status"] == "blocked"){
      setState(() {
        seconds = data["seconds"].toInt();
      });
      startTimer();
    }
    else{
      p_snackbar.show(
        context: context, 
        title: data["message"],
        timer: const Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel
      );
    }
  }

    

  @override
  void dispose() {
    timer?.cancel();
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();

    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        //appbar
        showLeading: false,
        title: "التحقق من رمز OTP",
        showAction: true,
        btn3icon: Icons.arrow_forward,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              Text(
                "تم إرسال الكود إلى ${widget.email}",
                style: fonts.ms.copyWith(color: color.white),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  otpBox(controller: c1, focusNode: f1, next: f2,allowPaste: true),
                  const SizedBox(width: 15),
                  otpBox(
                    controller: c2,
                    focusNode: f2,
                    next: f3,
                    prev: f1,
                  ),
                  const SizedBox(width: 15),
                  otpBox(
                    controller: c3,
                    focusNode: f3,
                    next: f4,
                    prev: f2,
                  ),
                  const SizedBox(width: 15),
                  otpBox(
                    controller: c4,
                    focusNode: f4,
                    prev: f3,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                height: 40,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  seconds > 0
                      ? Text(
                          formatTime(seconds),
                          style: fonts.lb.copyWith(color: color.p500),
                          textDirection: TextDirection.rtl,
                        )
                      : TextButton(
                          onPressed: resendCode,
                          child: Text(
                            "إرسال مجدداً",
                            style: fonts.lb.copyWith(
                              color: color.p500,
                              decoration: TextDecoration.underline,
                              decorationColor: color.p500,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "سيتم إرسال الكود بعد ",
                    style: fonts.lm.copyWith(color: color.white),
                  ),
                ],
              ),
              ),
              const SizedBox(height: 20),
              p_button(
                title: "تحقق",
                onPressed: verifyOtp,
                height: 50,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: EdgeInsets.all(8),
        color: color.dark2,
        child: Center(
              child: Text(
                "ملاحظه: يرجى التحقق من قسم الرسائل غير المرغوب بها (Spam) إذا لم يصلك رمز التحقق.",
                style: fonts.xsm.copyWith(color: color.white),
                textDirection: TextDirection.rtl,
              ),
            ),
      ),
    );
  }
}
