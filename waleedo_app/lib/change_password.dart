import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/check_inputs.dart';
import 'package:flutter/services.dart';
import 'Design System/Buttons/primary_button.dart';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants/api.dart';
import 'Design System/SnackBar/primary_snackbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool changePasswordLoading = false;
  String? oldPasswordServerError;

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confortNewPassword = TextEditingController();
  GlobalKey<FormState> changePassword = GlobalKey<FormState>();
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confortNewPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        oldPasswordFocus.requestFocus();
      }
    );
  }
  // داله تغير لكمه السر 
  Future<void> ChangePassword() async{
    setState(() {
      oldPasswordServerError = null;
    });
    if (changePassword.currentState!.validate()) {
      setState(() {
        changePasswordLoading = true;
      });
      try{
        String Old_Password = check_inputs.sanitizePassword(oldPassword.text);
        Old_Password = check_inputs.sha256Hash(Old_Password);

        String New_Password = check_inputs.sanitizePassword(newPassword.text);
        New_Password = check_inputs.sha256Hash(New_Password);

        SharedPreferences s = await SharedPreferences.getInstance();
        String? token = s.getString("token");

        var response = await http.post(
          Uri.parse(Api.changepassword),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "oldpassword":Old_Password ,
            "newpassword": New_Password,
          }),
        ).timeout(const Duration(seconds: 15));

        // if (response.statusCode >= 200 && response.statusCode < 300){}

        var data =jsonDecode(response.body);
        if(data["status"] == "success"){
          p_snackbar.show(
            context: context,
            title: "تم تغيير كلمة المرور بنجاح",
            timer: Duration(seconds: 3),
          );
          oldPassword.clear();
          newPassword.clear();
          confortNewPassword.clear();
          Navigator.pop(context);
        }
        else{
          setState(() {
            oldPasswordServerError = data["message"];
          });
          changePassword.currentState!.validate();
        }
      }
      catch(e){
        p_snackbar.show(
          context: context,
          title: "تعذر الاتصال بالخادم",
          background: color.error,
        );
      }
      setState(() {
        changePasswordLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "تغير كلمة المرور",
        centerTheTitles: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16 ,vertical: 28),
          child: Form(
            key: changePassword,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //================== كلمه المرور القديمه =================
                p_input(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* يرجى ادخال كلمة المرور السابقه ";
                    }
                    if (value.length < 5) {
                      return "كلمه المرور السابقه يجب ان تكون اكثر من 4 احرف  وارقام ورموز";
                    }
                    if (value.length > 30) {
                      return "كلمه المرور السابقه يجب ان تكون اقل من 30 حرف  وارقام ورموز";
                    }
                    if (RegExp(r'(:|//|/|\\|\|\||\|)')
                        .hasMatch(value)) {
                      return "* كلمه المرور يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                    }
                    if(oldPasswordServerError != null){
                      return oldPasswordServerError;
                    }
                    return null;
                  },
                  controller: oldPassword,
                  focusNode: oldPasswordFocus,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){FocusScope.of(context).requestFocus(newPasswordFocus);},
                  inputFormatters: [
                    // السماح للحروف الانجليزيه والارقام والرموز فقط
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9$_%]')),
                    // منع المسافات داخل كلمة المرور
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    // الحد الأقصى
                    LengthLimitingTextInputFormatter(30),
                  ],
                  label: "كلمه المرور السابقه",
                  icon: 3,
                  prefixIcon: Icon(Icons.password_outlined),
                  hidden: true,
                ),

                const SizedBox(
                  height: 16,
                ),

                //====================== كلمه المرور  الجديده=================
                p_input(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* يرجى ادخال كلمة المرور الجديده ";
                    }
                    if (value.length < 5) {
                      return "كلمه المرور الجديده يجب ان تكون اكثر من 4 احرف  وارقام ورموز";
                    }
                    if (value.length > 30) {
                      return "كلمه المرور الجديده يجب ان تكون اقل من 30 حرف  وارقام ورموز";
                    }
                    if (!RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$_%]).{8,}$')
                        .hasMatch(value)) {
                      return "كلمة المرور الجديده يجب أن تحتوي على حرف كبير وصغير ورقم ورمز";
                    }
                    if (RegExp(r'(:|//|/|\\|\|\||\|)')
                        .hasMatch(value)) {
                      return "* كلمه المرور الجديده يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                    }
                    if(value == oldPassword.text){
                      return "* كلمه السعر هذه قد استخدمت من قبل";
                    }
                    return null;
                  },
                  controller: newPassword,
                  focusNode: newPasswordFocus,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: (){FocusScope.of(context).requestFocus(confortNewPasswordFocus);},
                  inputFormatters: [
                    // السماح للحروف الانجليزيه والارقام والرموز فقط
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9$_%]')),
                    // منع المسافات داخل كلمة المرور
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    // الحد الأقصى
                    LengthLimitingTextInputFormatter(30),
                  ],
                  label: "كلمه المرور الجديده",
                  icon: 3,
                  prefixIcon: Icon(Icons.password_outlined),
                  hidden: true,
                ),

                const SizedBox(
                  height: 16,
                ),

                //====================== تاكيد كلمه المرور الجديده=================
                p_input(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* يرجى ادخال تاكيد كلمة المرور الجديده ";
                    }
                    if (value != newPassword.text) {
                      return "*تاكيد كلمة المرور  ليست مطابقة";
                    }
                    if (RegExp(r'(:|//|/|\\|\|\||\|)')
                        .hasMatch(value)) {
                      return "* تاكيد كلمه المرور يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                    }
                    return null;
                  },
                  controller: confortNewPassword,
                  focusNode: confortNewPasswordFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => ChangePassword() ,
                  inputFormatters: [
                    // السماح للحروف الانجليزيه والارقام والرموز فقط
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9$_%]')),
                    // منع المسافات داخل كلمة المرور
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    // الحد الأقصى
                    LengthLimitingTextInputFormatter(30),
                  ],
                  label: "تاكيد كلمه المرور ",
                  icon: 3,
                  prefixIcon: Icon(Icons.check),
                  hidden: true,
                ),

                const SizedBox(
                  height: 24,
                ),

                p_button(
                  title: "تغير",
                  onPressed:ChangePassword,
                  height: 40,
                  isLoading: changePasswordLoading,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}