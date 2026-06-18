import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/ProductCard/product_card.dart';

class BestOffersSection extends StatefulWidget {

  final List<Map<String, dynamic>> products;
  final VoidCallback? onCartChanged;

  const BestOffersSection({
    super.key,
    required this.products,
    this.onCartChanged,
  });

  @override
  State<BestOffersSection> createState() => _BestOffersSectionState();
}

class _BestOffersSectionState extends State<BestOffersSection> {

  // الوقت
  Duration bestOffersRemainingTime = const Duration(
    days: 10,
    hours: 1,
    minutes: 5,
    seconds: 30,
  );

  Timer? timer;
  // اظهار قسم افضل العروض
  bool showBestOffers = true; //

  @override
  void initState() {
    super.initState();
    startTimerOfBestoffers();
  }

  // بداء موقت صفحة افضل العروض
  void startTimerOfBestoffers() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (bestOffersRemainingTime.inSeconds > 0) {
        setState(() {
          bestOffersRemainingTime =
              bestOffersRemainingTime - const Duration(seconds: 1);
        });
      } else {
        t.cancel();

        setState(() {
          showBestOffers = false;
        });
      }
    });
  }

  // تنظيف التايمر
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // متغبرات الوقت لقسم افضل العروض
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int get days => bestOffersRemainingTime.inDays;
  int get hours => bestOffersRemainingTime.inHours % 24;
  int get minutes => bestOffersRemainingTime.inMinutes % 60;
  int get seconds => bestOffersRemainingTime.inSeconds % 60;


  // صندوق الوقت
  Widget timeItem(String value, String label) {
    return Column(
      children: [
        Container(
          padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color.p500),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: fonts.sb.copyWith(color: color.white),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: fonts.xss.copyWith(color: color.g500),
        ),
      ],
    );
  }

  // النقطتين :
  Widget colon() {
    return SizedBox(
      height: 48,
      child: Padding(
        padding:const EdgeInsets.only(right: 1, top: 8),
        child: Text(
          " : ",
          style: fonts.sb.copyWith(color: color.white),
        ),
      ),
    );
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

    // المنتجات التي عليها عروض
    final bestOffers = widget.products
        .where((product) =>
            product["bestOffer"] == 1)
        .toList();

    if (!showBestOffers) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      color: color.black,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ================= راس القسم بداء هنا =================
          //         // title + counter
          Container(
            width: double.infinity,
            margin:const EdgeInsets.only(bottom: 6),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: -5,
                  bottom: -8,
                  child: Image.asset(
                    "assets/images/background_of_bestoffers.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding:const EdgeInsets.only(right: 12, left: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ينتهي العرض خلال",
                            style: fonts.xsm.copyWith(
                              color: color.g500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              timeItem(twoDigits(days), "يوم",),
                              colon(),
                              timeItem(twoDigits(hours), "ساعة"),
                              colon(),
                              timeItem(twoDigits(minutes), "دقيقة",),
                              colon(),
                              timeItem(twoDigits(seconds),"ثانية",),
                            ],
                          ),
                        ],
                      ),
                      //=============== عنوان افضل العروض ======
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "أفضــل العــروض🔥",
                              style: fonts.xlb.copyWith(
                                color: color.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Padding(
                              padding:EdgeInsets.only(right: 16,),
                              child: Text(
                                "عروض محدودة لفترة قصيرة",
                                style: TextStyle(
                                  fontFamily:'Cairo',
                                  fontSize: 9,
                                  color: color.g400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //=============== منتجات قسم افضل العروض ======
          SizedBox(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: bestOffers.length,
              itemBuilder: (context,index,) {
                final product = bestOffers[index];
                return Padding(
                  padding:const EdgeInsets.symmetric(
                    horizontal: 1,
                  ),
                  child: ProductCard(
                    id: product["id"],
                    image:product["images"][0],
                    title: product["title"],
                    newPrice: product["newPrice"],
                    oldPrice:product["oldPrice"],
                    type: getProductCardType(
                      product["type"],
                    ),
                    onCartChanged: widget.onCartChanged,
                    isFavorite: product["isFavorites"],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}