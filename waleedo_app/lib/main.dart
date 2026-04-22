import 'package:flutter/material.dart';
import 'package:waleedo_app/account.dart';
import 'package:waleedo_app/bestselling.dart';
import 'package:waleedo_app/home.dart';
import 'package:waleedo_app/login.dart';
import 'package:waleedo_app/notification.dart';
import 'package:waleedo_app/orders.dart';
import 'package:waleedo_app/cart.dart';
import 'package:waleedo_app/otp.dart';
import 'package:waleedo_app/search.dart';

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
        "/":(context)=>Home(),
        "cart":(context)=>Cart(),
        "orders":(context)=>Orders(),
        "account":(context)=>Account(),
        "bestselling":(context)=>Bestselling(),
        "otp":(context)=>OtpPage(),
        "notifications":(context)=>Notifications(),
        "search":(context)=>SearchPage(),
      },
     
    );
  }
}
