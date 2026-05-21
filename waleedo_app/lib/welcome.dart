import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/Buttons/primary_button.dart';



class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          /// الخلفية
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/welcome_background.png",
              fit: BoxFit.cover,
            ),
          ),

          /// طبقة سوداء خفيفة فوق الصورة
          Container(
            color: Colors.black.withOpacity(0.35),
          ),

          /// الكونتينر السفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                gradient: color.gBlack,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(48),
                  topRight: Radius.circular(48),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// اسم المتجر
                    Text(
                      "M4_STORE",
                      style: fonts.h1.copyWith(color: color.white,letterSpacing: 2),
                    ),
                    /// الوصف
                    Text(
                      "كل ما تحتاجه من معدات في مكان واحد",
                      textAlign: TextAlign.center,
                      style: fonts.xsb.copyWith(color: color.g400), 
                    ),
                    const SizedBox(height: 10),
                    /// زر ابدأ التسوق
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                      child: p_button(
                        title: "ابدأ التسوق", 
                        onPressed: () async{
                          SharedPreferences s = await SharedPreferences.getInstance();
                          await s.setBool("seenwelcome", true);
                          Navigator.pushReplacementNamed(context, "login");
                        },
                        showRightIcon: true,
                        rightIcon: Icons.flash_on,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}