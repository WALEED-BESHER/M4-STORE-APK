// import 'package:flutter/material.dart';
// import 'constants/colors.dart';
// import 'constants/fonts.dart';
// import 'Design System/AppBar/primary_appbar.dart';

// class FAQ extends StatefulWidget {
//   const FAQ({super.key});

//   @override
//   State<FAQ> createState() => _FAQState();
// }

// Widget QuestionBox(String Question,String Answar,bool show, VoidCallback onTap){
//   return Container(
//     width: double.infinity,
//     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
//     margin: EdgeInsets.symmetric(vertical: 6),
//     decoration: BoxDecoration(
//       color: color.dark2,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             InkWell(
//               onTap: onTap,
//               child: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Icon(
//                   show ? Icons.expand_less : Icons.expand_more,
//                   color: color.p,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Text(
//                 Question,
//                 textAlign: TextAlign.end,
//                 style: fonts.lb.copyWith(color: color.white),
//               ),
//             ),
//           ],
//         ),

//         if(show)
//         Divider(color: color.g600,height: 4,),
//         if(show)
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8,horizontal: 2),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   Answar,
//                   textAlign: TextAlign.end,
//                   style: fonts.sm.copyWith(color: color.g200),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class _FAQState extends State<FAQ> {
//   bool qes1 = false;


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color.dark1,
//       appBar: p_appbar(
//         title: "الاسلئه الشائعه",
//         centerTheTitles: true,
//       ),

//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
//           child: Column(
//             children: [

//               QuestionBox(
//                 "عنوان البوكس",
//                 "الاجابه", qes1,
//                 (){
//                   setState(() {
//                     qes1 = !qes1;
//                   });
//                 } 
//               ),

//             ],
//           ),
//         ),
//       ),

//     );
//   }
// }











import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

Widget questionBox({
  required String question,
  required String answer,
  required bool show,
  required VoidCallback onTap,
}) {
  return AnimatedSize(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: color.dark2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: show ? color.p.withOpacity(.35) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: show ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: color.p,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question,
                      textAlign: TextAlign.end,
                      style: fonts.lb.copyWith(
                        color: color.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (show) ...[
            const SizedBox(height: 6),
            Divider(color: color.g600, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    answer,
                    textAlign: TextAlign.end,
                    style: fonts.sm.copyWith(
                      color: color.g200,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

class _FAQState extends State<FAQ> {
  late List<FaqItem> faqs;

  @override
  void initState() {
    super.initState();

    faqs = [
      FaqItem(
        question: "ماهي الاسلحة",
        answer: "الاسلحة هي أدوات أو معدات مخصصة لأغراض محددة حسب النظام المعتمد.",
      ),
      FaqItem(
        question: "كيف استطيع ان ادفع",
        answer: "يمكنك الدفع من خلال وسائل الدفع المتاحة داخل التطبيق.",
      ),
      FaqItem(
        question: "كيف احذف حسابي",
        answer: "يمكنك حذف الحساب من صفحة الإعدادات أو من خلال الدعم الفني.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
      FaqItem(
        question: "كيف اضيف عنوان جديد",
        answer: "ادخل إلى صفحة العناوين ثم اضغط على إضافة عنوان جديد.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الاسئله الشائعه",
        centerTheTitles: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            for (int i = 0; i < faqs.length; i++)
              questionBox(
                question: faqs[i].question,
                answer: faqs[i].answer,
                show: faqs[i].isExpanded,
                onTap: () {
                  setState(() {
                    faqs[i].isExpanded = !faqs[i].isExpanded;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}