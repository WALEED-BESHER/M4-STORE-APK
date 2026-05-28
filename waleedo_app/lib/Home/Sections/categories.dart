import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/ProductCard/product_card.dart';
import '../../cart_data.dart';

class Categories extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const Categories({
    super.key,
    required this.products,
  });

  @override
  State<Categories> createState() =>_CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
  // التاكد ان في السله منتجات
  bool get inCart => CartData.cartItems.isNotEmpty;

  // ===== أسماء الفئات =====
  List<String> categoriesName = [
    "الكل",
    "بنادق",
    "مسدسات",
    "قناصات",
    "قنابل",
    "ذخاير",
  ];

  // ===== الفئة المختارة =====
  int selectedCategory = 0;

  // ===== المنتجات المفلترة =====
  List<Map<String, dynamic>> get filteredProduct {

    String selected = categoriesName[selectedCategory];

    if (selected == "الكل") {
      return widget.products;
    }
    return widget.products.where((p) {

      return p["category"] == selected;

    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: inCart
        ?const EdgeInsets.only(top: 6, bottom: 40)
        :const EdgeInsets.symmetric(vertical: 6),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== الفئات =====
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount:categoriesName.length,
              itemBuilder: (context, index) {
                bool isActive = selectedCategory == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                  child: Container(
                    margin:const EdgeInsets.symmetric(horizontal: 4, ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isActive
                          ? color.p900
                          : Colors.transparent,
                      borderRadius:BorderRadius.circular(48),
                      border: Border.all(
                        color: isActive
                          ? color.p500
                          : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categoriesName[index],
                      style: isActive
                        ? fonts.mb.copyWith(
                            color: color.g50,
                          )
                        : fonts.ms.copyWith(
                            color: color.g400,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ===== المنتجات =====
          filteredProduct.isNotEmpty
          ?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Directionality(
              textDirection:TextDirection.rtl,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:filteredProduct.length,
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.70,
                ),
                itemBuilder:(context, index) {
                  final product =filteredProduct[index];
                  return Directionality(
                    textDirection:TextDirection.ltr,
                    child: ProductCard(
                      id: product["id"],
                      image: product["images"][0],
                      title: product["title"],
                      newPrice:   product["newPrice"],
                      oldPrice: product["oldPrice"],
                      type:getProductCardType(
                        product["type"],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
          :SizedBox(
            height: 150,
            child: Center(
              child: Text(
                "لا توجد منتجات في هذه الفئة حالياً، يمكنك تصفح فئات أخرى",
                style: fonts.h6.copyWith(
                  color: color.g100,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}