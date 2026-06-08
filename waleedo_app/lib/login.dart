import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waleedo_app/constants/fonts.dart';
import 'constants/colors.dart';
import 'constants/check_inputs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/Buttons/primary_button.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'constants/api.dart';
import 'otp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool login_isLoading = false;
  bool signup_isLoading = false;

  //signup 
  TextEditingController First_Name = TextEditingController();
  TextEditingController Last_Name = TextEditingController();
  TextEditingController Phone_num = TextEditingController(text: "+967");
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Confirm_Password = TextEditingController();
  GlobalKey<FormState> formdata = GlobalKey<FormState>();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  String? Email_Ser_Error;
  String? Phone_Ser_Error;

  Future<void> _SignUP(BuildContext ctx) async {
    // تصفير أخطاء السيرفر القديمة
    setState(() {
      Email_Ser_Error = null;
      Phone_Ser_Error = null;
    });

    if (formdata.currentState!.validate()) {
      try {
        setState(() {
          signup_isLoading = true;
        });
        //فحص المدخلات
        String firstName = check_inputs.trim(First_Name.text);
        firstName = check_inputs.removeHtml(firstName);
        firstName = check_inputs.lettersOnly(firstName);

        String lastName = check_inputs.trim(Last_Name.text);
        lastName = check_inputs.removeHtml(lastName);
        lastName = check_inputs.lettersOnly(lastName);

        String email = check_inputs.sanitizeEmail(Email.text);
        email = check_inputs.removeSQLInjection(email);
        email = check_inputs.removeXSS(email);

        String phone_number = check_inputs.sanitizePhone(Phone_num.text);

        String password = check_inputs.sanitizePassword(Password.text);
        password = check_inputs.sha256Hash(password); // تشفير

        //ارسال البيانات الى laravel
        var url = Uri.parse(Api.signup);
        var response = await http
            .post(
              url,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
              },
              body: jsonEncode({
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "phone_number": phone_number,
                "password": password,
              }),
            )
            .timeout(const Duration(seconds: 15));

        // نجاح
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var data = jsonDecode(response.body); //

          p_snackbar.show(
            context: context,
            title: "تم إنشاء الحساب بنجاح",
            timer: Duration(seconds: 3),
          );

          await Future.delayed(const Duration(seconds: 2));
          DefaultTabController.of(ctx).animateTo(1);

          //تفريغ الحقول
          void clear() {
            First_Name.clear();
            Last_Name.clear();
            Phone_num.text = "+967";
            Email.clear();
            Password.clear();
            Confirm_Password.clear();
          }

          clear();
        }
        // أخطاء التحقق من Laravel
        else if (response.statusCode == 422) {
          var checking = jsonDecode(response.body);
          var errors = checking["errors"];

          setState(() {
            if (errors["email"] != null) {
              Email_Ser_Error =
                  "هذا البريد الإلكتروني مسجل من قبل، يرجى تغييره";
            }
            if (errors["phone_number"] != null) {
              Phone_Ser_Error = "رقم الهاتف هذا مسجل من قبل، يرجى تغييره";
            }
          });

          formdata.currentState!.validate();
        } else {
          throw Exception("Server Error");
        }
      } catch (e) {
        p_snackbar.show(
          context: context,
          title: "حدث خطأ: $e",
          timer: Duration(seconds: 3),
          background: color.error,
          icon: Icons.cancel,
        );
      }
      setState(() {
        signup_isLoading = false;
      });
    }
  }

