import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waleedo_app/Design%20System/AppBar/primary_appbar.dart';
import 'constants/api.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/Buttons/primary_button.dart';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'constants/check_inputs.dart';
import 'package:flutter/services.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confortNewPasswordFocus = FocusNode();


  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      String password = check_inputs.sanitizePassword(newPass.text);
      password = check_inputs.sha256Hash(password);
      
      var url = Uri.parse(Api.resetPassword);
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": widget.email,
          "code": widget.code,
          "type": "forget-password",
          "password": password,
        }),
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        p_snackbar.show(
          context: context,
          title: data["message"],
          timer: const Duration(seconds: 3),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          "login",
          (route) => false,
        );
      } else {
        p_snackbar.show(
          context: context,
          title: data["message"],
          timer: const Duration(seconds: 3),
          background: color.error,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      p_snackbar.show(
        context: context,
        title: "حدث خطأ: $e",
        timer: const Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel,
      );
    }

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        newPasswordFocus.requestFocus();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "إعادة تعيين كلمة المرور",
        centerTheTitles: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity, 
          padding: EdgeInsets.symmetric(horizontal: 16 ,vertical: 28),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

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
                    return null;
                  },
                  controller: newPass,
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
                    if (value != newPass.text) {
                      return "*تاكيد كلمة المرور  ليست مطابقة";
                    }
                    if (RegExp(r'(:|//|/|\\|\|\||\|)')
                        .hasMatch(value)) {
                      return "* تاكيد كلمه المرور يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                    }
                    return null;
                  },
                  controller: confirmPass,
                  focusNode: confortNewPasswordFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => resetPassword() ,
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
                  onPressed:resetPassword,
                  height: 40,
                  isLoading: loading,
                ),



                
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}