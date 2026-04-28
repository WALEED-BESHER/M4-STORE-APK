import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waleedo_app/account.dart';
import 'package:waleedo_app/bestselling.dart';
import 'package:waleedo_app/constants/colors.dart';
import 'package:waleedo_app/constants/fonts.dart';
import 'package:waleedo_app/Design System/ProductCard/product_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:waleedo_app/orders.dart';
import 'package:waleedo_app/cart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //داله الاستدعاء عند بدايه الصفحه
  @override
  void initState() {
    super.initState();
    getUserName();
    startTimerOfBestoffers();
  }

  //الحصول على اسم المستخدم براس الصفحه
  String username = "";
  Future<void> getUserName() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    setState(() {
      username = s.getString("first_name") ?? "";
    });
  }

  //قاىمه الصور الذي في السلايدر
  int slidercurrentindex = 0;
  final List<String> slider_images = [
    "assets/images/MainLogo.png",
    "assets/images/45.jpg",
    "assets/images/Glock.jpg",
    "assets/images/dakm4.jpg",
  ];

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
      "bestOffer": false,
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
      "bestOffer": true,
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
      "bestOffer": true,
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
      "bestOffer": true,
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
      "bestOffer": false,
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
      "bestOffer": true,
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
      "bestOffer": true,
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
      "bestOffer": true,
    },
  ];


  // variables and functions of best offers section start here 
  //(متغيرات و دوال قسم افضل العروض يبداء هنا)
  // قاىمه المنتجات المعروضه في افضل العروض
  List<Map<String, dynamic>> get BestOffers => Products.where((product) => product["bestOffer"] == true).toList();
  
  // تصميم صندوق عداد افضل العروض 
  Widget _timeItem(String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color.p500),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: fonts.sb.copyWith(color: color.white),
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: fonts.xss.copyWith(color: color.g500),
        ),
      ],
    );
  }
  // الفاصل حق الوقت في صفحه افضل العروض
  Widget _colon() {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: EdgeInsets.only(right: 1, top: 8),
        child: Text(
          " : ",
          style: fonts.sb.copyWith(color: color.white),
        ),
      ),
    );
  }
  // متغرات العداد + اظهار قسم افضل العروض
  Duration bestOffersRemainingTime = Duration(days: 10,hours: 1,minutes: 5 , seconds: 30);//ادخل قيمه الوقت الذي تريده يشتغل هنا
  Timer? timer;
  bool showBestOffers = true;
  // بداء موقت صفحة افضل العروض
  void startTimerOfBestoffers() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (bestOffersRemainingTime.inSeconds > 0) {
        setState(() {
          bestOffersRemainingTime = bestOffersRemainingTime - Duration(seconds: 1);
        });
      } else {
        t.cancel();

        setState(() {
          showBestOffers = false; 
        });
      }
    });
  }
  // متغبرات الوقت لقسم افضل العروض
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  int get days => bestOffersRemainingTime.inDays;
  int get hours => bestOffersRemainingTime.inHours % 24;
  int get minutes => bestOffersRemainingTime.inMinutes % 60;
  int get seconds => bestOffersRemainingTime.inSeconds % 60;


  //قسم الاكثر مبيعاء 
  // قاىمه المنتجات المعروضه في الاكثر مبيعا
  List<Map<String, dynamic>> get BestSelling {
    List<Map<String, dynamic>> temp = List.from(Products);
    temp.sort((a, b) => b["sold"].compareTo(a["sold"]));
    return temp;
  }
  

  
  // الفئات
  List<String> categories = [
    "الكل",
    "مسدسات",
    "الآلي",
    "قنابل",
    "رصاص",
  ];

  // bottomNavigationBar
  int Footer_currentIndex = 3;

  // الفئة المختارة
  int selectedCategory = 0;

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: AppBar(
        backgroundColor: color.dark2,
        leadingWidth: 96,
        leading: Row(
          //leading
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("search");
              },
              icon: Icon(Icons.search),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color.f_secondary),
                foregroundColor: MaterialStateProperty.all(color.g400),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return color.b_activered; // لون عند الضغط
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return color.b_hoverdred;
                    }
                    return null; // يرجع طبيعي
                  },
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color.f_primary, width: 2)),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("notifications");
              },
              icon: Icon(Icons.notifications),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color.f_secondary),
                foregroundColor: MaterialStateProperty.all(color.g400),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return color.p400.withOpacity(0.4); // لون عند الضغط
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return color.b_hoverdred;
                    }
                    return null; // يرجع طبيعي
                  },
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color.f_primary, width: 2)),
                ),
              ),
            ),
          ],
        ),
        title: Column(
          //title
          children: [
            SizedBox(
                height: 44,
                child: Image.asset(
                  "assets/images/Logo3.png",
                  fit: BoxFit.contain,
                ))
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("رمضان كريم",
                    style: fonts.xlb.copyWith(color: color.g200)),
                Text(
                  username,
                  style: fonts.ms.copyWith(color: color.g200),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            CarouselSlider(
              //===============slider start here======
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 1),
                autoPlayAnimationDuration: Duration(milliseconds: 400),
                height: 170,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    slidercurrentindex = index;
                  });
                },
              ),
              items: slider_images.map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.dark2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 5,
            ),
            AnimatedSmoothIndicator(
              activeIndex: slidercurrentindex,
              count: slider_images.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 5,
                dotColor: color.p50,
                activeDotColor: color.p500,
                paintStyle: PaintingStyle.fill,
              ),
            ),

            SizedBox(height: 8,),

            showBestOffers ? Container(
              // ===========قسم افضل العروض يبدا هنا ===========
              width: double.infinity,
              color: color.black,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ================= HEADER =================
                  // title + counter
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 6),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          right: -5,
                          bottom: -8,
                          child: Image.asset(
                            "assets/images/background_of_bestoffers.png",
                            // width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12, left: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ينتهي العرض خلال",
                                    style:
                                        fonts.xsm.copyWith(color: color.g500),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _timeItem(twoDigits(days), "يوم"),
                                      _colon(),
                                      _timeItem(twoDigits(hours), "ساعة"),
                                      _colon(),
                                      _timeItem(twoDigits(minutes), "دقيقة"),
                                      _colon(),
                                      _timeItem(twoDigits(seconds), "ثانية"),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "أفضــل العــروض🔥",
                                      style: fonts.xlb
                                          .copyWith(color: color.white),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(height: 4),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 16),
                                      child: Text(
                                        "عروض محدودة لفترة قصيرة",
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 9,
                                            color: color.g400,
                                            fontWeight: FontWeight.w600),
                                        textDirection: TextDirection.rtl,
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

                  // products of best offers
                  SizedBox(
                    height: 242,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: BestOffers.length,
                      itemBuilder: (context, index) {
                        final product = BestOffers.toList()[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: ProductCard(
                            id: product["id"],
                            image: product["image"]!,
                            title: product["title"]!,
                            newPrice: product["newPrice"],
                            oldPrice: product["oldPrice"],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ) : SizedBox(),

            Container(
              // ========= الاكثر مبيعا ======
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========= العنوان =========
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
                                  builder: (context) => Bestselling()),
                            );
                          },
                          child: Text(
                            "المزيد",
                            style: fonts.sm.copyWith(
                              color: color.g100,
                              decoration: TextDecoration.underline,
                              decorationColor: color.p500,
                            ),
                          ),
                        ),
                        Text(
                          "الاكثر مبيعاً",
                          style: fonts.h6.copyWith(color: color.g100),
                        ),
                      ],
                    ),
                  ),

                  //========= المنتجات =========
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: BestSelling.take(5).map((product) {
                        return ProductCard(
                          id: product["id"],
                          image: product["image"]!,
                          title: product["title"]!,
                          newPrice: product["newPrice"],
                          oldPrice: product["oldPrice"],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            
            SizedBox(
              //catagorize
              height: 45,
              child: Row(
                textDirection: TextDirection.rtl,
                children: List.generate(categories.length, (index) {
                  bool isActive = selectedCategory == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isActive ? color.p900 : Colors.transparent,
                          borderRadius: BorderRadius.circular(48),
                          border: Border.all(
                            color: isActive ? color.p500 : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          categories[index],
                          style: isActive
                              ? fonts.mb.copyWith(color: color.g50)
                              : fonts.ms.copyWith(color: color.g400),
                          // fonts.ms.copyWith( color: isActive ? Colors.white : color.g400, )
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        //bottom Navigation bar start here
        decoration: BoxDecoration(
          color: color.dark2,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(48),
              bottomRight: Radius.circular(48)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: Footer_currentIndex,
            backgroundColor: color.dark2,
            selectedItemColor: color.p400,
            unselectedItemColor: color.g400,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),
                );
              }
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              }

              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Orders()),
                );
              }

              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "حسابي",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: "السلة",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: "طلباتي",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "الرئيسية",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
