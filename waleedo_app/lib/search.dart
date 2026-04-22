import 'package:flutter/material.dart';
import 'dart:ui';

// تأكد من صحة مسارات الاستيراد حسب مشروعك
import 'package:waleedo_app/Design%20System/Inputs/primary_input.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  // محاكاة لبيانات البحث السابقة (إذا كانت فارغة ستختفي القائمة تلقائياً)
  List<String> recentSearches = [
    "ايكي يمني",
    "مؤتمر",
    "جفري",
    "M4",
    "AK47",
    "صربي",
    "مجفر",
    "ام فور"
  ];

  // قائمة الفئات
  List<String> categories = ["مسدسات", "الآلي", "قنابل", "رصاص"];

  // chip design
  Widget _buildChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.p500, width: 2),
          // color: color.b_defultred,
        ),
        child: Text(
          label,
          style: fonts.mm.copyWith(color: color.g200),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          color.dark1, // التأكد من تعريف color.dark1 في ملف الألوان
      appBar: AppBar(
        backgroundColor: color.dark2,
        elevation: 0,

        // الجهة اليسرى: زر الفلترة
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              // منطق الفلترة هنا
            },
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: color.f_secondary,
              foregroundColor: color.g400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: color.f_primary, width: 2),
              ),
            ),
          ),
        ),

        // المنتصف: حقل البحث
        titleSpacing: 0,
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              controller: searchController,
              onChanged: (value) { setState(() {}); },
              cursorColor: color.g400,
              style: fonts.sb.copyWith(color: color.g400),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: color.p600,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                  color: color.g500,),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:color.g500,
                  ),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                labelText: "البحث",
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: fonts.sb.copyWith(
                  color: color.g400,
                ),
                prefixIcon: Icon(Icons.search,size: 24,),
                prefixIconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.focused)) {
                    return color.p600;
                  }
                  return color.g100;
                }),
                suffixIcon: searchController.text.isNotEmpty? IconButton(
                  onPressed: (){
                    searchController.clear();
                  }, 
                  icon: Icon(Icons.close,size: 24,),
                ): null,
                suffixIconColor: searchController.text.isNotEmpty ? WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.focused)) {
                    return color.p600;
                  }
                  return color.g100;
                }) :null,
              ),
            ),
          ),
        ),

        // الجهة اليمنى: زر الرجوع
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward, size: 28),
            color: color.g400,
          ),
        ],
      ),


      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 12),
        child: Stack(
          children: [
            // 1. شعار المتجر في الخلفية مع Opacity 20%
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // 2. المحتوى الفعلي (البحوث والفئات)
            Directionality(
              textDirection: TextDirection.rtl, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // قسم عمليات البحث الأخيرة (يظهر فقط إذا كانت القائمة غير فارغة)
                  if (recentSearches.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(right: 4),
                      child: Text("عمليات البحث الاخيره",
                      style: fonts.xlb.copyWith(color: color.g200)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,// المسافة بينهم من ناحيه العرض 
                      runSpacing: 8,// المسافة بينهم من ناحيه الطول
                      children: recentSearches
                          .take(8)
                          .map((term) => _buildChip(term, () {
                                searchController.text = term;
                                // هنا تنقله لصفحة النتائج
                              }))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // قسم جميع الفئات
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 4),
                    child: Text("جميع الفئات",
                    style: fonts.xlb.copyWith(color: color.g200)),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 6,// المسافة بينهم من ناحيه العرض 
                    runSpacing: 8,// المسافة بينهم من ناحيه الطول
                    children: categories
                        .map((cat) => _buildChip(cat, () {
                              // هنا تنقله لصفحة الفئة
                            }))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 
}

