import 'package:flutter/material.dart';
import 'Design System/Buttons/primary_button.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'cart_data.dart';
import 'Design System/BottamNavigationBar/buttomnavigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/api.dart';
import 'package:http/http.dart' as http;
import 'Design System/SnackBar/primary_snackbar.dart';
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}
//
Widget accountItems(
  String title,
  IconData icon,
  VoidCallback link ,
  {
    bool? showDotedBorder, 
    bool? showdrapdown, 
    VoidCallback? moveDown ,
    String title1 ="",
    IconData? icon1,
    VoidCallback? link1 ,
    bool show2 = false,
    String title2 = "",
    IconData? icon2,
    VoidCallback? link2 ,
    bool show3 = false,
    String title3 ="",
    IconData? icon3,
    VoidCallback? link3 ,
    bool logout = false,
  })
  {
  bool trying = showdrapdown ?? false;
  VoidCallback come = moveDown ?? (){};
  bool show = showDotedBorder ?? false;

  return Directionality(
    textDirection: TextDirection.rtl, 
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [


        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 8,bottom: 8,right: 12,left: 4),
          margin: trying ? EdgeInsets.only(top: 6,bottom: 1) : EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color.dark2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: link,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // الايقونه + النص
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr, 
                      child: Icon(icon,size: 24,color: logout ? color.error : color.white,),
                    ),
                    SizedBox(width: 8,),
                    Text(title,style: fonts.mb.copyWith(color: logout ? color.error : color.white),),
                  ],
                ),
                
                if(show)
                InkWell(
                  onTap: come ,
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      trying ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: color.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if(trying)
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 2,bottom: 2,right: 14,left: 20),
          margin: trying ? EdgeInsets.symmetric(vertical: 1) : EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color.dark1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // suggestion 1
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  onTap: link1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon1,size: 24,color: color.white,),
                      SizedBox(width: 8,),
                      Text(title1,style: fonts.mb.copyWith(color: color.white),),
                    ],
                  ),
                ),
              ),

              // suggestion 2
              if(show2)
              Divider(height: 8,color: color.g400,),
              if(show2)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  onTap: link2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon2,size: 24,color: color.white,),
                      SizedBox(width: 8,),
                      Text(title2,style: fonts.mb.copyWith(color: color.white),),
                    ],
                  ),
                ),
              ),

              // suggestion 3
              if(show3)
              Divider(height: 8,color: color.g400,),
              if(show3)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  onTap: link3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon3,size: 24,color: color.white,),
                      SizedBox(width: 8,),
                      Text(title3,style: fonts.mb.copyWith(color: color.white),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}





class _AccountState extends State<Account> {
  bool showSecuirity = false;
  bool showSupport = false;

  int get cartSize {
    int cartCount = 0;
    for (var item in CartData.cartItems) {
      cartCount += item["quantity"] as int;
    }
    return cartCount;
  }
  
