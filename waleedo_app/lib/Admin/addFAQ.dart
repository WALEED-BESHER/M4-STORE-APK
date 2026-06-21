import 'package:flutter/material.dart';
import 'package:waleedo_app/Design%20System/Buttons/primary_button.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/AppBar/primary_appbar.dart';
class AddFAQ extends StatefulWidget {
  const AddFAQ({super.key});

  @override
  State<AddFAQ> createState() => _AddFAQState();
}




Widget FAQinputs(
    String hint, 
    int maxLines,
    TextEditingController control,
    {
      TextInputType keyboardType = TextInputType.text,
      int ? minlines,
    }
  ){
    return Container(
      padding:EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.dark2,
        borderRadius:BorderRadius.circular(12),
        border: Border.all(
          color: color.g500,
        ),
      ),
      child: TextFormField(
        controller: control,
        style: fonts.ss.copyWith(
          color: color.white,
        ),
        keyboardType: keyboardType,
        cursorColor: color.p500,
        textAlign: TextAlign.right,
        textDirection:  TextDirection.rtl,
        maxLines: maxLines,
        minLines: minlines,
        decoration: InputDecoration(
          // isCollapsed: true,
          hintText: hint,
          hintStyle: fonts.sb.copyWith(
            color: color.g500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }





class _AddFAQState extends State<AddFAQ> {
  TextEditingController question = TextEditingController();
  TextEditingController answer = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "اضافه الاسئله الشائعه",
        centerTheTitles: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            FAQinputs(
              "السوال",
              20,
              question,
              minlines: 1
            ),
            SizedBox(height: 24,),
            FAQinputs(
              "الجواب",
              30,
              answer,
              minlines: 1
            ),

            SizedBox(height: 36,),

            p_button(title: "اضافه السوال", onPressed: (){})

          ],
        ) ,
      ),

    );
  }
}