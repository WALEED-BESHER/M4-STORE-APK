import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/ProductCard/product_card.dart';
import 'Design System/Buttons/primary_button.dart';
import 'cart_data.dart';

class Productdetails extends StatefulWidget {
  final int productId;
  const Productdetails({super.key , required this.productId});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  @override

  @override
  void initState() {
    super.initState();

    final existingProduct = CartData.getProduct(widget.productId);
    if (existingProduct != null) {
      inCart = true;
      quantity = existingProduct["quantity"];

    } else {

      inCart = false;
      quantity = 1;

    }
  }

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
      "Description":"يُعد AK-103 من أحدث إصدارات عائلة الكلاشينكوف، حيث يجمع بين التصميم الكلاسيكي والمواد الحديثة. يتميز بقوة اعتماديته العالية في مختلف الظروف، سواء في البيئات الصحراوية أو الرطبة، بالإضافة إلى دقته المحسّنة مقارنة بالإصدارات القديمة. كما أن استخدامه الواسع في العديد من الجيوش حول العالم جعله من أكثر الأسلحة انتشارًا وتأثيرًا.",
      "caliber": "7.62×39",// عيار
      "capacity": "30", //السعه 
      "category": "بنادق",// الفىه
      "ProductType": "ايكي", // نوع السلاح
      "length":"طويل",
      "model": "AK-103",// مودل السلاح
      "weight": "3.4",// وزن السلاح
      "manufacturing_countrey": "روسيا",// بلاد الصنيع
      "manufacturing_company": "Kalashnikov Concern",// الشركه المصنعه
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
      "Description": "يُعد AK-104 من الإصدارات القصيرة لعائلة الكلاشينكوف، حيث يجمع بين القوة العالية والحجم المدمج، مما يجعله مناسبًا للعمليات السريعة والتنقل. يتميز باعتماديته الكبيرة في مختلف الظروف، وسهولة الاستخدام والصيانة مثل باقي عائلة AK، كما أنه خيار مفضل في البيئات الحضرية بسبب حجمه القصير مقارنة بالإصدارات التقليدية.",
      "caliber": "7.62×39",// عيار
      "capacity": "30", //السعه 
      "category": "بنادق",// الفىه
      "ProductType": "ايكي", // نوع السلاح
      "ProductType2":"جفري",
      "length":"قصير",
      "model": "AK-104",// مودل السلاح
      "weight": "3.2",// وزن السلاح
      "manufacturing_countrey": "روسيا",// بلاد الصنيع
      "manufacturing_company": "Kalashnikov Concern",// الشركه المصنعه
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
      "Description": "يُعد هذا السلاح من عائلة الكلاشينكوف المعروفة بمتانتها واعتماديتها العالية في أصعب الظروف. يتميز بسهولة الاستخدام والصيانة، إضافة إلى قوته في الأداء واستمراريته في العمل حتى في البيئات القاسية. كما أن انتشاره الواسع واستخدامه في العديد من الدول جعله من أكثر الأسلحة شهرة وتأثيرًا في العالم.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق",// الفىه
      "ProductType": "شرمه",
      "ProductType2":"ايكي",
      "length":"طويل",
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
      "Description": "يُعد هذا السلاح من عائلة الكلاشينكوف المعروفة بقوتها واعتماديتها العالية في مختلف الظروف. يتميز ببساطة التصميم وسهولة الاستخدام والصيانة، بالإضافة إلى قدرته على العمل بكفاءة حتى في البيئات القاسية. كما أن انتشاره الواسع جعله من أكثر الأسلحة تأثيرًا في العالم.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق",// الفىه
      "ProductType": "مشير",
      "length":"قصير",
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
      "images": ["assets/images/Motamarn.jpg",],
      "title": "موتمر ني كل جديد بلقرطاس",
      "newPrice": 4300,
      // "oldPrice": 6100,
      "Description": "يُعد هذا السلاح من النسخ القصيرة لعائلة الكلاشينكوف، ويتميز بحجمه الصغير وسهولة حمله، مما يجعله مثاليًا للعمليات السريعة والأماكن الضيقة. يتمتع بنفس اعتمادية الكلاشينكوف المعروفة، مع قدرة عالية على التحمل في الظروف القاسية. كما أن انتشاره بين القوات الخاصة وبعض الوحدات العسكرية زاد من شهرته بشكل كبير.",
      "caliber": "5.45×39",
      "capacity": "30",
      "category": "بنادق",
      "ProductType": "موتمر",
      "length":"قصير",
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
      "Description" : "يُعد MP5 من أشهر الرشاشات الخفيفة في العالم بسبب اعتماديته العالية واستخدامه الواسع لدى القوات الخاصة ووحدات الشرطة. يتميز بدقة ممتازة مقارنة بفئته، وسهولة التحكم أثناء الإطلاق، خاصة في المسافات القريبة. كما أن تصميمه المدمج جعله الخيار الأول للعمليات داخل المدن والمباني، وكان له تأثير كبير على تطوير الأسلحة الحديثة المشابهة.",
      "caliber" :  "9×19",// عيار 
      "capacity" : " 30 ",// السعه
      "category": "مسدسات",// الفىه  
      "ProductType" : "امبي فايف",
      "length":"قصير",
      "model": "MP5",
      "weight": "2.5",
      "manufacturing_countrey" :  "ألمانيا",
      "manufacturing_company":"Heckler & Koch",
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
      "title":  "مسدس مكروف حكومي روسي  وكاله",
      "newPrice": 2400,
      "oldPrice": 3200,
      "Description": "يُعد مسدس مكروف من أشهر المسدسات العسكرية بسبب اعتماديته العالية وبساطة تصميمه، حيث تم اعتماده كسلاح رسمي في الاتحاد السوفيتي لسنوات طويلة. يتميز بسهولة الاستخدام والصيانة، بالإضافة إلى تحمله للظروف القاسية، مما جعله خيارًا مفضلًا لدى العسكريين والأمن. كما أن تصميمه البسيط كان له تأثير واضح على العديد من المسدسات التي جاءت بعده.",
      "caliber": "9×18",
      "capacity": "8",
      "category": "مسدسات",
      "ProductType": "مكروف",
      "length":"قصير",
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
      "Description": "يُعد هذا النوع من عائلة الكلاشينكوف من أكثر الأسلحة انتشارًا بسبب قوته واعتماديته العالية في مختلف الظروف. يتميز بحجمه القصير وسهولة حمله، مما يجعله مناسبًا للعمليات السريعة والتنقل. كما أن تصميمه البسيط يجعله سهل الصيانة والاستخدام، وله تأثير كبير في عالم الأسلحة الخفيفة.",
      "caliber": "7.62×39",
      "capacity": "30",
      "category": "بنادق",
      "ProductType": "جفري",
      "length":"قصير",
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
      "Description": "تُعد قناصة دراغونوف من أشهر البنادق القنص العسكرية بسبب دقتها العالية واعتماديتها في مختلف الظروف القتالية. تم تطويرها لتكون سلاح دعم للقوات البرية، حيث تجمع بين القوة والمدى الجيد وسرعة الإطلاق مقارنة بالقناصات التقليدية. كما أنها استخدمت في العديد من الجيوش حول العالم، مما جعلها واحدة من أكثر القناصات شهرة وتأثيرًا.",
      "caliber": "7.62×54R",
      "capacity": "10",
      "category": "قناصات",
      "ProductType": "دراغونوف",
      "length":"طويل",
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

