import 'package:flutter/material.dart';
import '../../bestselling.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/ProductCard/product_card.dart';

class NewProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool showNewProducts;
  const NewProducts({
    super.key,
    required this.products,
    required this.showNewProducts,
  });

  @override
  Widget build(BuildContext context) {
    
    // ترتيب المنتجات حسب الأكثر مبيعًا
    List<Map<String, dynamic>> News = List.from(products);
    News.sort(
      (a, b) => b["date"].compareTo(a["date"])
    );

    if (!showNewProducts) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:const EdgeInsets.only(right: 8, bottom: 8),
            child: Text(
              "المنتجات الجديده",
              style: fonts.h6.copyWith(color: color.g100),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: News.length,
              itemBuilder: (context, index) {
                final product = News.toList()[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1),
                  child: ProductCard(
                    id: product["id"],
                    image: product["images"][0],
                    title: product["title"]!,
                    newPrice: product["newPrice"],
                    oldPrice: product["oldPrice"],
                    type:
                        product["type"] ?? ProductCardType.full,
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}