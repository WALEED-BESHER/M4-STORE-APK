import 'package:flutter/material.dart';
import 'package:waleedo_app/constants/fonts.dart';
import 'constants/colors.dart';
import 'Design System/ProductCard/product_card.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';

class Bestselling extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const Bestselling({super.key , required this.products});

  @override
  State<Bestselling> createState() => _BestsellingState();
}

class _BestsellingState extends State<Bestselling> {
  
  
  late List<Map<String, dynamic>> BestSelling;

  // القائمة الجديدة الذي يحصل بها الفلتره ويتم عرضها للمستخدم
  List<Map<String, dynamic>> filteredList = [];

  // قيمه متغير الفلتره
  String selectedFilter = "";

  @override
  void initState() {
    super.initState();
    BestSelling = widget.products;
    filteredList = List.from(BestSelling);
  }

  // داله فتح شاشة الفلترة
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

                  // const SizedBox(height: 6),

                  Expanded(
                    child: ListView(
                      children: [
                        // 🔹 فرز حسب
                        buildSection(
                          title: "فرز حسب",
                          children: [
                            radioItem("موصى به", setStateSheet),
                            radioItem("الأكثر شيوعاً", setStateSheet),
                            radioItem("الأحدث", setStateSheet),
                            radioItem("الأقدم", setStateSheet),
                          ],
                        ),

                        // 🔹 السعر
                        buildSection(
                          title: "فلترة حسب السعر",
                          children: [
                            radioItem("الأغلى", setStateSheet),
                            radioItem("الأرخص", setStateSheet),
                          ],
                        ),

                        // 🔹 الاستخدام
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

                  // 🔻 الأزرار
                  Row(
                    children: [
                      Expanded(
                        child: p_button(
                          title: "إعادة تعيين",
                          onPressed: () {
                            setState(() {
                              selectedFilter = "";
                              filteredList = List.from(BestSelling);
                            });
                            Navigator.pop(context);
                          },
                          colort: color.g200,
                          background: color.dark3,
                          fontType: fonts.mb,
                        ),
                      ),
                      const SizedBox(width: 10),
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

  // عنصر radio
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
          setState(() {
            selectedFilter = val.toString();
          });
          setStateSheet(() {});
        },
      ),
    );
  }

  //  تصميم صندوق كل قسم
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

  //  داله تطبيق الفلترة
  void applyFilter() {
    List<Map<String, dynamic>> temp = List.from(BestSelling);

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
      filteredList = temp;
    });
  }
  ProductCardType getProductCardType(String? type){
    switch(type){
      case "hideDiscount":
        return ProductCardType.hideDiscount;
      case "hideBoth":
        return ProductCardType.hideBoth;
      case "hideOldPrice":
        return ProductCardType.hideOldPrice;
      default:
        return ProductCardType.full;
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الاكثر مبيعاً",
        showLeading: true,
        btn1_Onprss: openFilter, // ⭐ هنا فتح الفلتر
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: filteredList.isEmpty
              ? Center(
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
                          "لا توجد نتائج مطابقة",
                          style: fonts.h5.copyWith(color: color.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "حاول تعديل خيارات الفلترة للحصول على نتائج أفضل",
                          style: fonts.lm.copyWith(color: color.white),textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  itemCount: filteredList.length, // ⭐ استخدمنا الجديدة
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredList[index];

                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: ProductCard(
                        id: product["id"],
                        image:product["images"][0],
                        title: product["title"],
                        newPrice: product["newPrice"],
                        oldPrice:product["oldPrice"],
                        type: getProductCardType(
                          product["type"],
                        ),
                        isFavorite: product["isFavorites"],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