  // تصميم ايقونات ال appbar
  Widget _appbaricon(IconData icon, VoidCallback press) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: press,
        splashColor: color.b_defultred,
        highlightColor: color.b_defultred,
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 24,
            color: color.g400,
          ),
        ),
      ),
    );
  }

  // متغيرات الصوره
  PageController photoController = PageController();
  int currentPhoto = 0;

  

  // قالب الوصوف للمنتجات
  Widget _describtion(String title ,bool relatedProducts, Widget filling){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: relatedProducts ? Colors.transparent : color.dark2 ,
        borderRadius: relatedProducts ? BorderRadius.circular(0) : BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              title,
              style: relatedProducts ? fonts.lb.copyWith(color: color.white) :fonts.mb.copyWith(color: color.white),
              textDirection: TextDirection.rtl,
            ),
          ),

          Divider(color: relatedProducts ? color.dark3 : color.f_primary,thickness: 2,),

          Padding(
            padding: relatedProducts ? EdgeInsets.only(bottom: 4) : EdgeInsets.only(right: 24,left: 10),
            child: filling,
          ),
        ],
      ),
    );
  }

  // ❤️ القلب 
  bool isFavorite = false;

  // متغيرات زر اضافه الى السله
  late bool inCart;
  late int quantity;
  

  Widget build(BuildContext context) {
    // متغير لاستدعاء المنتج عبر ال id 
    final product = Products.firstWhere((item) => item["id"] == widget.productId,);

    // معرفه نوع ال type اذا مافي قيمه يعطيه قيمه افتراضي
    final Type = product["type"] ?? ProductCardType.full;
    // متغير لاظهار واخفاء الخصم
    bool showDiscount = 
    Type == ProductCardType.full || 
    Type == ProductCardType.hideOldPrice;
    // متغير لاظهار واخفاء السعر السابق
    bool showOldPrice = 
    Type == ProductCardType.full || 
    Type == ProductCardType.hideDiscount;

    // نسبه الخصم
    int? discount;
    
    // داله احتساب نسبه الخصم
    if(product["oldPrice"] != null && showDiscount){
      discount = (((product["oldPrice"]! - product["newPrice"]) / product["oldPrice"]!) * 100).toInt();
    }

    // الاجمالي
    int totalPrice = product["newPrice"] * quantity;

    // داله جلب المنتجات المشابهه
    final currentType = product["ProductType"];
    final currentType2 = product["ProductType2"];
    final currentCategory = product["category"];
    final currentLength = product["length"];

    final List<Map<String, dynamic>> relatedProducts = Products
        // 🔥 أول فلتر (إجباري): نفس الفئة فقط
        .where((item) =>
            item["id"] != widget.productId &&
            item["category"] == currentCategory)
            
        .map((item) {
          int score = 0;

          // 🔥 1- ProductType (أقوى)
          if (item["ProductType"] == currentType) {
            score += 4;
          }

          // 🔥 2- ProductType2 (اختياري)
          // يقارن ProductType2 مع ProductType الحالي
          if (item["ProductType2"] != null &&
              item["ProductType2"] == currentType) {
            score += 3;
          }

          // 🔥 3- length (اختياري)
          if (currentLength != null &&
              item["length"] != null &&
              item["length"] == currentLength) {
            score += 2;
          }

          // 🔥 (اختياري) لو تبغى تقارن Type2 مع Type2
          if (currentType2 != null &&
              item["ProductType2"] != null &&
              item["ProductType2"] == currentType2) {
            score += 1;
          }

          return {
            ...item,
            "score": score,
          };
        })

        
        .toList();

    // 🔥 ترتيب حسب القوة
    relatedProducts.sort((a, b) => b["score"].compareTo(a["score"]));

    
    return Stack(
      children: [
        Scaffold(
          backgroundColor: color.dark1,
          appBar: AppBar(
            backgroundColor: color.dark2,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _appbaricon(Icons.more_vert, () {}), // علامه الثلاث نقاط
                _appbaricon(Icons.share, () {}), // علامه المشاركه
                _appbaricon(Icons.shopping_cart_outlined, () {}), // علامه السله
                
              ],
            ),
            actions: [
              _appbaricon(Icons.arrow_forward, () {
                Navigator.pop(context);
              }) // علامة الرجوع
            ],
          ),

          body: Column(
            children: [
              SizedBox( height: 10,),

              Padding(// الصوره حق المنتج و عدد الصور
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.38,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: color.dark2,
                      ),
                      child: PageView.builder(
                        controller: photoController,
                        itemCount: 100000,
                        onPageChanged: (index) {
                          setState(() {
                            currentPhoto = (index % product["images"].length).toInt();
                          });
                        },
                        itemBuilder: (context, index) {
                          final realIndex = index % product["images"].length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                // color: color.dark2, // خلفية
                                child: Image.asset(
                                  product["images"][realIndex],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned( // عداد االصور 
                      bottom: 8,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${currentPhoto + 1}/${product["images"].length}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  // padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عاملين padding هنا
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(// 🔥 اسم السلاح او عنوانه
                              width: double.infinity,
                              child: Text(
                                product["title"],
                                style: fonts.xlb.copyWith(color: color.white),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 8),

                            Row(//الاسعار 
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (product["oldPrice"] != null && showDiscount) ?
                                Container( // نسبه الخصم
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("${discount.toString()} %",
                                    style: fonts.ss.copyWith(color: color.white),
                                  ),
                                ) : SizedBox(),

                                SizedBox(width: 12),
                                (product["oldPrice"] != null && showOldPrice) ?
                                Text( // السعر القديم
                                  "${product["oldPrice"]}\$",
                                  style: fonts.ms.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: color.tRed,
                                    decorationThickness: 3,
                                    color: color.tRed,
                                  ),
                                ) : SizedBox(),
                                SizedBox(width: 12),
                                Text(// السعر الجديد
                                  "${product["newPrice"]}\$",
                                  style: fonts.lb.copyWith(color: color.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            _describtion( // 🔥 وصف المنتج
                              "وصف المنتج:", 
                              false,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    product["Description"] ,
                                    style: fonts.sm.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 4,),
                                  Text( // عيار السلاح
                                    "● عيار : ${product["caliber"]}",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // سعه السلاح
                                    "● السعة : ${product["capacity"]} طلقة",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ) ,
                            ),
                            SizedBox(height: 12),

                            // 🔥 SPECIFICATIONS
                            _describtion(
                              "المواصفات :", 
                              false,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text( // فىه السلاح
                                    "● الفئة : ${product["category"]}",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // مودل السلاح
                                    "● الموديل : ${product["model"]} ",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // وزن السلاح
                                    "● الوزن : ${product["weight"]} كيلو جرام",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // بلاد تصنيع السلاح
                                    "● بلاد التصنيع : ${product["manufacturing_countrey"]} ",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // الشركه المصنعه للسلاح
                                    "● الشركه المصنعه : ${product["manufacturing_company"]}  ",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ) ,
                            ),                        
                          ],
                        ),
                      ),
                      // هنا بدون padding
                      // 🔥 منتجات ذات صله
                      if(relatedProducts.isNotEmpty)
                      _describtion(
                        "منتجات ذات صلة",
                        true, 
                        SizedBox(
                        height: 244,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: relatedProducts.length,
                          itemBuilder: (context, index) {
                            final product = relatedProducts[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: ProductCard(
                                id: product["id"],
                                image: product["images"][0],
                                title: product["title"]!,
                                newPrice: product["newPrice"],
                                oldPrice: product["oldPrice"],
                                type: product["type"] ?? ProductCardType.full, 
                              ),
                            );
                          }
                        ),
                      ),
                      ), 
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ===== الزر + القلب =====
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.dark1,),
            child: Row(
              children: [

                // ❤️ القلب 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? color.p500 : color.g100,
                    size: 24,
                  ),
                ),

                SizedBox(width: 6),

                Expanded(
                  child: inCart 
                  ? Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.dark2, 
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // ➖ ناقص
                        Expanded(
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                  CartData.setProduct(product, quantity);
                                } else {
                                  // يرجع زر السلة
                                  inCart = false;
                                  quantity = 0;
                                  CartData.removeFromCart(product["id"]);
                                }
                              });
                            }, 
                            icon: Icon(Icons.remove, color: color.g100, size: 24),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),

                        // 🔢 العدد
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.p500,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "$quantity",
                            style: fonts.mb
                                .copyWith(color: color.g100),
                          ),
                        ),

                        // ➕ زائد
                        Expanded(
                          child: IconButton(
                            onPressed: (){
                              setState(() {
                                quantity++;
                                CartData.setProduct(product, quantity);
                              });
                            }, 
                            icon: Icon(Icons.add, color: color.g100, size: 24),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ) 
                  : p_button(
                    title: "إضافة للسلة", 
                    onPressed: (){
                      setState(() {
                        inCart = true;
                        quantity = 1;
                      });
                      CartData.setProduct(product, quantity);
                    },
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
        if(inCart)
        Positioned(
          bottom: 55,
          left: 10,
          right: 10,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
              color: color.p500,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pushNamed(context, "cart");
                    }, 
                    icon: Icon(Icons.arrow_back_ios_new),color: color.white,),
                    SizedBox(width: 6,),
                    Text( 
                      "\$ ${totalPrice}",
                      style: fonts.lb.copyWith(color: color.white,decoration: TextDecoration.none),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                Text( 
                  "عرض السلة",
                  style: fonts.lb.copyWith(color: color.white,decoration: TextDecoration.none),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
