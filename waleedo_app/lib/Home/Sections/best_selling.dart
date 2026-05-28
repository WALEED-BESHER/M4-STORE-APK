import 'package:flutter/material.dart';
import '../../bestselling.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/ProductCard/product_card.dart';

class BestSellingSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool showBestSelling;
  const BestSellingSection({
    super.key,
    required this.products,
    required this.showBestSelling,
  });

  @override
  Widget build(BuildContext context) {

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
    
    // ترتيب المنتجات حسب الأكثر مبيعًا
    List<Map<String, dynamic>> bestSelling = List.from(products);
    bestSelling.sort(
      (a, b) =>
          b["sold"].compareTo(a["sold"]),
    );

    if (!showBestSelling) {
      return const SizedBox();
    }

    return Container(
      padding:const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== العنوان =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bestselling(
                          products: bestSelling.skip(5).toList(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "المزيد",
                    style: fonts.sm.copyWith(
                      color: color.g100,
                      decoration:TextDecoration.underline,
                      decorationColor: color.p500,
                    ),
                  ),
                ),
                Text(
                  "الاكثر مبيعاً",
                  style:  fonts.h6.copyWith(
                    color: color.g100,
                  ),
                ),
              ],
            ),
          ),

          // ===== المنتجات =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              textDirection:TextDirection.rtl,
              children:bestSelling.take(5).map((product) {
                return ProductCard(
                  id: product["id"],
                  image: product["images"][0],
                  title:  product["title"],
                  newPrice:  product["newPrice"],
                  oldPrice:  product["oldPrice"],
                  type: getProductCardType(
                      product["type"],
                    ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}