// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:waleedo_app/Design%20System/Buttons/primary_button.dart';
// import '../../constants/colors.dart';
// import '../../constants/fonts.dart';
// import '../../Design System/AppBar/primary_appbar.dart';
// import '../../constants/api.dart';
// import '../../Design System/SnackBar/primary_snackbar.dart';


// class ViewFAQ extends StatefulWidget {
//   const ViewFAQ({super.key});

//   @override
//   State<ViewFAQ> createState() => _ViewFAQState();
// }

// Widget questionBox({
//   required String question,
//   required String answer,
//   required bool show,
//   required VoidCallback onTap,
// }) {
//   return AnimatedSize(
//     duration: const Duration(milliseconds: 250),
//     curve: Curves.easeInOut,
//     child: Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         color: color.dark2,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: show ? color.p.withOpacity(.35) : Colors.transparent,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.20),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(14),
//             onTap: onTap,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6),
//               child: Row(
//                 children: [
//                   AnimatedRotation(
//                     turns: show ? 0.5 : 0.0,
//                     duration: const Duration(milliseconds: 250),
//                     child: Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       color: color.p,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       question,
//                       textAlign: TextAlign.end,
//                       style: fonts.lb.copyWith(
//                         color: color.white,
//                         height: 1.3,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           if (show) ...[
//             const SizedBox(height: 6),
//             Divider(color: color.g600, height: 1),
//             const SizedBox(height: 10),

//             // هنا المطلوب 

//             const SizedBox(height: 10),
//             Divider(color: color.g600, height: 1),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     answer,
//                     textAlign: TextAlign.end,
//                     style: fonts.sm.copyWith(
//                       color: color.g200,
//                       height: 1.6,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     ),
//   );
// }

// class _ViewFAQState extends State<ViewFAQ> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       backgroundColor: color.dark1,
//       appBar: p_appbar(
//         title: "عرض الاسئله الشائعه",
//         centerTheTitles: true,
//       ),

//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/AppBar/primary_appbar.dart';
import '../../constants/api.dart';
import '../../Design System/SnackBar/primary_snackbar.dart';

class ViewFAQ extends StatefulWidget {
  const ViewFAQ({super.key});

  @override
  State<ViewFAQ> createState() => _ViewFAQState();
}

class FaqItem {
  final int id;
  final String question;
  final String answer;
  final bool status;
  bool isExpanded;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    this.isExpanded = false,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      status: json['status'] == 1 || json['status'] == true,
    );
  }
}

Widget questionBox({
  required String question,
  required String answer,
  required bool show,
  required bool status,
  required VoidCallback onTap,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  required VoidCallback onToggle,
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

          // هنا المطلوب
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                color: color.p,
                tooltip: 'تعديل',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                color: color.error,
                tooltip: 'حذف',
              ),
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  status ? Icons.toggle_on : Icons.toggle_off,
                ),
                color: status ? Colors.greenAccent : color.g500,
                tooltip: status ? 'ايقاف' : 'تفعيل',
              ),
            ],
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

