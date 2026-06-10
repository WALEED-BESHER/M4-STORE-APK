import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
class CompleteInfomation extends StatefulWidget {
  const CompleteInfomation({super.key});

  @override
  State<CompleteInfomation> createState() => _CompleteInfomationState();
}

class _CompleteInfomationState extends State<CompleteInfomation> {

  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "اكمل معلوماتك",
        centerTheTitles: true,
      ),

      

      
    );
  }
}