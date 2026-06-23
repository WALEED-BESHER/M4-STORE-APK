import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waleedo_app/Design%20System/Buttons/primary_button.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/AppBar/primary_appbar.dart';
import '../../constants/api.dart';
import '../../Design System/SnackBar/primary_snackbar.dart';

class AddFAQ extends StatefulWidget {
  const AddFAQ({super.key});

  @override
  State<AddFAQ> createState() => _AddFAQState();
}

Widget FAQinputs(
  String hint,
  int maxLines,
  TextEditingController control, {
  TextInputType keyboardType = TextInputType.text,
  int? minlines,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.dark2,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.g500),
    ),
    child: TextFormField(
      controller: control,
      style: fonts.ss.copyWith(color: color.white),
      keyboardType: keyboardType,
      cursorColor: color.p500,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      minLines: minlines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: fonts.sb.copyWith(color: color.g500),
        border: InputBorder.none,
      ),
    ),
  );
}

class _AddFAQState extends State<AddFAQ> {
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    question.dispose();
    answer.dispose();
    super.dispose();
  }

  Future<void> submitFaq() async {
    final q = question.text.trim();
    final a = answer.text.trim();
    if (q.isEmpty || a.isEmpty) {
      p_snackbar.show(
        context: context, 
        title: 'الرجاء إدخال السؤال والجواب',
        background: color.error,
        icon: Icons.cancel
      );
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse(Api.addFAQ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'question': q,
          'answer': a,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['status'] == true) {
        question.clear();
        answer.clear();
        p_snackbar.show(
          context: context, 
          title: 'تمت إضافة السؤال بنجاح',
        );
        Navigator.pop(context, true);
      } else {
        p_snackbar.show(
          context: context, 
          title: data['message'] ?? 'حدث خطأ أثناء الإضافة',
          background: color.error,
          icon: Icons.cancel
        );
      }
    } catch (e) {
      p_snackbar.show(
        context: context, 
        title: 'تعذر الاتصال بالسيرفر: $e',
        background: color.error,
        icon: Icons.cancel
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
              "السؤال",
              3,
              question,
              minlines: 1,
            ),
            const SizedBox(height: 24),
            FAQinputs(
              "الجواب",
              5,
              answer,
              minlines: 3,
            ),
            const SizedBox(height: 36),
            p_button(
              title: "اضافه السوال",
              onPressed: submitFaq,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}