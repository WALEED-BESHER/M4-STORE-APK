import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'constants/api.dart';
import 'Design System/SnackBar/primary_snackbar.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class FaqItem {
  final int id;
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
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
        Uri.parse(Api.getActiveFAQ),
        headers: {
          'Accept': 'application/json',
        },
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
            icon: Icons.cancel);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'تعذر الاتصال بالسيرفر: $e';
      });
      p_snackbar.show(
          context: context,
          title: 'تعذر الاتصال بالسيرفر: $e',
          background: color.error,
          icon: Icons.cancel);
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
        title: "الاسئله الشائعه",
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
                    child: CircularProgressIndicator(
                      color: color.p500,
                    ),
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
                            onTap: () {
                              setState(() {
                                faqs[i].isExpanded = !faqs[i].isExpanded;
                              });
                            },
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
