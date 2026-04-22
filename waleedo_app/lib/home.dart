import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

  // قاىمه المنتجات المعروضه في الاكثر مبيعا
  final List<Map<String, dynamic>> BestSelling = [
    {
      "id": 1,
      "image": "assets/images/Mosher.jpg",
      "title": " مشير جديد زيرو",
      "newPrice": 1866,
      "oldPrice": 2133,
    },
    {
      "id": 2,
      "image": "assets/images/Motamarn.jpg",
      "title": "موتمر نيكل جديد بلقرطاس",
      "newPrice": 3200,
      "oldPrice": 3733,
    },
    {
      "id": 3,
      "image": "assets/images/M41.jpg",
      "title": "ام فور امريكي درجه اولى مع التوابع",
      "newPrice": 5000,
      "oldPrice": 5700,
    },
    {
      "id": 4,
      "image": "assets/images/Glock.jpg",
      "title": "كلوك نمساوي درجه اولى",
      "newPrice": 3500,
      "oldPrice": 2800,
    },
  ];

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
            Container(// ========= الاكثر مبيعا ======
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
                      children: BestSelling.take(3).map((product) {
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
                          style: isActive ? fonts.mb.copyWith(color: color.g50) : fonts.ms.copyWith(color: color.g400) ,
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
