import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/ProductCard/product_card.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // =========================================================
  // 🟢 1. CONTROLLERS (التحكم بالمدخلات)
  // =========================================================

  // يتحكم في حقل البحث (قراءة النص - تعديل - مسح)
  TextEditingController searchController = TextEditingController();

  // =========================================================
  // 🔵 2. DATA (البيانات الأساسية)
  // =========================================================

  // القائمة الأساسية لجميع المنتجات (مصدر البيانات الرئيسي)
  final List<Map<String, dynamic>> Products = [
    {
      "id": 1,
      "image": "assets/images/Mosher.jpg",
      "title": " مشير جديد زيرو",
      "newPrice": 1866,
      "oldPrice": 2133,
      "usage": false,
      "sold": 10,
      "date": DateTime(2026, 4, 20, 14, 20),
      "rating": 3.7,
    },
    {
      "id": 2,
      "image": "assets/images/Motamarn.jpg",
      "title": "موتمر نيكل جديد بلقرطاس",
      "newPrice": 3200,
      "oldPrice": 3733,
      "type": ProductCardType.hideBoth,
      "usage": false,
      "sold": 7,
      "date": DateTime(2026, 4, 20, 14, 30),
      "rating": 4.5,
    },
    {
      "id": 3,
      "image": "assets/images/M41.jpg",
      "title": "ام فور امريكي درجه اولى",
      "newPrice": 5000,
      "oldPrice": 5700,
      "usage": false,
      "sold": 20,
      "date": DateTime(2025, 7, 8, 7, 00),
      "rating": 4.9,
    },
    {
      "id": 4,
      "image": "assets/images/Glock.jpg",
      "title": "كلوك نمساوي درجه اولى",
      "newPrice": 2800,
      "oldPrice": 3500,
      "type": ProductCardType.hideOldPrice,
      "usage": false,
      "sold": 5,
      "date": DateTime(2025, 10, 2, 7, 15),
      "rating": 4.7,
    },
    {
      "id": 5,
      "image": "assets/images/Mosher.jpg",
      "title": " مشير جديد زي رو",
      "newPrice": 2546,
      "oldPrice": 3200,
      "usage": false,
      "sold": 19,
      "date": DateTime(2026, 2, 8, 14, 20),
      "rating": 3.0,
    },
    {
      "id": 6,
      "image": "assets/images/Motamarn.jpg",
      "title": "موتمر ني كل جديد بلقرطاس",
      "newPrice": 6200,
      "oldPrice": 7000,
      "type": ProductCardType.hideBoth,
      "usage": false,
      "sold": 14,
      "date": DateTime(2026, 4, 10, 14, 30),
      "rating": 4.0,
    },
    {
      "id": 7,
      "image": "assets/images/M41.jpg",
      "title": "ام فور امري كي درجه اولى",
      "newPrice": 8000,
      "oldPrice": 9500,
      "usage": false,
      "sold": 27,
      "date": DateTime(2025, 7, 18, 7, 00),
      "rating": 5.0,
    },
    {
      "id": 8,
      "image": "assets/images/Glock.jpg",
      "title": "كلوك نم ساوي درجه اولى",
      "newPrice": 2400,
      "oldPrice": 6300,
      "type": ProductCardType.hideOldPrice,
      "usage": false,
      "sold": 7,
      "date": DateTime(2025, 9, 2, 7, 15),
      "rating": 4.1,
    },
    {
      "id": 9,
      "image": "assets/images/Mosher.jpg",
      "title": " مشير جديد زي رو",
      "newPrice": 2546,
      "oldPrice": 3200,
      "usage": false,
      "sold": 19,
      "date": DateTime(2026, 2, 8, 14, 20),
      "rating": 3.0,
    },
    {
      "id": 10,
      "image": "assets/images/Motamarn.jpg",
      "title": "موتمر ني كل جديد بلقرطاس",
      "newPrice": 6200,
      "oldPrice": 7000,
      "type": ProductCardType.hideBoth,
      "usage": false,
      "sold": 14,
      "date": DateTime(2026, 4, 10, 14, 30),
      "rating": 4.0,
    },
    {
      "id": 11,
      "image": "assets/images/M41.jpg",
      "title": "ام فور امري كي درجه اولى",
      "newPrice": 8000,
      "oldPrice": 9500,
      "usage": false,
      "sold": 27,
      "date": DateTime(2025, 7, 18, 7, 00),
      "rating": 5.0,
    },
    {
      "id": 12,
      "image": "assets/images/Glock.jpg",
      "title": "كلوك نم ساوي درجه اولى",
      "newPrice": 2400,
      "oldPrice": 6300,
      "type": ProductCardType.hideOldPrice,
      "usage": false,
      "sold": 7,
      "date": DateTime(2025, 9, 2, 7, 15),
      "rating": 4.1,
    },
  ];

  // =========================================================
  // 🟡 3. SEARCH Variables & Fuctions & Lists and Widgets (دوال ومتغيرات البحث )
  // =========================================================

  // هل المستخدم ضغط Enter (يعني بدأ البحث الفعلي)
  bool isSubmitted = false;

  // قائمة الاقتراحات (تظهر أثناء الكتابة فقط)
  List<Map<String, dynamic>> suggestions = [];

  // المنتجات التي سيتم عرضها بعد الضغط Enter
  List<Map<String, dynamic>> selectedProducts = [];

  // النتائج الأصلية للبحث يعني بعد ما نبحث كل النتايج تخزن هنا
  List<Map<String, dynamic>> baseSearchResults = [];

  // قائمة عمليات البحث السابقة (محفوظة محليًا)
  List<String> recentSearches = [];

  // تغير خلفيه ال input عند ال focus
  FocusNode searchFocusNode = FocusNode();

  // تقوم بتنظيف النص (إزالة الفراغات + توحيد الحروف العربية)
  // الهدف: جعل البحث ذكي ويتجاهل الاختلافات الإملائية
  String normalize(String text) {
    return text
        .replaceAll(" ", "")
        .replaceAll("أ", "ا")
        .replaceAll("إ", "ا")
        .replaceAll("آ", "ا")
        .replaceAll("ؤ", "و")
        .replaceAll("ى", "ي")
        .replaceAll("ة", "ه")
        .toLowerCase();
  }

  // دالة البحث الرئيسية
  // - تأخذ النص من المستخدم
  // - ترجع اقتراحات أثناء الكتابة
  // - ترجع نتائج كاملة عند الضغط Enter
  void searchProducts(String query) {
    if (query.isEmpty) {
      // إذا المستخدم مسح النص → نظف كل النتائج
      suggestions.clear();
      selectedProducts.clear();
    } else {
      final normalizedQuery = normalize(query);
      // Set لتجنب تكرار الاقتراحات
      final seen = <String>{};

      List<Map<String, dynamic>> tempSuggestions = [];
      List<Map<String, dynamic>> tempSelected = [];

      for (var product in Products) {
        final titleOriginal = product["title"].toString();
        final titleNormalized = normalize(titleOriginal);
        // إذا المنتج يحتوي على النص
        if (titleNormalized.contains(normalizedQuery)) {
          // نضيفه للنتائج النهائية (حتى لو مكرر)
          tempSelected.add(product);

          // نضيفه للاقتراحات بدون تكرار
          final uniqueKey = titleOriginal.trim();

          if (!seen.contains(uniqueKey)) {
            seen.add(uniqueKey);
            tempSuggestions.add(product);
          }
        }
      }

      // تحديث القوائم
      suggestions = tempSuggestions; // اعرض العناوين في الاقتراحات بدون تكرار
      baseSearchResults = tempSelected; // كل المنتجات المبحوث عليها تظهر هنا
      selectedProducts = List.from(tempSelected);
    }
    setState(() {});
  }

  // تحميل عمليات البحث السابقة من الجهاز (التخزين المحلي لعمليات البحث السابقه)
  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches = prefs.getStringList('recent_searches') ?? [];
    setState(() {});
  }

  // حفظ عملية بحث جديدة في جدول عمليات البحث السابقه
  // - يحفظ فقط 8 عناصر
  // - يحذف الأقدم يعني يحذف من اخر عنصر في الواجهه
  Future<void> saveSearch(String term) async {
    final prefs = await SharedPreferences.getInstance();

    recentSearches.remove(term); // لو موجود نحذفه
    recentSearches.insert(0, term); // نضيفه في البداية

    if (recentSearches.length > 8) {
      recentSearches.removeLast(); // نحذف القديم
    }

    await prefs.setStringList('recent_searches', recentSearches);
    setState(() {});
  }

  // تصميم Chip (زر صغير للفئات أو البحث السابق)
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

  // =========================================================
  // 🟣 4. FILTER Variables & Fuctions & Lists and Widgets ( متغيرات و دوال و قوايم الفلتره)
  // =========================================================

  // هل نستطيع استخدام الفلتره والحالات الذي نستطيع استخدام الفلتره هي بعد ما المستخد يبحث يستتطيع استخدام الفلتره وثاني شي عشاننظهر رساله الخطاء
  bool isFilteredApply = false;

  // القيمة المختارة من الفلتر (مثل: الأغلى - الأحدث)
  String selectedFilter = "";

  // تطبيق الفلتر على النتائج
  // يعتمد على selectedFilter
  void applyFilter() {
    // نبدأ بالنتائج الأصلية المستوحاه من البحث
    List<Map<String, dynamic>> temp = List.from(baseSearchResults);

    if (selectedFilter == "الأغلى") {
      temp.sort((a, b) => b["newPrice"].compareTo(a["newPrice"]));
    } else if (selectedFilter == "الأرخص") {
      temp.sort((a, b) => a["newPrice"].compareTo(b["newPrice"]));
    } else if (selectedFilter == "مستخدم") {
      temp = temp.where((item) => item["usage"] == true).toList();
    } else if (selectedFilter == "جديد") {
      temp = temp.where((item) => item["usage"] == false).toList();
    } else if (selectedFilter == "الأكثر شيوعاً") {
      temp.sort((a, b) => b["sold"].compareTo(a["sold"]));
    } else if (selectedFilter == "الأحدث") {
      temp.sort((a, b) => b["date"].compareTo(a["date"]));
    } else if (selectedFilter == "الأقدم") {
      temp.sort((a, b) => a["date"].compareTo(b["date"]));
    } else if (selectedFilter == "موصى به") {
      temp.sort((a, b) => b["rating"].compareTo(a["rating"]));
    }

    setState(() {
      selectedProducts = temp;
      isFilteredApply = true;
    });
  }

  // فتح نافذة الفلترة (BottomSheet)
  // تحتوي على خيارات مثل فلتره السعر - الاستخدام - الترتيب
  void openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: color.dark2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            // StatefulBuilder يسمح بتحديث الفلتر فقط بدون إعادة بناء الصفحة كاملة
            return Container(
              padding: const EdgeInsets.all(16),
              height:
                  MediaQuery.of(context).size.height * 0.80, // طول شاشه الفلتره
              width:
                  MediaQuery.of(context).size.width * 0.95, // عرض شاشه الفلتره
              child: Column(
                children: [
                  // 🔹 الهيدر
                  p_appbar(
                    title: "فلترة",
                    centerTheTitles: true,
                    iconcolor: color.white,
                  ),

                  Expanded(
                    child: ListView(
                      children: [
                        // قسم الترتيب
                        buildSection(
                          title: "فرز حسب",
                          children: [
                            radioItem("موصى به", setStateSheet),
                            radioItem("الأكثر شيوعاً", setStateSheet),
                            radioItem("الأحدث", setStateSheet),
                            radioItem("الأقدم", setStateSheet),
                          ],
                        ),

                        // قسم السعر
                        buildSection(
                          title: "فلترة حسب السعر",
                          children: [
                            radioItem("الأغلى", setStateSheet),
                            radioItem("الأرخص", setStateSheet),
                          ],
                        ),

                        // قسم الاستخدام
                        buildSection(
                          title: "فلترة حسب الاستخدام",
                          children: [
                            radioItem("جديد", setStateSheet),
                            radioItem("مستخدم", setStateSheet),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // أزرار التحكم
                  Row(
                    children: [
                      //زر إعادة تعيين الفلتر
                      Expanded(
                        child: p_button(
                          title: "إعادة تعيين",
                          onPressed: () {
                            setState(() {
                              selectedFilter = "";
                              // يرجع النتائج الأصلية قبل الفلتر
                              selectedProducts = List.from(baseSearchResults);

                              isFilteredApply = false;
                            });
                            Navigator.pop(context);
                          },
                          colort: color.g200,
                          background: color.dark3,
                          fontType: fonts.mb,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // زر تفعيل الفلتره
                      Expanded(
                        child: p_button(
                          title: "تطبيق",
                          onPressed: () {
                            applyFilter();
                            Navigator.pop(context);
                          },
                          fontType: fonts.mb,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // يحدد الخيار المختار
  Widget radioItem(String value, Function setStateSheet) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RadioListTile(
        title: Text(value,
            style: fonts.ms.copyWith(color: color.g300)), // حجم و خط الراديو
        value: value,
        groupValue: selectedFilter,
        activeColor: color.p500,
        onChanged: (val) {
          // تحديث الاختيار داخل الـ BottomSheet فقط
          setStateSheet(() {
            selectedFilter = val.toString();
          });
        },
      ),
    );
  }

  // تصميم قسم الفلتر (عنوان + خيارات)
  Widget buildSection({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.dark1,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(title, style: fonts.xlb.copyWith(color: color.white)),
          ),
          const Divider(
            color: color.dark3,
          ),
          ...children
        ],
      ),
    );
  }

  // =========================================================
  // ⚪ 5. categories list
  // =========================================================

  // قائمة الفئات
  List<String> categories = ["مسدسات", "الآلي", "قنابل", "رصاص"];

  // =========================================================
  // ⚙️ 6. LIFECYCLE
  // =========================================================

  // يتم استدعاؤها عند فتح الصفحة
  // نستخدمها لتحميل البيانات المبدئية
  @override
  void initState() {
    super.initState();
    loadRecentSearches();
  }

  // تنظيف الموارد عند إغلاق الصفحة
  // مهم لمنع تسريب الذاكرة
  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
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
              if (suggestions.isNotEmpty || isSubmitted) {
                openFilter();
              }
            }, // openFilter
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
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: searchFocusNode.hasFocus
                      ? color.b_defultred
                      : Colors.transparent),
              child: TextFormField(
                focusNode: searchFocusNode,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                controller: searchController,
                onTap: () {
                  setState(() {});
                },
                onChanged: (value) {
                  isSubmitted = false;
                  isFilteredApply = false;
                  searchProducts(value);
                },
                onFieldSubmitted: (value) {
                  isSubmitted = true;
                  selectedFilter = "";
                  isFilteredApply = false;
                  searchProducts(value);
                  saveSearch(value);
                  setState(() {});
                },
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
                      color: color.g500,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: color.g500,
                    ),
                  ),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  labelText: "البحث",
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: fonts.sb.copyWith(
                    color: color.g400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24,
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return color.p600;
                    }
                    return color.g100;
                  }),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            suggestions.clear();
                            selectedProducts.clear();
                            isSubmitted = false;
                            isFilteredApply = false;
                            selectedFilter = "";
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.close,
                            size: 24,
                          ),
                        )
                      : null,
                  suffixIconColor: searchController.text.isNotEmpty
                      ? WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.focused)) {
                            return color.p600;
                          }
                          return color.g100;
                        })
                      : null,
                ),
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
        // padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Stack(
          children: [
            // 1. شعار المتجر في الخلفية مع Opacity 20%
            (isSubmitted)
                ? Container()
                : Center(
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
                  // 🔴 1. لو فيه نتائج مختارة (عرض المنتج)
                  if (isSubmitted)
                    Expanded(
                      child: selectedProducts.isEmpty
                          ? Center(
                              // اذا بحث ولا يوجد قيمه مرجعه يظهر له هذا
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset("assets/images/Nodata.png"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      isFilteredApply
                                          ? "لا توجد نتائج مطابقة"
                                          : "لم يتم العثور على نتائج",
                                      style:
                                          fonts.h5.copyWith(color: color.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      isFilteredApply
                                          ? "حاول تعديل خيارات الفلترة للحصول على نتائج أفضل"
                                          : "لا يوجد أي منتج يطابق بحثك حاليًا. حاول تعديل كلمات البحث أو استكشاف الأقسام",
                                      style:
                                          fonts.lm.copyWith(color: color.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4, bottom: 2),
                                    child: RichText(
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'نتائج البحث عن ',
                                            style: fonts.sb
                                                .copyWith(color: color.g200),
                                          ),
                                          TextSpan(
                                            text: '" ${searchController.text} "',
                                            style: fonts.sb.copyWith(
                                              color: color.g200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),

                                  Expanded(
                                    child: GridView.builder(
                                      itemCount: selectedProducts.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 0.71,
                                      ),
                                      itemBuilder: (context, index) {
                                        final product = selectedProducts[index];
                                        return Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: ProductCard(
                                            id: product["id"],
                                            image: product["image"],
                                            title: product["title"],
                                            newPrice: product["newPrice"],
                                            oldPrice: product["oldPrice"],
                                            type: product["type"] ??
                                                ProductCardType.full,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    )

                  // 🟡 2. لو يكتب → اقتراحات
                  else if (searchController.text.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final item = suggestions[index];
                          return Column(
                            children: [
                              Container(
                                color: color.dark2,
                                padding: EdgeInsets.only(right: 12),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  trailing: Icon(
                                    Icons.north_west,
                                    color: color.g300,
                                    size: 20,
                                  ),
                                  title: Text(
                                    item["title"],
                                    style:
                                        fonts.sb.copyWith(color: color.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    searchController.text = item["title"];
                                    searchProducts(item["title"]);
                                    isSubmitted = true;
                                    saveSearch(item["title"]);
                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: color.dark1,
                              ),
                            ],
                          );
                        },
                      ),
                    )

                  // 🟢 3. لو فاضي → البحث السابق + الفئات
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (recentSearches.isNotEmpty) ...[
                                Text("عمليات البحث الاخيره",
                                    style:
                                        fonts.xlb.copyWith(color: color.g200)),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 8,
                                  children: recentSearches
                                      .map((term) => _buildChip(term, () {
                                            searchController.text = term;
                                            searchProducts(term);
                                            isSubmitted = true;
                                            saveSearch(term);
                                          }))
                                      .toList(),
                                ),
                                SizedBox(height: 30),
                              ],
                              Text("جميع الفئات",
                                  style: fonts.xlb.copyWith(color: color.g200)),
                              SizedBox(height: 15),
                              Wrap(
                                spacing: 6,
                                runSpacing: 8,
                                children: categories
                                    .map((cat) => _buildChip(cat, () {}))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
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
