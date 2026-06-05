import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'product_service.dart';
import 'Design System/ProductCard/product_card.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  List<Map<String,dynamic>> Products = [];
  List<Map<String,dynamic>> filteredList = [];
  Future<void> loadProducts() async {
    Products = await ProductService.getProducts();
    filteredList = Products.where(
      (product) =>
          product["isFavorites"] == true,
    ).toList();

    setState(() {});
  } 

  @override
  void initState() {
    super.initState();
    loadProducts();
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
        title: "المفضلة",
        centerTheTitles: true,
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
                          "المفضله فارغة",
                          style: fonts.h5.copyWith(color: color.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "لا يوجد منتجات تم  اضافتها",
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