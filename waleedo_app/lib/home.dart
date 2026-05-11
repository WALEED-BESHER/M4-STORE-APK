import 'dart:async';
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
import 'cart_data.dart';

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
  final List<String> sliderImages = [
    "assets/images/MainLogo.png",
    "assets/images/45.jpg",
    "assets/images/Glock.jpg",
    "assets/images/dakm4.jpg",
  ];

  // القائمة الأساسية لجميع المنتجات (مصدر البيانات الرئيسي)
  final List<Map<String, dynamic>> Products = [
    {
      "id": 1,
      "images": [
        "assets/images/Ak1.jpg",
        "assets/images/Ak2.jpg",
        "assets/images/Ak3.jpg",
        "assets/images/Ak4.jpg",
      ],
      "title": "ايكي روسي طويل وكاله AK-103  زيرو ما قد استخدم",
      "newPrice": 3200,
      "oldPrice": 3800,
      "Description":
          "يُعد AK-103 من أحدث إصدارات عائلة الكلاشينكوف، حيث يجمع بين التصميم الكلاسيكي والمواد الحديثة. يتميز بقوة اعتماديته العالية في مختلف الظروف، سواء في البيئات الصحراوية أو الرطبة، بالإضافة إلى دقته المحسّنة مقارنة بالإصدارات القديمة. كما أن استخدامه الواسع في العديد من الجيوش حول العالم جعله من أكثر الأسلحة انتشارًا وتأثيرًا.",
      "caliber": "7.62×39", // عيار
      "capacity": "30", //السعه
      "category": "بنادق", // الفىه
      "ProductType": "ايكي", // نوع السلاح
      "length": "طويل",
      "model": "AK-103", // مودل السلاح
      "weight": "3.4", // وزن السلاح
      "manufacturing_countrey": "روسيا", // بلاد الصنيع
      "manufacturing_company": "Kalashnikov Concern", // الشركه المصنعه
      "usage": false,
      "sold": 22,
      "date": DateTime(2026, 4, 20, 14, 20),
      "rating": 4.5,
      "bestOffer": true, // ينعرض في افضل العروض
    },
    {
      "id": 2,
      "images": [
        "assets/images/Ak_s_1.jpg",
        "assets/images/Ak_s_2.jpg",
        "assets/images/Ak_s_3.jpg",
        "assets/images/Ak_s_4.jpg",
      ],
      "title": " ايكي AK-104 روسي قصير أسود مقرطس ",
      "newPrice": 3250,
      "oldPrice": 3733,
      "Description":
          "يُعد AK-104 من الإصدارات القصيرة لعائلة الكلاشينكوف، حيث يجمع بين القوة العالية والحجم المدمج، مما يجعله مناسبًا للعمليات السريعة والتنقل. يتميز باعتماديته الكبيرة في مختلف الظروف، وسهولة الاستخدام والصيانة مثل باقي عائلة AK، كما أنه خيار مفضل في البيئات الحضرية بسبب حجمه القصير مقارنة بالإصدارات التقليدية.",
      "caliber": "7.62×39", // عيار
      "capacity": "30", //السعه
      "category": "بنادق", // الفىه
      "ProductType": "ايكي", // نوع السلاح
      "ProductType2": "جفري",
      "length": "قصير",
      "model": "AK-104", // مودل السلاح
      "weight": "3.2", // وزن السلاح
      "manufacturing_countrey": "روسيا", // بلاد الصنيع
      "manufacturing_company": "Kalashnikov Concern", // الشركه المصنعه
      "usage": true,
      "sold": 27,
      "date": DateTime(2026, 2, 25, 13, 00),
      "rating": 4.6,
      "bestOffer": true,
    },
    {
      "id": 3,
      "images": [
        "assets/images/Sharma1.jpg",
        "assets/images/Sharma2.jpg",
        "assets/images/Sharma3.jpg",
      ],
      "title": "شرمه جديد مع التوابع استخدام اسبوع فقط",
      "newPrice": 3466,
      "oldPrice": 3950,
      "Description":
          "يُعد هذا السلاح من عائلة الكلاشينكوف المعروفة بمتانتها واعتماديتها العالية في أصعب الظروف. يتميز بسهولة الاستخدام والصيانة، إضافة إلى قوته في الأداء واستمراريته في العمل حتى في البيئات القاسية. كما أن انتشاره الواسع واستخدامه في العديد من الدول جعله من أكثر الأسلحة شهرة وتأثيرًا في العالم.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق", // الفىه
      "ProductType": "شرمه",
      "ProductType2": "ايكي",
      "length": "طويل",
      "model": "AK Variant",
      "weight": "3.3",
      "manufacturing_countrey": "روسيا",
      "manufacturing_company": "Kalashnikov Concern",
      "usage": true,
      "sold": 11,
      "date": DateTime(2025, 1, 25, 10, 30),
      "rating": 3.9,
      "bestOffer": false,
    },
    {
      "id": 4,
      "images": [
        "assets/images/Mosher.jpg",
        "assets/images/Mosher_1.jpg",
        "assets/images/Mosher_2.jpg",
        "assets/images/Mosher_3.jpg",
      ],
      "title": " مشير مستخدم نظيف كرت",
      "newPrice": 1860,
      // "oldPrice": 2250,
      "Description":
          "يُعد هذا السلاح من عائلة الكلاشينكوف المعروفة بقوتها واعتماديتها العالية في مختلف الظروف. يتميز ببساطة التصميم وسهولة الاستخدام والصيانة، بالإضافة إلى قدرته على العمل بكفاءة حتى في البيئات القاسية. كما أن انتشاره الواسع جعله من أكثر الأسلحة تأثيرًا في العالم.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق", // الفىه
      "ProductType": "مشير",
      "length": "قصير",
      "model": "AK Variant",
      "weight": "3.0",
      "manufacturing_countrey": "روسيا",
      "manufacturing_company": "Kalashnikov Concern",
      "usage": true,
      "sold": 19,
      "date": DateTime(2026, 2, 8, 14, 20),
      "rating": 3.7,
      "bestOffer": true,
    },
    {
      "id": 5,
      "images": [
        "assets/images/Motamarn.jpg",
      ],
      "title": "موتمر ني كل جديد بلقرطاس",
      "newPrice": 4300,
      // "oldPrice": 6100,
      "Description":
          "يُعد هذا السلاح من النسخ القصيرة لعائلة الكلاشينكوف، ويتميز بحجمه الصغير وسهولة حمله، مما يجعله مثاليًا للعمليات السريعة والأماكن الضيقة. يتمتع بنفس اعتمادية الكلاشينكوف المعروفة، مع قدرة عالية على التحمل في الظروف القاسية. كما أن انتشاره بين القوات الخاصة وبعض الوحدات العسكرية زاد من شهرته بشكل كبير.",
      "caliber": "5.45×39",
      "capacity": "30",
      "category": "بنادق",
      "ProductType": "موتمر",
      "length": "قصير",
      "model": "AKS-74U",
      "weight": "2.7",
      "manufacturing_countrey": "بلغاريا",
      "manufacturing_company": "Arsenal AD",
      "usage": false,
      "sold": 14,
      "date": DateTime(2026, 4, 10, 14, 30),
      "rating": 4.0,
      "bestOffer": true,
    },
    {
      "id": 6,
      "images": [
        "assets/images/Mp5_1.jpg",
        "assets/images/Mp5_2.jpg",
        "assets/images/Mp5_3.jpg",
        "assets/images/Mp5_4.jpg",
      ],
      "title": "امبي فايف MP5 ألماني  وكاله مقرطس",
      "newPrice": 1350,
      "oldPrice": 1800,
      "Description":
          "يُعد MP5 من أشهر الرشاشات الخفيفة في العالم بسبب اعتماديته العالية واستخدامه الواسع لدى القوات الخاصة ووحدات الشرطة. يتميز بدقة ممتازة مقارنة بفئته، وسهولة التحكم أثناء الإطلاق، خاصة في المسافات القريبة. كما أن تصميمه المدمج جعله الخيار الأول للعمليات داخل المدن والمباني، وكان له تأثير كبير على تطوير الأسلحة الحديثة المشابهة.",
      "caliber": "9×19", // عيار
      "capacity": " 30 ", // السعه
      "category": "مسدسات", // الفىه
      "ProductType": "امبي فايف",
      "length": "قصير",
      "model": "MP5",
      "weight": "2.5",
      "manufacturing_countrey": "ألمانيا",
      "manufacturing_company": "Heckler & Koch",
      "usage": false,
      "sold": 18,
      "date": DateTime(2025, 7, 18, 7, 20),
      "rating": 3.4,
      "bestOffer": true,
    },
    {
      "id": 7,
      "images": [
        "assets/images/Makraf1.jpg",
        "assets/images/Makraf2.jpg",
        "assets/images/Makraf3.jpg",
        "assets/images/Makraf4.jpg",
      ],
      "title": "مسدس مكروف حكومي روسي  وكاله",
      "newPrice": 2400,
      "oldPrice": 3200,
      "Description":
          "يُعد مسدس مكروف من أشهر المسدسات العسكرية بسبب اعتماديته العالية وبساطة تصميمه، حيث تم اعتماده كسلاح رسمي في الاتحاد السوفيتي لسنوات طويلة. يتميز بسهولة الاستخدام والصيانة، بالإضافة إلى تحمله للظروف القاسية، مما جعله خيارًا مفضلًا لدى العسكريين والأمن. كما أن تصميمه البسيط كان له تأثير واضح على العديد من المسدسات التي جاءت بعده.",
      "caliber": "9×18",
      "capacity": "8",
      "category": "مسدسات",
      "ProductType": "مكروف",
      "length": "قصير",
      "model": "Makarov PM",
      "weight": "0.73",
      "manufacturing_countrey": "روسيا",
      "manufacturing_company": "Izhevsk Mechanical Plant",
      "usage": false,
      "sold": 9,
      "date": DateTime(2025, 9, 2, 7, 15),
      "rating": 4.1,
      "bestOffer": true,
    },
    {
      "id": 8,
      "images": [
        "assets/images/Gefri_1.jpg",
        "assets/images/Gefri_2.jpg",
        "assets/images/Gefri_3.jpg",
        "assets/images/Gefri_4.jpg",
        "assets/images/Gefri_5.jpg",
      ],
      "title": " جفري فتاحي مسمارين موديل 92 مع التوابع",
      "newPrice": 9800,
      "oldPrice": 11470,
      "Description":
          "يُعد هذا النوع من عائلة الكلاشينكوف من أكثر الأسلحة انتشارًا بسبب قوته واعتماديته العالية في مختلف الظروف. يتميز بحجمه القصير وسهولة حمله، مما يجعله مناسبًا للعمليات السريعة والتنقل. كما أن تصميمه البسيط يجعله سهل الصيانة والاستخدام، وله تأثير كبير في عالم الأسلحة الخفيفة.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق",
      "ProductType": "جفري",
      "length": "قصير",
      "model": "AKS-74U",
      "weight": "2.9",
      "manufacturing_countrey": "روسيا",
      "manufacturing_company": "Kalashnikov Concern",
      "usage": false,
      "sold": 39,
      "date": DateTime(2025, 9, 2, 7, 15),
      "rating": 4.9,
      "bestOffer": true,
    },
    {
      "id": 9,
      "images": [
        "assets/images/Bergonof_1.jpg",
        "assets/images/Bergonof_2.jpg",
      ],
      "title": "قناصة دراغونوف روسية وكاله نظيفة مع كامل الملحقات",
      "newPrice": 10200,
      "oldPrice": 10900,
      "Description":
          "تُعد قناصة دراغونوف من أشهر البنادق القنص العسكرية بسبب دقتها العالية واعتماديتها في مختلف الظروف القتالية. تم تطويرها لتكون سلاح دعم للقوات البرية، حيث تجمع بين القوة والمدى الجيد وسرعة الإطلاق مقارنة بالقناصات التقليدية. كما أنها استخدمت في العديد من الجيوش حول العالم، مما جعلها واحدة من أكثر القناصات شهرة وتأثيرًا.",
      "caliber": "7.62×54R",
      "capacity": "10",
      "category": "قناصات",
      "ProductType": "دراغونوف",
      "length": "طويل",
      "model": "SVD Dragunov",
      "weight": "4.3",
      "manufacturing_countrey": "روسيا",
      "manufacturing_company": "Kalashnikov Concern",
      "usage": true,
      "sold": 57,
      "date": DateTime(2026, 2, 22, 10, 00),
      "rating": 4.6,
      "bestOffer": false,
    },
  ];

  // variables and functions of best offers section start here
  //(متغيرات و دوال قسم افضل العروض يبداء هنا)
  // قاىمه المنتجات المعروضه في افضل العروض
  List<Map<String, dynamic>> get BestOffers =>
      Products.where((product) => product["bestOffer"] == true).toList();

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
  Duration bestOffersRemainingTime = Duration(
      days: 10,
      hours: 1,
      minutes: 5,
      seconds: 30); //ادخل قيمه الوقت الذي تريده يشتغل هنا
  Timer? timer;
  bool showBestOffers = true;
  // بداء موقت صفحة افضل العروض
  void startTimerOfBestoffers() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (bestOffersRemainingTime.inSeconds > 0) {
        setState(() {
          bestOffersRemainingTime =
              bestOffersRemainingTime - Duration(seconds: 1);
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
  bool showBestSelling = true;
  List<Map<String, dynamic>> get BestSelling {
    List<Map<String, dynamic>> temp = List.from(Products);
    temp.sort((a, b) => b["sold"].compareTo(a["sold"]));
    return temp;
  }

  // قسم البانر حق الاعلانات
  bool showBanner = true;

  // قسم المنجات الجديده
  bool showNewProducts = true;
  List<Map<String, dynamic>> get News {
    List<Map<String, dynamic>> temp = List.from(Products);
    temp.sort((a, b) => b["date"].compareTo(a["date"]));
    return temp;
  }

  // الفئات
  List<String> categoriesName = [
    "الكل",
    "مسدسات",
    "بنادق",
    "قناصات",
    "قنابل",
    "ذخاير",
  ];
  // الفئة المختارة
  int selectedCategory = 0;
  //
  List<Map<String, dynamic>> get filteredProduct {
    String selected = categoriesName[selectedCategory];

    if (selected == "الكل") {
      return Products;
    }
    if (selected == "بنادق") {
      return Products.where((p) => p["category"] == "بنادق").toList();
    }
    if (selected == "مسدسات") {
      return Products.where((p) => p["category"] == "مسدسات").toList();
    }
    if (selected == "قناصات") {
      return Products.where((p) => p["category"] == "قناصات").toList();
    }

    return [];
  }

  // المنتجات المختاره الذي في السله + الاجمالي + الانتقال الى السله
  bool get inCart => CartData.cartItems.isNotEmpty;
  double get totalPrice {
    double total = 0;

    for (var item in CartData.cartItems) {
      total += item["newPrice"] * item["quantity"];
    }

    return total;
  }

  int get cartSize {
    int cartCount = 0;

    for (var item in CartData.cartItems) {
      cartCount += item["quantity"] as int;
    }

    return cartCount;
  }

  // bottomNavigationBar
  int footerCurrentIndex = 3;

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

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                CarouselSlider(
                  //===============السلايدر يبدا هنا======
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 1),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 400),
                    height: 170,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        slidercurrentindex = index;
                      });
                    },
                  ),
                  items: sliderImages.map((item) {
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
                const SizedBox(
                  height: 5,
                ),
                AnimatedSmoothIndicator(
                  //=============== نقاط السلايدر يبداء هنا ======
                  activeIndex: slidercurrentindex,
                  count: sliderImages.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 5,
                    dotColor: color.p50,
                    activeDotColor: color.p500,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                if (showBestOffers)
                  Container(
                    // ===========قسم افضل العروض يبدا هنا ===========
                    width: double.infinity,
                    color: color.black,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ================= راس القسم بداء هنا =================
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "ينتهي العرض خلال",
                                          style: fonts.xsm
                                              .copyWith(color: color.g500),
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
                                            _timeItem(
                                                twoDigits(minutes), "دقيقة"),
                                            _colon(),
                                            _timeItem(
                                                twoDigits(seconds), "ثانية"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      //=============== عنوان افضل العروض ======
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                        //=============== منتجات قسم افضل العروض ======
                        SizedBox(
                          height: 245,
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
                                    image: product["images"][0],
                                    title: product["title"]!,
                                    newPrice: product["newPrice"],
                                    oldPrice: product["oldPrice"],
                                    type:
                                        product["type"] ?? ProductCardType.full,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),

                // ========= الاكثر مبيعا ======
                if (showBestSelling)
                  Container(
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
                                        builder: (context) => Bestselling(
                                              products:
                                                  BestSelling.skip(5).toList(),
                                            )),
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
                                image: product["images"][0],
                                title: product["title"]!,
                                newPrice: product["newPrice"],
                                oldPrice: product["oldPrice"],
                                type: product["type"] ?? ProductCardType.full,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                //=============== البانر حق الاعلانات يبداء هنا ======
                if (showBanner)
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                          color: color.dark2,
                          borderRadius: BorderRadius.circular(48)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/MainLogo.png",
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "M4_STORE اسم يستحق الثقه",
                                  style: fonts.lb.copyWith(color: color.g100),
                                  textAlign: TextAlign.start,
                                  textDirection: TextDirection.rtl,
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                //=============== قسم المنتجات الجديده ======
                if (showNewProducts)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8, bottom: 8),
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
                              }),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),

                //=============== الفئات تبداء هنا ======
                Container(
                  width: double.infinity,
                  margin: inCart
                      ? EdgeInsets.only(top: 6, bottom: 40)
                      : EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // عرض صناديق الفئات اسماء الفئات
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: categoriesName.length,
                            itemBuilder: (context, index) {
                              bool isActive = selectedCategory == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = index;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? color.p900
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(48),
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
                                        ? fonts.mb.copyWith(color: color.g50)
                                        : fonts.ms.copyWith(color: color.g400),
                                  ),
                                ),
                              );
                            }),
                      ),
                      // عرض منجات الفئات
                      filteredProduct.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 8),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: filteredProduct.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 0.70,
                                    ),
                                    itemBuilder: (context, index) {
                                      final product = filteredProduct[index];
                                      return Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: ProductCard(
                                          id: product["id"],
                                          image: product["images"][0],
                                          title: product["title"],
                                          newPrice: product["newPrice"],
                                          oldPrice: product["oldPrice"],
                                          type: product["type"] ??
                                              ProductCardType.full,
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  "لا توجد منتجات في هذه الفئة حالياً، يمكنك تصفح فئات أخرى",
                                  style: fonts.h6.copyWith(color: color.g100),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ===== بانر السلة =====
          if (inCart)
            Positioned(
              bottom: 2,
              left: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "cart");
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.p500,
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            color: color.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${totalPrice.toStringAsFixed(0)} \$",
                            style: fonts.lb.copyWith(
                              color: color.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "عرض السلة",
                        style: fonts.lb.copyWith(
                          color: color.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      //=============== الازرار السفليه تبداء هنا ======
      bottomNavigationBar: Container(
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
            currentIndex: footerCurrentIndex,
            backgroundColor: color.dark2,
            selectedItemColor: color.p400,
            unselectedItemColor: color.g400,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushNamed(context, "account");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Account()),
                // );
              }
              if (index == 1) {
                Navigator.pushNamed(context, "cart");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Cart()),
                // );
              }

              if (index == 2) {
                Navigator.pushNamed(context, "orders");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Orders()),
                // );
              }

              if (index == 3) {
                Navigator.pushNamed(context, "/");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "حسابي",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    if (cartSize > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color.p500,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.dark2,
                              width: 1.5,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              "${cartSize.toStringAsFixed(0)}",
                              style: fonts.xsb.copyWith(
                                color: color.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartSize > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color.p500,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.dark2,
                              width: 1.5,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              "${cartSize.toStringAsFixed(0)}",
                              style: fonts.xsb.copyWith(
                                color: color.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
