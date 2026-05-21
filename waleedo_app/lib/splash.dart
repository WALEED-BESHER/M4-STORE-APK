import 'dart:async';
import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
    // اذا يوجد token
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, "home");
    }
    // اذا لا يوجد token
    else {
      if(seenwelcome){
        Navigator.pushReplacementNamed(context, "login");
      }else{
        Navigator.pushReplacementNamed(context, "welcome");
      }
    }
  }// betobisher@gmail.com Alwaleed770411921

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