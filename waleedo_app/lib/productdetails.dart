import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/ProductCard/product_card.dart';
import 'Design System/Buttons/primary_button.dart';
import 'cart_data.dart';
import 'product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants/api.dart';
import 'dart:convert';

class Productdetails extends StatefulWidget {
  final int productId;
  const Productdetails({super.key , required this.productId});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {

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

  // المنتج الحالي الذي سيتم عرضه في الصفحة
  // يتم جلبه من API حسب الـ id القادم من الصفحة السابقة
  Map<String , dynamic>? product;

  // جميع المنتجات القادمة من API
  // تستخدم للبحث عن المنتج الحالي والمنتجات المشابهة
  List<Map<String, dynamic>> products = [];
  // ❤️ القلب 
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // أول دالة تعمل عند فتح الصفحة
    // تقوم بجلب بيانات المنتج وفحص إذا كان موجوداً في السلة
    loadProduct();
    

    final existingProduct = CartData.getProduct(widget.productId);
    if (existingProduct != null) {
      inCart = true;
      quantity = existingProduct["quantity"];
    } else {
      inCart = false;
      quantity = 1;
    }
  }

  // جلب جميع المنتجات من API
  // ثم البحث عن المنتج الذي يطابق الـ id القادم من الصفحة السابقة
  Future<void> loadProduct() async {
    products = await ProductService.getProducts();
    try {
      // البحث عن المنتج المطلوب حسب ال id
      final foundProduct = products.firstWhere(
        (item) => item["id"] == widget.productId,
      );
      setState(() {
        product = foundProduct;
        isFavorite = foundProduct["isFavorites"] ?? false;
      });
    } catch (_) {
      setState(() {
        product = null;
      });
    }
  }


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
  // bool isFavorite;

  // متغيرات زر اضافه الى السله
  late bool inCart;
  late int quantity;
  

  Widget build(BuildContext context) {
    
    // أثناء انتظار البيانات من API
    // يتم عرض مؤشر تحميل
    if(product ==null){
      return const Scaffold(
        backgroundColor: color.dark1,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    // المنتج الحالي بعد التأكد من وجود البيانات
    final currentProduct = product!;
    
    // معرفه نوع ال type اذا مافي قيمه يعطيه قيمه افتراضي
    final Type = currentProduct["type"];
    // متغير لاظهار واخفاء الخصم
    bool showDiscount = 
    Type == "full" || 
    Type == "hideOldPrice";
    // متغير لاظهار واخفاء السعر السابق
    bool showOldPrice = 
    Type == "full" || 
    Type == "hideDiscount";

    // نسبه الخصم
    int? discount;
    
    // داله احتساب نسبه الخصم
    if(currentProduct["oldPrice"] != null && showDiscount){
      discount = (((currentProduct["oldPrice"]! - currentProduct["newPrice"]) / currentProduct["oldPrice"]!) * 100).toInt();
    }

    // الاجمالي
    int totalPrice = currentProduct["newPrice"] * quantity;

    // داله جلب المنتجات المشابهه
    final currentType = currentProduct["ProductType"];
    final currentType2 = currentProduct["ProductType2"];
    final currentCategory = currentProduct["category"];
    final currentLength = currentProduct["length"];

    final List<Map<String, dynamic>> relatedProducts = products
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
                            currentPhoto = (index % currentProduct["images"].length).toInt();
                          });
                        },
                        itemBuilder: (context, index) {
                          final realIndex = index % currentProduct["images"].length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                // color: color.dark2, // خلفية
                                child: Image.network(
                                  currentProduct["images"][realIndex],
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
                            "${currentPhoto + 1}/${currentProduct["images"].length}",
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
                                currentProduct["title"],
                                style: fonts.xlb.copyWith(color: color.white),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 8),

                            Row(//الاسعار 
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                (currentProduct["oldPrice"] != null && showDiscount) ?
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
                                (currentProduct["oldPrice"] != null && showOldPrice) ?
                                Text( // السعر القديم
                                  "${currentProduct["oldPrice"]}\$",
                                  style: fonts.ms.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: color.tRed,
                                    decorationThickness: 3,
                                    color: color.tRed,
                                  ),
                                ) : SizedBox(),
                                SizedBox(width: 12),
                                Text(// السعر الجديد
                                  "${currentProduct["newPrice"]}\$",
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
                                    currentProduct["Description"] ,
                                    style: fonts.sm.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 4,),
                                  Text( // عيار السلاح
                                    "● عيار : ${currentProduct["caliber"]}",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // سعه السلاح
                                    "● السعة : ${currentProduct["capacity"]} طلقة",
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
                                    "● الفئة : ${currentProduct["category"]}",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // مودل السلاح
                                    "● الموديل : ${currentProduct["model"]} ",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // وزن السلاح
                                    "● الوزن : ${currentProduct["weight"]} كيلو جرام",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // بلاد تصنيع السلاح
                                    "● بلاد التصنيع : ${currentProduct["manufacturing_countrey"]} ",
                                    style: fonts.sb.copyWith(color: color.g100),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: 2,),
                                  Text( // الشركه المصنعه للسلاح
                                    "● الشركه المصنعه : ${currentProduct["manufacturing_company"]}  ",
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
                                type:getProductCardType(
                                  product["type"],
                                ), 
                                isFavorite: product["isFavorites"],
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
                  onTap: () async {
                    try {
                      SharedPreferences s =await SharedPreferences.getInstance();
                      String? token =  s.getString("token");
                      final response = await http.post(
                        Uri.parse(
                          Api.toggleFavorites,
                        ),
                        headers: {
                          "Accept": "application/json",
                          "Authorization":"Bearer $token",
                        },
                        body: {
                          "product_id":currentProduct["id"].toString(),
                        },
                      );
                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        setState(() {
                          isFavorite =data["status"] == "added";
                          product!["isFavorites"] =isFavorite;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
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
                                  CartData.setProduct(currentProduct, quantity);
                                } else {
                                  // يرجع زر السلة
                                  inCart = false;
                                  quantity = 0;
                                  CartData.removeFromCart(currentProduct["id"]);
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
                                CartData.setProduct(currentProduct, quantity);
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
                      CartData.setProduct(currentProduct, quantity);
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
