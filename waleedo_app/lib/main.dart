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
        "/":(context)=>Login(),
        "home":(context)=>Home(),
        "cart":(context)=>Cart(),
        "orders":(context)=>Orders(),
        "account":(context)=>Account(),
        "notifications":(context)=>Notifications(),
        "search":(context)=>SearchPage(),
        "checkout":(context)=>Checkout(),
        "editcart":(context)=>editCart(),
        "profile":(context)=>Profile(),
      },
     
    );
  }
}