class _ViewFAQState extends State<ViewFAQ> {
  List<FaqItem> faqs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse(Api.getFAQ),
        headers: {'Accept': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List items = data['data'] ?? [];
        setState(() {
          faqs = items.map((e) => FaqItem.fromJson(e)).toList();
        });
      } else {
        setState(() {
          errorMessage = data['message'] ?? 'حدث خطأ أثناء جلب الأسئلة';
        });
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'حدث خطأ أثناء جلب الأسئلة',
          background: color.error,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'تعذر الاتصال بالسيرفر: $e';
      });
      p_snackbar.show(
        context: context,
        title: 'تعذر الاتصال بالسيرفر: $e',
        background: color.error,
        icon: Icons.cancel,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateFaq(FaqItem item, String newQuestion, String newAnswer) async {
    try {
      final response = await http.put(
        Uri.parse(Api.updateFAQ(item.id)),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'question': newQuestion,
          'answer': newAnswer,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        await fetchFaqs();
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'تم التعديل بنجاح',
          background: color.success,
          icon: Icons.check_circle,
        );
      } else {
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'فشل التعديل',
          background: color.error,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      p_snackbar.show(
        context: context,
        title: 'تعذر الاتصال بالسيرفر: $e',
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  Future<void> deleteFaq(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(Api.deleteFAQ(id)),
        headers: {'Accept': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        setState(() {
          faqs.removeWhere((e) => e.id == id);
        });
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'تم الحذف بنجاح',
          background: color.success,
          icon: Icons.check_circle,
        );
      } else {
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'فشل الحذف',
          background: color.error,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      p_snackbar.show(
        context: context,
        title: 'تعذر الاتصال بالسيرفر: $e',
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  Future<void> toggleFaqStatus(FaqItem item) async {
    try {
      final response = await http.post(
        Uri.parse(Api.toggleFAQStatus(item.id)),
        headers: {'Accept': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        await fetchFaqs();
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'تم التحديث',
          background: color.success,
          icon: Icons.check_circle,
        );
      } else {
        p_snackbar.show(
          context: context,
          title: data['message'] ?? 'فشل التحديث',
          background: color.error,
          icon: Icons.cancel,
        );
      }
    } catch (e) {
      p_snackbar.show(
        context: context,
        title: 'تعذر الاتصال بالسيرفر: $e',
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  Future<void> showEditDialog(FaqItem item) async {
    TextEditingController questionController = TextEditingController(text: item.question);
    TextEditingController answerController = TextEditingController(text: item.answer);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool loading = false;

        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              backgroundColor: color.dark2,
              title: Text(
                'تعديل السؤال',
                textAlign: TextAlign.center,
                style: fonts.lb.copyWith(color: color.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: questionController,
                      textAlign: TextAlign.right,
                      style: fonts.sm.copyWith(color: color.white),
                      decoration: InputDecoration(
                        hintText: 'السؤال',
                        hintStyle: fonts.sm.copyWith(color: color.g500),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: answerController,
                      textAlign: TextAlign.right,
                      maxLines: 4,
                      style: fonts.sm.copyWith(color: color.white),
                      decoration: InputDecoration(
                        hintText: 'الجواب',
                        hintStyle: fonts.sm.copyWith(color: color.g500),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: fonts.sb.copyWith(color: color.g200),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.p,
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          final q = questionController.text.trim();
                          final a = answerController.text.trim();

                          if (q.isEmpty || a.isEmpty) {
                            p_snackbar.show(
                              context: context,
                              title: 'الرجاء تعبئة السؤال والجواب',
                              background: color.error,
                              icon: Icons.cancel,
                            );
                            return;
                          }

                          setLocalState(() => loading = true);
                          await updateFaq(item, q, a);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'حفظ',
                          style: fonts.sb.copyWith(color: color.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showDeleteDialog(FaqItem item) async {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: color.dark2,
          title: Text(
            'حذف السؤال',
            textAlign: TextAlign.center,
            style: fonts.lb.copyWith(color: color.white),
          ),
          content: Text(
            'هل تريد حذف هذا السؤال نهائيًا؟',
            textAlign: TextAlign.center,
            style: fonts.sm.copyWith(color: color.g200),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: fonts.sb.copyWith(color: color.g200),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color.error),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await deleteFaq(item.id);
              },
              child: Text(
                'حذف',
                style: fonts.sb.copyWith(color: color.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "عرض الاسئله الشائعه",
        centerTheTitles: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchFaqs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(color: color.p500),
                  ),
                )
              : errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: fonts.sm.copyWith(color: color.white),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < faqs.length; i++)
                          questionBox(
                            question: faqs[i].question,
                            answer: faqs[i].answer,
                            show: faqs[i].isExpanded,
                            status: faqs[i].status,
                            onTap: () {
                              setState(() {
                                faqs[i].isExpanded = !faqs[i].isExpanded;
                              });
                            },
                            onEdit: () => showEditDialog(faqs[i]),
                            onDelete: () => showDeleteDialog(faqs[i]),
                            onToggle: () => toggleFaqStatus(faqs[i]),
                          ),
                        if (faqs.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Text(
                                'لا توجد أسئلة حالياً',
                                style: fonts.lb.copyWith(color: color.g200),
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}