  void showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: color.dark2,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الخط الصغير فوق
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 8),
                // عنوان Logout
                Text(
                  "Logout",
                  style: fonts.h4.copyWith(color: color.error),
                ),
                const SizedBox(height: 8),
                // الخط الفاصل
                Divider(
                  height: 2,
                  color: Colors.white10,
                ),
                const SizedBox(height: 12),
                // النص
                Text(
                  "هل انت متأكد انك تريد تسجيل خروج",
                  textAlign: TextAlign.center,
                  style: fonts.lm.copyWith(color: color.white),
                ),
                const SizedBox(height: 20),
                // الأزرار
                Row(
                  children: [
                    // زر الغاء
                    Expanded(
                      child:  p_button(
                        title: "الغاء", 
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        height: 55,
                        background: color.dark1,
                        fontType: fonts.ms,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // زر نعم
                    Expanded(
                      child:  p_button(
                        title: "نعم", 
                        onPressed: logout,
                        height: 55,
                        background: color.error,
                        fontType: fonts.ms,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    try {
      SharedPreferences s = await SharedPreferences.getInstance();
      String? token = s.getString("token");
      var url = Uri.parse(Api.logout);
      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await s.remove("token");
        await s.remove("first_name");
        p_snackbar.show(
          context: context,
          title: "تم تسجيل خروجك بنجاح",
          timer: Duration(seconds: 3),
        );
        // الانتقال الى login
        Navigator.of(context).pushNamedAndRemoveUntil(
          "login",
          (route) => false,
        );
      }
      // else{
      //   SharedPreferences s = await SharedPreferences.getInstance();
      //   await s.remove("token");
      //   await s.remove("first_name");
      //   await s.remove("user_id");
        
      //   p_snackbar.show(
      //     context: context,
      //     title: "تم تسجيل خروجك بنجاح",
      //     timer: Duration(seconds: 3),
      //   );
      //   // الانتقال الى login
      //   Navigator.of(context).pushNamedAndRemoveUntil(
      //     "login",
      //     (route) => false,
      //   );

      // }
    } catch (e) {
      p_snackbar.show(
        context: context,
        title: "تعذر الاتصال بالخادم، تحقق من اتصال الإنترنت ثم أعد المحاولة",
        timer:const Duration(seconds: 5),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Checking();
  }

  //
  bool isLoading = true;
  int admin = 0;
  String? f_name;
  String? l_name;
  String? Phone_num;
  Future<void> Checking() async{
    try{
      SharedPreferences s = await SharedPreferences.getInstance();
      String? token = s.getString("token");
      var response = await http.get(
        Uri.parse(Api.profile),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var data = jsonDecode(response.body);
      if (data["status"] == "success"){
        var user = data["user"];
        setState(() {
          admin = user["admin"];
          f_name = user["first_name"];
          l_name = user["last_name"];
          Phone_num = user["phone_number"];
          isLoading = false;
        });
      }
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }
    
  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Scaffold(
        backgroundColor: color.dark1,
        body: Center(
          child: CircularProgressIndicator(color: color.p500,),
        ),
      );
    }

    return Scaffold(
      backgroundColor: color.dark1, 

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // profile box
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40,bottom: 10),
                      padding: const EdgeInsets.only(
                        top: 65,
                        right: 16,
                        left: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: color.dark2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          // اسم المستخدم
                          Text(
                            "${f_name} ${l_name}",
                            style: fonts.lb.copyWith(color: color.white),
                          ),
                          const SizedBox(height: 10),
                          /// الصندوق الداخلي
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 34,
                            ),
                            decoration: BoxDecoration(
                              color: color.dark1,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // عدد الطلبات
                                Column(
                                  children:  [
                                    Text(
                                      "عدد الطلبات",
                                      style: fonts.mb.copyWith(color: color.g400),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "0",
                                      style: fonts.mb.copyWith(color: color.g400),
                                    ),
                                  ],
                                ),

                                // الخط بالنص
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: color.g600,
                                ),
                                // رقم الهاتف
                                Column(
                                  children: [
                                    Text(
                                      "رقمك",
                                      style: fonts.mb.copyWith(color: color.g400),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      Phone_num ?? "",
                                      style: fonts.mb.copyWith(color: color.g400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// الصورة الخارجية
                    Positioned(
                      top: 10,
                      right: 0,
                      left: 0,
                      child: Center(
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: color.p500,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: color.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // الملف الشخصي
              accountItems(
                "تعديل الملف الشخصي",
                Icons.person_outline,
                (){
                  Navigator.pushNamed(context, "profile");
                },
              ),
              // المفضلة
              accountItems(
                "المفضلة",
                Icons.favorite_border,
                (){
                  Navigator.pushNamed(context, "favorites");
                },
              ),
              // عناوين التوصيل
              accountItems(
                "عناوين التوصيل",
                Icons.location_on_outlined,
                (){},
              ),
              // الخصوصيه والامان
              accountItems(
                "الخصوصيه والامان",
                Icons.security_outlined,
                (){
                  setState(() {
                    showSecuirity = !showSecuirity;
                  });
                },
                showDotedBorder: true,
                showdrapdown: showSecuirity,
                moveDown: (){
                  setState(() {
                    showSecuirity = !showSecuirity;
                  });
                },
                title1: "تغسر كلمه المرور",
                icon1: Icons.password_outlined,
                link1: (){
                  Navigator.pushNamed(context, "changepassword");
                },
                show2: true,
                title2: "الشروط والاحكام",
                icon2: Icons.description_outlined,
                link2: (){} 
              ),
              // الدعم والمساعده
              accountItems(
                "الدعم والمساعده", 
                Icons.headset_mic_outlined, 
                (){
                  setState(() {
                    showSupport = !showSupport;
                  });
                },
                showDotedBorder: true,
                showdrapdown: showSupport,
                moveDown: () {
                  setState(() {
                    showSupport = !showSupport;
                  });
                },
                title1: "خدمه العملاء",
                icon1: Icons.support_agent_outlined,
                link1: () async {
                  // final Uri whatsappUri = Uri.parse(
                  //   "https://wa.me/967770411921",
                  // );
                  // if (await canLaunchUrl(whatsappUri)) {
                  //   await launchUrl(
                  //     whatsappUri,
                  //     mode: LaunchMode.externalApplication,
                  //   );
                  // } else {
                  //   print("واتساب غير متوفر");
                  // }
                },
                show2: true,
                title2: "مواقع التواصل",
                icon2: Icons.public_outlined ,
                link2: (){},
                show3: true,
                title3: "770411921",
                icon3: Icons.phone_outlined ,
                link3: () async{
                  // final Uri phoneUri = Uri(
                  //   scheme: 'tel',
                  //   path: '770411921',
                  // );
                  // await launchUrl(phoneUri);
                },
              ),
              // الاسئله الشاىعه
              accountItems(
                "الاسئله الشاىعه (FAQ)",
                Icons.help_outline,
                (){},
              ),
              // عن التطبيق
              accountItems(
                "عن التطبيق",
                Icons.info_outline,
                (){},
              ),
              if(admin == 1)
              accountItems(
                "ادمن",
                Icons.admin_panel_settings_outlined,
                (){
                  Navigator.pushNamed(context, "admin");
                },
              ),
              // تسجيل خروج
              accountItems(
                "تسجيل خروج",
                Icons.logout_outlined,
                (){
                  showLogoutSheet(context);
                },
                logout: true
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavbar(currentIndex: 0, cartSize: cartSize.toDouble(),),
    );
  }
}