//Login   
  TextEditingController login_Email = TextEditingController();
  TextEditingController login_Password = TextEditingController();
  GlobalKey<FormState> login_formdata = GlobalKey<FormState>();
  FocusNode loginEmailFocus = FocusNode();
  FocusNode loginPasswordFocus = FocusNode();

  Future<void> _login() async {
    if (login_formdata.currentState!.validate()) {
      setState(() {
        login_isLoading = true;
      });
      try {
        //فحص المدخلات
        String email = check_inputs.sanitizeEmail(login_Email.text);
        email = check_inputs.removeSQLInjection(email);
        email = check_inputs.removeXSS(email);

        String password = check_inputs.sanitizePassword(login_Password.text);
        password = check_inputs.sha256Hash(password);
        //ارسال البيانات الى laravel
        var url = Uri.parse(Api.login);
        var response = await http
            .post(
              url,
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
              },
              body: jsonEncode({
                "email": email,
                "password": password,
              }),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          var data = jsonDecode(response.body);
          // اذا عمليه تسجيل الدخول صحيحه
          if (data["status"] == "success") {
            String token = data["token"];
            String f_name = data["users"]["first_name"];
            int verification = data["verification"];
            int activation = data["activation"]; 
            SharedPreferences s = await SharedPreferences.getInstance();
            await s.setString("token", token);
            await s.setString("first_name", f_name);
            // فحص verification
            if (verification == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpPage(
                    email: email,
                  ),
                ),
              );
              p_snackbar.show(
                context: context,
                title: "يجب التحقق من البريد الإلكتروني قبل متابعة تسجيل الدخول",
                timer: Duration(seconds: 5),
                background: color.error,
                showIcon: false
              );
            }
            // فحص activation
            else {
              if (activation == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: color.dark1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        "تم حظر الحساب",
                        style: fonts.sb.copyWith(color: color.white),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        "حسابك مبند، يرجى التواصل مع الإدارة",
                        style: fonts.ss.copyWith(color: color.g200),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "حسناً",
                            style: fonts.mr.copyWith(color: color.p500),
                          ),
                        )
                      ],
                    );
                  },
                );
              } else {
                p_snackbar.show(
                  context: context,
                  title: 'مرحباً بك، تم تسجيل الدخول بنجاح',
                  timer: Duration(seconds: 3),
                );
                Navigator.of(context).pushReplacementNamed("home");
              }
            }
            // تفريغ الحقول
            void clear() {
              login_Email.clear();
              login_Password.clear();
            }
            clear();
          } 
          // اذا حصل خطاء اثناء تسجيل الدخول
          else {
            p_snackbar.show(
              context: context,
              title: data["message"] , // 'البريد الإلكتروني أو كلمة المرور خاطئة'
              timer: Duration(seconds: 5),
              background: color.error,
              icon: Icons.cancel,
            );
          }
        }
          
        else {
          throw Exception("Server Error");
        }
      } catch (e) {
        p_snackbar.show(
          context: context,
          title: "تعذر الاتصال بالخادم، تحقق من اتصال الإنترنت ثم أعد المحاولة",
          timer:const Duration(seconds: 5),
          background: color.error,
          icon: Icons.cancel,
        );
      }
      setState(() {
        login_isLoading = false;
      });
    }
  }

  TextEditingController forgot_Email = TextEditingController();
  GlobalKey<FormState> forgot_formdata = GlobalKey<FormState>();
  void forgotPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: color.dark1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: forgot_formdata,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر الرجوع
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: color.g200,
                      ),
                    ),
                  ),

                  // العنوان
                  Text(
                    "نسيت كلمة السر",
                    style: fonts.sb.copyWith(
                      color: color.white,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // الايميل
                  p_input(
                    controller: forgot_Email,
                    label: "ادخل ايميلك",
                    prefixIcon: Icon(Icons.email_outlined),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(40),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* الايميل مطلوب";
                      }
                      if (!value.contains("@")) {
                        return "* ادخل ايميل صحيح";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // زر ارسال
                  p_button(
                    title: "إرسال",
                    height: 40,
                    onPressed: () {
                      if (forgot_formdata.currentState!.validate()) {
                        Navigator.pop(context);

                        p_snackbar.show(
                          context: this.context,
                          title: "تم إرسال رابط استعادة كلمة المرور",
                          timer: Duration(seconds: 3),
                        );

                        forgot_Email.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();    
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        loginEmailFocus.requestFocus();
      }
    );
  }

  @override
  void dispose() {
    First_Name.dispose();
    Last_Name.dispose();
    Phone_num.dispose();
    Email.dispose();
    Password.dispose();
    Confirm_Password.dispose();
    login_Email.dispose();
    login_Password.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    loginEmailFocus.dispose();
    loginPasswordFocus.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: color.dark1,
          appBar: AppBar(
            backgroundColor: color.dark1,
            toolbarHeight: 100,
            title: Column(
              children: [
                SizedBox(
                    height: 100,
                    child: Image.asset(
                      "assets/images/Logo.png",
                      fit: BoxFit.contain,
                    )),
              ],
            ),
            centerTitle: true,
            bottom: TabBar(
              onTap: (index) {
                if(index == 0){
                  firstNameFocus.requestFocus();
                }else{
                  loginEmailFocus.requestFocus();
                }
              },
              labelStyle: fonts.sb.copyWith(color: color.white),
              unselectedLabelColor: color.g300,
              indicator: BoxDecoration(
                  color: color.p900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.p500, width: 4)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.only(bottom: 2, left: 15, right: 15),
              dividerColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              splashFactory: InkSparkle.splashFactory,
              enableFeedback: true,
              dragStartBehavior: DragStartBehavior.start,
              tabs: [
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 24,
                      ),
                      Text("انشاء حساب"),
                    ],
                  ),
                ),
                Tab(icon: Icon(Icons.login), text: "تسجيل دخول"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                // =============== SIGNUP start from here =================
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Form(
                  key: formdata,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
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
                                focusNode: lastNameFocus,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: (){FocusScope.of(context).requestFocus(emailFocus);},
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
                                focusNode: firstNameFocus,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: (){FocusScope.of(context).requestFocus(lastNameFocus);},
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
                          height: 10,
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
                            if (Email_Ser_Error != null) {
                              return Email_Ser_Error;
                            }
                            return null;
                          },
                          controller: Email,
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){FocusScope.of(context).requestFocus(phoneFocus);},
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
                          height: 10,
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
                            if (Phone_Ser_Error != null) {
                              return Phone_Ser_Error;
                            }
                            return null;
                          },
                          controller: Phone_num,
                          focusNode: phoneFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){FocusScope.of(context).requestFocus(passwordFocus);},
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
                          height: 10,
                        ),
                        p_input(
                          //======================   كلمه المرور =================
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* كلمة السر مطلوبة ";
                            }
                            if (value.length < 5) {
                              return "كلمه السر يجب ان تكون اكثر من 4 احرف  وارقام ورموز";
                            }
                            if (value.length > 30) {
                              return "كلمه السر يجب ان تكون اقل من 30 حرف  وارقام ورموز";
                            }
                            if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$_%]).{8,}$')
                                .hasMatch(value)) {
                              return "كلمة المرور يجب أن تحتوي على حرف كبير وصغير ورقم ورمز";
                            }
                            if (RegExp(r'(:|//|/|\\|\|\||\|)')
                                .hasMatch(value)) {
                              return "* كلمه السر يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                            }
                            return null;
                          },
                          controller: Password,
                          focusNode: passwordFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){FocusScope.of(context).requestFocus(confirmPasswordFocus);},
                          inputFormatters: [
                            // السماح للحروف الانجليزيه والارقام والرموز فقط
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9$_%]')),
                            // منع المسافات داخل كلمة المرور
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            // الحد الأقصى
                            LengthLimitingTextInputFormatter(30),
                          ],
                          label: "كلمه المرور ",
                          icon: 3,
                          prefixIcon: Icon(Icons.password_outlined),
                          hidden: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        p_input(
                          //====================== تاكيد كلمه المرور =================
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* تاكيد كلمة السر مطلوبة ";
                            }
                            if (value.length < 5) {
                              return "* تاكيد كلمه السر يجب ان تكون اكثر من 4 احرف  وارقام ورموز";
                            }
                            if (value.length > 30) {
                              return "* تاكيد كلمه السر يجب ان تكون اقل من 30 حرف  وارقام ورموز";
                            }
                            if (value != Password.text) {
                              return "*تاكيد كلمة المرور خطاء";
                            }
                            if (RegExp(r'(:|//|/|\\|\|\||\|)')
                                .hasMatch(value)) {
                              return "* تاكيد كلمه السر يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                            }
                            return null;
                          },
                          controller: Confirm_Password,
                          focusNode: confirmPasswordFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _SignUP(context) ,
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
                          prefixIcon: Icon(Icons.password_sharp),
                          hidden: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        p_button(
                          title: "إنشاء حساب",
                          onPressed: () => _SignUP(context),
                          isLoading: signup_isLoading,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                // =============== Login start from here =================
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Form(
                  key: login_formdata,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
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
                            if (!RegExp(r'[@]').hasMatch(value)) {
                              return '* يجب ان يحتوي الايميل ( @ )';
                            }
                            if (RegExp(r'(:|//|/|\\|\|\||\|)').hasMatch(value)) {
                              return "* الايميل لا يجب ان يحتوي (: , // , / , \\\\ , \\ , || , |)";
                            }
                            return null;
                          },
                          controller: login_Email,
                          focusNode: loginEmailFocus,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: (){FocusScope.of(context).requestFocus(loginPasswordFocus);},
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
                        SizedBox(
                          height: 20,
                        ),
                        p_input(
                          //======================   كلمه المرور =================
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* كلمة السر مطلوبة ";
                            }
                            if (value.length < 5) {
                              return "كلمه السر يجب ان تكون اكثر من 4 احرف  وارقام ورموز";
                            }
                            if (value.length > 30) {
                              return "كلمه السر يجب ان تكون اقل من 30 حرف  وارقام ورموز";
                            }
                            if (!RegExp(r'[$_%]').hasMatch(value)) {
                              return "* كلمه السر يجب ان تحتوي على (\$ _ %)";
                            }
                            if (RegExp(r'(:|//|/|\\|\|\||\|)').hasMatch(value)) {
                              return "* كلمه السر يجب ان لا تحتوي على (: , // , / , \\\\ , \\ , || , |)";
                            }
                            return null;
                          },
                          controller: login_Password,
                          focusNode: loginPasswordFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          inputFormatters: [
                            // السماح للحروف الانجليزيه والارقام والرموز فقط
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9$_%]')),
                            // منع المسافات داخل كلمة المرور
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            // الحد الأقصى
                            LengthLimitingTextInputFormatter(30),
                          ],
                          label: "كلمه المرور ",
                          icon: 3,
                          prefixIcon: Icon(Icons.password_outlined),
                          hidden: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              "نسيت كلمه المرور ؟",
                              style: fonts.ss.copyWith(color: color.g200),
                            ),
                            onPressed: forgotPasswordDialog,
                          ),
                        ),
                        p_button(
                          title: "تسجيل دخول",
                          onPressed: _login,
                          height: 40,
                          isLoading: login_isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
