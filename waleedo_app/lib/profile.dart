import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  GlobalKey<FormState> formdata = GlobalKey<FormState>();
  TextEditingController First_Name = TextEditingController(text: "الوليد");
  TextEditingController Last_Name = TextEditingController(text: "بشر");
  TextEditingController Email = TextEditingController(text: "betobishr7@gmail.com");
  TextEditingController Phone_num = TextEditingController(text: "+967770411921");
  TextEditingController Phone_num2 = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الملف الشخصي",
        centerTheTitles: true,
      ),

      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// الصورة
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: color.f_secondary,
                    backgroundImage: AssetImage(
                      "assets/images/MainLogo.png",
                    ),
                  ),
                  // زر التعديل
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: color.p500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: color.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Form(
                key: formdata,
                child: SingleChildScrollView(
                  child: Column(
                    children: [


                      Row(
                        children: [
                          Expanded(
                            child: p_input(
                              //======================  الاسم الاخر =================
                              validator: (value) {
                                if (value!.length > 25) {
                                  return "*اجعله اقل من 25 حرف";
                                }
                                if (value.trim().isEmpty) {
                                  return null;
                                }
                                if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                    .hasMatch(value)) {
                                  return '* اجعلة حروف فقط';
                                }
                                return null;
                              },
                              controller: Last_Name,
                              inputFormatters: [
                                // يسمح بالحروف العربية والإنجليزية فقط
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\u0621-\u064A]')),
                                // يمنع المسافات داخل الاسم
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                                // تحديد الحد الأقصى لعدد الأحرف
                                LengthLimitingTextInputFormatter(25),
                              ],
                              label: "الاسم الاخر  ",
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: p_input(
                              //======================  الاسم الاول =================
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* الاسم الاول مطلوب";
                                }
                                if (value.length < 2) {
                                  return "*اجعله اكثر من 2 حرف";
                                }
                                if (value.length > 25) {
                                  return "*اجعله اقل من 25 حرف";
                                }
                                if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                    .hasMatch(value)) {
                                  return '* اجعلة حروف فقط';
                                }
                                return null;
                              },
                              controller: First_Name,
                              inputFormatters: [
                                // يسمح بالحروف العربية والإنجليزية فقط
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\u0621-\u064A]')),
                                // يمنع المسافات داخل الاسم
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                                // تحديد الحد الأقصى لعدد الأحرف
                                LengthLimitingTextInputFormatter(25),
                              ],
                              label: "الاسم الاول  ",
                              prefixIcon: Icon(Icons.person_2_outlined),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      p_input(
                        //======================   الايميل =================
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* الايميل مطلوب";
                          }
                          if (value.length < 5) {
                            return "* الايميل يجب ان يكون اكثر من 5 حروف";
                          }
                          if (value.length > 40) {
                            return "* الايميل يجب ان يكون اقل من 40 حروف";
                          }
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return "* صيغة البريد الإلكتروني غير صحيحة";
                          }
                          if (RegExp(r'(:|//|/|\\|\|\||\|)')
                              .hasMatch(value)) {
                            return "* الايميل لا يجب ان يحتوي (: , // , / , \\\\ , \\ , || , |)";
                          }
                          
                          return null;
                        },
                        controller: Email,
                        inputFormatters: [
                          // السماح بالحروف والأرقام وبعض رموز الإيميل
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9@._-]')),
                          // منع المسافات
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          // الحد الأقصى
                          LengthLimitingTextInputFormatter(40),
                        ],
                        label: "الايميل",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      p_input(
                        //======================   رقم الهاتف =================
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "*رقم الهاتف مطلوب";
                          }
                          // منع أي رموز غير +
                          if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                            return "رقم الهاتف يجب ان يحتوي فقط ارقام";
                          }
                          // التحقق من الصيغة اليمنية الصحيحة
                          if (!RegExp(r'^\+967(77|73|71|70)\d{7}$')
                              .hasMatch(value)) {
                            return "* ادخل رقم هاتف يمني صحيح (+967)";
                          }
                          if (RegExp(r'(:|//|/|\\|\|\||\|)')
                              .hasMatch(value)) {
                            return "رقم الهاتف لا يجب ان يحتوي على (: , // , / , \\\\ , \\ , || , |) ";
                          }
                          return null;
                        },
                        controller: Phone_num,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          // يسمح بالأرقام و +
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+]')),
                          // يسمح فقط ب + واحدة في البداية
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\+?[0-9]*')),
                          // الحد الأقصى لطول الرقم
                          LengthLimitingTextInputFormatter(13),
                        ],
                        label: "رقم الهاتف",
                        icon: 2,
                        suffixIcon: Icon(Icons.call),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      p_input(
                        //====================== رقم الهاتف  اختياري=================
                        validator: (value) {
                          if(value == null || value.trim().isEmpty){
                            return null;
                          }
                          // منع أي رموز غير +
                          if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                            return "رقم الهاتف يجب ان يحتوي فقط ارقام";
                          }
                          // التحقق من الصيغة اليمنية الصحيحة
                          if (!RegExp(r'^\+967(77|73|71|70)\d{7}$')
                              .hasMatch(value)) {
                            return "* ادخل رقم هاتف يمني صحيح (+967)";
                          }
                          if (RegExp(r'(:|//|/|\\|\|\||\|)')
                              .hasMatch(value)) {
                            return "رقم الهاتف لا يجب ان يحتوي على (: , // , / , \\\\ , \\ , || , |) ";
                          }
                          return null;
                        },
                        controller: Phone_num2,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          // يسمح بالأرقام و +
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+]')),
                          // يسمح فقط ب + واحدة في البداية
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\+?[0-9]*')),
                          // الحد الأقصى لطول الرقم
                          LengthLimitingTextInputFormatter(13),
                        ],
                        label: "رقم الهاتف (اختياري)",
                        icon: 2,
                        suffixIcon: Icon(Icons.call),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      p_button(
                        title: "تعديل",
                        onPressed: (){
                          if (formdata.currentState!.validate()){

                          }
                        },
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),


            


          ],
        ),
      ),


    );
  }
}