import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Design System/Buttons/primary_button.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

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
  int resendCount = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void resendCode() {
    // المهمة التي ستقولها لي لاحقاً ضعها هنا

    setState(() {
      resendCount++;

      if (resendCount == 1) {
        seconds = 179; // 2:59
      }
      else if (resendCount == 2) {
        seconds = 649; // 10:59
      }
      else if (resendCount == 3) {
        seconds = 3540; // 00:59:59
      }
      else if (resendCount == 4) {
        seconds = 17700; // 04:59:59
      }
      else if (resendCount == 4) {
        seconds = 42480; // 11:59:59
      }
      else {
        seconds = 84960; // 1day
      }
    });

    startTimer();
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
  }) {
    return SizedBox(
      width: 58,
      height: 58,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: fonts.h6.copyWith(color: color.white),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: focusNode.hasFocus ? color.b_hoverdred : color.dark2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: color.dark3, width: 2),
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
          if (value.isNotEmpty && next != null) {
            FocusScope.of(context).requestFocus(next);
          }

          if (value.isEmpty && prev != null) {
            FocusScope.of(context).requestFocus(prev);
          }
        },
      ),
    );
  }

  void verifyOtp() {
    String otp = c1.text + c2.text + c3.text + c4.text;

    if (otp.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code: $otp")),
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
      body: Container(
        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        // decoration: BoxDecoration(
        //   color: const Color(0xff111522),
        //   borderRadius: BorderRadius.circular(28),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Text(
              "تم إرسال الكود إلى waleedobisher7@gmail.com",
              style: fonts.ms.copyWith(color: color.white),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                otpBox(controller: c1, focusNode: f1, next: f2),
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
    );
  }
}
