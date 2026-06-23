import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/AppBar/primary_appbar.dart';

class FaqManagment extends StatelessWidget {
  const FaqManagment({super.key});


  Widget sections (String title,IconData icon,VoidCallback link ,)
  {
    return Directionality(
      textDirection: TextDirection.rtl,  
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8,bottom: 8,right: 12,left: 4),
            margin: EdgeInsets.symmetric(vertical: 6),
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
                        child: Icon(icon,size: 24,color:color.white,),
                      ),
                      SizedBox(width: 8,),
                      Text(title,style: fonts.mb.copyWith(color: color.white),),
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "اداره الاسئله الشائعة",
        centerTheTitles: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              sections("اضافه اسئلة شائعة جديده", Icons.post_add, (){
                Navigator.pushNamed(context, "addfaq");
              }),

              sections("عرض الاسئلة الشائعة", Icons.question_answer_outlined, (){
                Navigator.pushNamed(context, "viewfaq");
              }),

            ],
          ),
        ),
      ),


    );
  }
}