import 'package:flutter/material.dart';
class color{
  //p
  static const Color p = Color(0xFFFF0000);
  static const Color p50 = Color(0xFFFFEBEE);
  static const Color p100 = Color(0xFFFFCDD2);
  static const Color p200 = Color(0xFFEF9A9A);
  static const Color p300 = Color(0xFFE57373);
  static const Color p400 = Color(0xFFEF5350);
  static const Color p500 = Color(0xFFE53935);
  static const Color p600 = Color(0xFFD32F2F);
  static const Color p700 = Color(0xFFC62828);
  static const Color p800 = Color(0xFFB71C1C);
  static const Color p900 = Color(0xFF8E0000);


  //secondary
  static const Color secondary50 = Color(0xFFFFF8E1);
  static const Color secondary100 = Color(0xFFFFECB3);
  static const Color secondary200 = Color(0xFFFFE082);
  static const Color secondary300 = Color(0xFFFFD54F);
  static const Color secondary400 = Color(0xFFFFCA28);
  static const Color secondary500 = Color(0xFFFFC107);
  static const Color secondary600 = Color(0xFFFFB300);
  static const Color secondary700 = Color(0xFFFFA000);
  static const Color secondary800 = Color(0xFFFF8F00);
  static const Color secondary900 = Color(0xFFFF6F00);

  //Greyscale
  static const Color g50 = Color(0xFFFAFAFA);
  static const Color g100 = Color(0xFFF5F5F5);
  static const Color g200 = Color(0xFFEEEEEE);
  static const Color g300 = Color(0xFFE0E0E0);
  static const Color g400 = Color(0xFFBDBDBD);
  static const Color g500 = Color(0xFF9E9E9E);
  static const Color g600 = Color(0xFF757575);
  static const Color g700 = Color(0xFF616161);
  static const Color g800 = Color(0xFF424242);
  static const Color g900 = Color(0xFF212121);
  
  //Dark
  static const Color dark1 = Color(0xFF181A20);
  static const Color dark2 = Color(0xFF1F222A);
  static const Color dark3 = Color(0xFF35383F);

  //Background
  static Color b_defultred = p500.withOpacity(0.1);
  static Color b_hoverdred = p600.withOpacity(0.3);
  static Color b_activered = p700.withOpacity(0.5);
  static Color b_defultgrey = g500.withOpacity(0.1);
  static Color b_hovergrey = g600.withOpacity(0.1);
  static Color b_activegrey = g700.withOpacity(0.1);
  static Color b_white = white.withOpacity(0.05);

  //Alert & Status
  static const Color success = Color(0xFF1BAC4B);
  static const Color info = Color(0xFF246BFD);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFC62828);
  static const Color disabled = Color(0xFFD8D8D8);

  //Gradient
  static const LinearGradient gRed = LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Color(0xFFE53935),Color(0xFFFF6F61)]);
  static const LinearGradient gYellow = LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [ Color(0xFFFFC107), Color(0xFFFFE082),],);
  static const LinearGradient gMix = LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [ Color(0xFF181A20),Color(0xFFE53935),],);
  static const LinearGradient gDark = LinearGradient(begin: Alignment.topLeft,  end: Alignment.bottomRight,  colors: [ Color(0xFF181A20), Color(0xFF35383F), ],);
  static const LinearGradient gBlack = LinearGradient(
  begin: Alignment.bottomCenter,end: Alignment.topCenter,colors: [Color(0xFF000000),Color(0x00000000),],stops: [0.0,1.0,],);
  static const LinearGradient gSoftRed = LinearGradient( begin: Alignment.topLeft,end: Alignment.bottomRight,  colors: [  Color(0xFFFFCDD2),Color(0xFFE53935),],);


  //Transparent
  static Color tRed = p400.withOpacity(0.8);
  static Color tYellow = secondary500.withOpacity(0.1);
  static Color tGreen = success.withOpacity(0.1);
  static Color tBlue = info.withOpacity(0.1);

  //files
  static const Color base_primary = Color(0xFF787878);
  static Color f_primary = base_primary.withOpacity(0.2);
  static const Color base_secondary = Color(0xFF787880);
  static Color f_secondary = base_secondary.withOpacity(0.16);



  //others
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFffffff);
 
}