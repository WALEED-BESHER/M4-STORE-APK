import 'package:flutter/material.dart';
import 'account.dart';
import 'login.dart';
import 'notification.dart';
import 'orders.dart';
import 'cart.dart';
import 'search.dart';
import 'checkout.dart';
import 'edit_cart.dart';
import 'Home/home.dart';
import 'profile.dart';
import 'splash.dart';
import 'Welcome.dart';
import 'Admin/admin.dart';
import 'Admin/product_managment.dart';
import 'Admin/Product Managment Section/add_products.dart';
import 'Admin/Product Managment Section/view_products.dart';
import 'Admin/user_managment.dart';
import 'favorites.dart';
import 'complete_information.dart';
import 'change_password.dart';
import 'terms_conditions.dart';
import 'socail_media.dart';
import 'locations_management.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),


      routes: {
        "login":(context)=>Login(),
        "home":(context)=>Home(),
        "cart":(context)=>Cart(),
        "orders":(context)=>Orders(),
        "account":(context)=>Account(),
        "notifications":(context)=>Notifications(),
        "search":(context)=>SearchPage(),
        "checkout":(context)=>Checkout(),
        "editcart":(context)=>editCart(),
        "profile":(context)=>Profile(),
        "/":(context)=>Splash(),
        "welcome":(context)=>Welcome(),
        "admin":(context)=>Admin(),
        "productmanagment":(context)=>ProductManagment(),
        "addproducts":(context)=>AddProducts(),
        "viewproducts":(context)=>ViewProducts(),
        "usermanagment":(context)=>UserManagment(),
        "favorites":(context)=>Favorites(),
        "changepassword":(context)=>ChangePassword(),
        "termsconditions":(context)=>TermsConditions(),
        "socailmedia":(context)=>SocailMedia(),
        "completeinformation":(context)=>CompleteInfomation(),
        "locationsmanagement":(context)=>LocationsManagement(),
        
      },
     
    );
  }
}
