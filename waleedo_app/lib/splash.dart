import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waleedo_app/Design%20System/SnackBar/primary_snackbar.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Design System/Buttons/primary_button.dart';



class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences s = await SharedPreferences.getInstance();
    String? token = s.getString("token");
    bool seenwelcome = s.getBool("seenwelcome") ?? false;
    // اذا لم يوجد توكن
    if (token == null || token.isEmpty) {
      if (seenwelcome) { 
        
        Navigator.pushReplacementNamed(context, "login");
      } else {
        Navigator.pushReplacementNamed(context, "welcome");
      }
      return;
    }
    try {
      var response = await http.get(
        Uri.parse(Api.profile),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 && response.statusCode < 300) {
        var data = jsonDecode(response.body);
        int activation = data["user"]["activation"];
        if (activation == 1) {
          Navigator.pushReplacementNamed(
            context,
            "home",
          );
        } else {
          p_snackbar.show(
            context: context, title: 
            "تم اغلاق حسابك يرجى التواصل مع فريق الدعم لمزيد من التفاصيل",
            background: color.error,
            icon: Icons.cancel,
            fontType: fonts.sb
          );
          // حذف التوكن إذا الحساب مبند
          await s.remove("token");
          await s.remove("first_name");
          Navigator.pushReplacementNamed(
            context,
            "login",
          );
        }
      } 
      
      else if (response.statusCode == 401 || response.statusCode == 403) {
        p_snackbar.show(
          context: context, 
          title: "انتهت صلاحيه الجلسه ارجاء اعادة تسجيل الدخول",
          background: color.error,
          icon: Icons.cancel,
        );
        // التوكن منتهي أو غير صالح
        await s.remove("token");
        await s.remove("first_name");
        Navigator.pushReplacementNamed(
          context,
          "login",
        );
      }

      else if(
        response.statusCode == 500 ||
        response.statusCode == 502 ||
        response.statusCode == 503 ||
        response.statusCode == 504 ) 
      {
        showServerErrorDialog();
      } 
      
      else{
        p_snackbar.show(
          context: context, 
          title: "فشل تسجيل الدخول يرجى اعاده تسجيل الدخول",
          background: color.error,
          icon: Icons.cancel,
        );

        await s.remove("token");
        await s.remove("first_name");
        
        Navigator.pushReplacementNamed(
          context,
          "login",
        );
      }

    } 
    catch (e) {
      showServerErrorDialog();
    }
  } 

  void showServerErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color.dark2,
          title: Center(
            child: Text(
              "خطأ في الاتصال",
              style: fonts.lb.copyWith(color: color.white),
            ),
          ),
          content: Text(
            "تعذر الاتصال بالسيرفر، يرجى المحاولة مرة أخرى.",
            style: fonts.ss.copyWith(color: color.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            p_button(
              title: "إعادة الاتصال", 
              onPressed: (){
                Navigator.pop(context);
                checkLogin();
              }
            ),
          ],
        );
      },
    );
  }


  // Future<void> checkLogin() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   SharedPreferences s = await SharedPreferences.getInstance();
  //   String? token = s.getString("token");
  //   bool seenwelcome = s.getBool("seenwelcome") ?? false;
  //   // اذا يوجد token
  //   if (token != null && token.isNotEmpty) {
  //     Navigator.pushReplacementNamed(context, "home");
  //   }
  //   // اذا لا يوجد token
  //   else {
  //     if(seenwelcome){
  //       Navigator.pushReplacementNamed(context, "login");
  //     }else{
  //       Navigator.pushReplacementNamed(context, "welcome");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: color.dark1,

      body: SafeArea(
        child: Column(
          children: [
            // Logo
            Expanded(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -70),
                  child: Image.asset(
                    "assets/images/MainLogo.png",
                    width: MediaQuery.of(context).size.width * 0.55,
                  ),
                ),
              ),
            ),

            /// loading + powered by
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  /// loading يدور
                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: color.p500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text:  TextSpan(
                      children: [
                        TextSpan(
                          text: "Powered By ",
                          style: fonts.h5.copyWith(color: color.p500)
                        ),
                        TextSpan(
                          text: "Waleed",
                          style:fonts.h6.copyWith(color: color.g200)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}