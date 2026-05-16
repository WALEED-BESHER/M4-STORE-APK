import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'cart_data.dart';
import 'package:flutter/services.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

// شكل الصندوق الخارجي
Widget theBoxShape(Widget finish){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(1),
    margin: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.g400, width: 2),
    ),
    child: finish,
  );
}

// اقسام اول صندوق
Widget _Box1_sections(String btnText,String title , IconData icon , VoidCallback btnAction ,{TextStyle? st}){
  TextStyle trying = st ?? fonts.sm;
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // الزر الذي في الجهه اليسرى 
        Container( 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(48),
            highlightColor: color.info,
            onTap: btnAction,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
              ),
              child: Text(
                btnText,
                style: fonts.xss.copyWith(
                  color: color.info,
                  decoration: TextDecoration.underline,
                  decorationColor: color.info
                ),
                textAlign: TextAlign.right,
              ),
            ),                           
          ),
        ),

        // الايقونه الحمراء + العنوان
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child:Text(
                  title,
                  style: trying.copyWith(color: color.white),
                  textAlign: TextAlign.right,
                  softWrap: true,
                ), 
              ),
              
              SizedBox(width: 6,),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.p500,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Center(
                  child: Icon(icon,color: color.white,size: 24,),
                ),
              ),
            ],
          ),
        ),

      ],
    ),
  );
}

// عنوان طرق الدفع
Widget paymentTitle(String selectedPayment){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: BoxDecoration(
      color: color.f_secondary,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "طرق الدفع (${selectedPayment})",
          style: fonts.sb.copyWith(color: color.white),
        ),
        SizedBox(width: 6,),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.p500,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Center(
            child: Icon(Icons.payment_outlined,color: color.white,size: 24,),
          ),
        ),
      ],
    ),
  );
}

// اختيارات طرق الدفع
Widget paymentOption({
  required String title,
  required String value,
  required String groupValue,
  required ValueChanged<String?> onChanged,
}) {
  return SizedBox(
    height: 35,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: fonts.sm.copyWith(
                color: color.white,
              ),
            ),
          ),

          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,

            activeColor: color.p500,

            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return color.p500;
              }
              return color.p500;
            }),
          ),
        ],
      ),
    ),
  );
}


//  عنوان المنتجات المطلوبه
Widget boxTitles({
  required bool show,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: BoxDecoration(
        color: color.f_secondary,
        border: Border(
            bottom: BorderSide(
                color: show ? color.g400 : Colors.transparent,
                width: show ? 2 : 0))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DottedBorder(
          color: color.white,
          strokeWidth: 2,
          dashPattern: [8, 12],
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                show ? Icons.expand_less : Icons.expand_more,
                size: 28,
                color: color.white,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: fonts.lb.copyWith(color: color.white),
        ),
      ],
    ),
  );
}

// جدول المنتجات المطلوبه 
Widget orderedProducts(String product, String price, String qty, String total,
    {bool? isHeader}) {
  isHeader = isHeader ?? false;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: color.g400, width: isHeader ? 2 : 1)),
        color: isHeader ? color.f_secondary : Colors.transparent),
    child: Row(
      children: [
        Expanded(
          // الاجمالي
          child: Text(
            total,
            textAlign: TextAlign.center,
            style: isHeader
                ? fonts.sb.copyWith(color: color.white)
                : fonts.xsb.copyWith(color: color.g200),
          ),
        ),
        Expanded(
          // الكميه
          child: Text(
            qty,
            textAlign: TextAlign.center,
            style: isHeader
                ? fonts.sb.copyWith(color: color.white)
                : fonts.xsb.copyWith(color: color.g200),
          ),
        ),
        Expanded(
          // السعر
          child: Text(
            price,
            textAlign: TextAlign.center,
            style: isHeader
                ? fonts.sb.copyWith(color: color.white)
                : fonts.xsb.copyWith(color: color.g200),
          ),
        ),
        Expanded(
          // المنتج
          flex: 3,
          child: Text(
            product,
            textAlign: TextAlign.end,
            style: isHeader
                ? fonts.sb.copyWith(color: color.white)
                : fonts.xsb.copyWith(color: color.g200),
          ),
        ),
      ],
    ),
  );
}

// السعر الاجمالي + سعر التوصيل + نسبه الخصم اذا وجد
Widget boxBody(String title, String body, {TextStyle? st, bool? isprice, Color? discount }) {
  TextStyle trying = st ?? fonts.sb;
  bool ispriceing = isprice ?? false;
  Color maincolor = discount ?? color.white;
  return Container(
    //===========  تاريخ الطلب  =========
    width: double.infinity,
    padding: ispriceing
        ? EdgeInsets.symmetric(horizontal: 8)
        : EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          body,
          style: trying.copyWith(color: maincolor),
        ),
        Text(
          title,
          style: trying.copyWith(color: maincolor),
        ),
      ],
    ),
  );
}


class _CheckoutState extends State<Checkout> {
  // افراغ السله
  void clearCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: color.dark2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "إفراغ السلة",
            textAlign: TextAlign.center,
            style: fonts.lb.copyWith(
              color: color.white,
            ),
          ),
          content: Text(
            "هل انت متأكد انك تريد افراغ السلة؟",
            textAlign: TextAlign.center,
            style: fonts.sm.copyWith(
              color: color.g200,
            ),
          ),
          actions: [
            // زر الغاء
            Row(
              children: [
                Expanded(
                  child: p_button(
                    title: "نعم", 
                    onPressed: (){
                      setState(() {
                        CartData.removeAllCart();
                      });
                      p_snackbar.show(
                        context: context,
                        title: 'تم افراغ السله بنجاح',
                        timer: Duration(seconds: 3),             
                      );
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    fontType: fonts.sb,
                  ),
                ),
                SizedBox(width: 4,),
                Expanded(
                  child: p_button(
                    title: "الغاء", 
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    fontType: fonts.sb,
                    background: color.dark1,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // كنترولر الخاص بي القسيمه
  TextEditingController couponController = TextEditingController(text: CartData.couponCode);
  // اظهار ال input
  bool showCouponInput = false;
  // هل تم تفعيل القسيمه
  bool couponApplied = CartData.couponApplied;
  // رساله الخطاء
  String couponError = "";
  // قيمة الخصم
  double discountAmount = 0;

  List<Map<String, dynamic>> coupons = [
    // خصم نسبة
    {
      "code": "1234",
      "type": "percent",
      "value": 10,
    },
    // خصم مبلغ ثابت
    {
      "code": "5555",
      "type": "fixed",
      "value": 5,
    },
    {
      "code": "9999",
      "type": "fixed",
      "value": 20,
    },
  ];

  // حساب نسبه الخصم
  void applyCoupon(double totalPrice){
    String enteredCode = couponController.text.trim();
    couponError = "";
    final coupon = coupons.firstWhere(
      (item) => item["code"] == enteredCode,
      orElse: () => {},
    );
    // اذا القسيمه غير موجوده
    if(coupon.isEmpty){
      setState(() {
        couponApplied = false;
        discountAmount = 0;
        couponError = "قسيمة التخفيض غير صحيحة";
      });
      return;
    }
    double discount = 0;
    // خصم نسبة
    if(coupon["type"] == "percent"){
      discount = totalPrice * (coupon["value"] / 100);
    }
    // خصم مبلغ ثابت
    else if(coupon["type"] == "fixed"){
      discount = coupon["value"].toDouble();
    }
    // منع الخصم اذا اكبر من السعر
    if(discount > totalPrice){
      discount = totalPrice;
    }
    setState(() {
      couponApplied = true;
      discountAmount = discount;
      couponError = "";
      CartData.couponApplied = true;
      CartData.couponCode = enteredCode;
    });
  }
  // حساب نسبه الخصم اذا دخل المستخدم من جديد
  double calculateDiscount(double totalPrice) {
    // اذا لا يوجد قسيمة
    if (!couponApplied) {
      return 0;
    }
    // جلب القسيمة
    final coupon = coupons.firstWhere(
      (item) => item["code"] == couponController.text.trim(),
      orElse: () => {},
    );
    // اذا غير موجودة
    if (coupon.isEmpty) {
      return 0;
    }
    double discount = 0;
    // خصم نسبة
    if (coupon["type"] == "percent") {
      discount =totalPrice * (coupon["value"] / 100);
    }
    // خصم مبلغ ثابت
    else if (coupon["type"] == "fixed") {
      discount = coupon["value"].toDouble();
    }
    // منع الخصم اذا اكبر من السعر
    if (discount > totalPrice) {
      discount = totalPrice;
    }
    return discount;
  }


  // ================= ملاحظة الطلب =================
  bool showOrderNoteInput = false;
  bool orderNoteSaved = false;
  TextEditingController orderNoteController = TextEditingController(text: CartData.orderNote);
  FocusNode orderNoteFocus = FocusNode();



  // اختيار طريقه الدفع
  String selectedPayment = CartData.selectedPayment;

  // متغيرات اسم شبكه التحويل + رقم الحواله
  TextEditingController networkName = TextEditingController(text: CartData.networkName);
  TextEditingController transferNumber = TextEditingController(text: CartData.transferNumber);

  // اظهار المنتجات و اخفائها
  bool showneededProducts = false;




  

  
  @override
  Widget build(BuildContext context) {
    // حساب اجمالي سعر المنتجات متغير + داله
    double totalPrice = 0;
    for (var item in CartData.cartItems) {
      totalPrice +=item["newPrice"] * item["quantity"];
    }

    // سعر التوصيل
    double deliveryPrice = 5;
    // اجمالس سعر المنتجات مع التوصيل 
    discountAmount = calculateDiscount(totalPrice);
    double grandTotal = totalPrice + deliveryPrice - discountAmount;

    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "تاكيد الطلب",
        centerTheTitles: true,
        showLeading: true,
        showbtn1: false,
        showLeadingBorder: false,
        btn2icon: Icons.delete,
        btn2_Onprss: () {
          clearCartDialog();
        },
      ),

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [

              // box 1
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // قسيمة التخفيض
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          // الزر
                          InkWell(
                            borderRadius: BorderRadius.circular(48),
                            onTap: () {
                              // اول ضغطه
                              if(!showCouponInput){
                                setState(() {
                                  showCouponInput = true;
                                });
                              }
                              // بعد ظهور input
                              else if(!couponApplied){
                                applyCoupon(totalPrice);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                couponApplied
                                ? "تم احتساب الخصم"
                                : showCouponInput
                                  ? "تأكيد"
                                  : "إضافة",
                                style: fonts.xss.copyWith(
                                  color: couponApplied
                                  ? Colors.green
                                  : color.info,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          // المحتوى
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // قبل ظهور input
                                // اذا الخصم متفعل
                                if(couponApplied)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "لقد حصلت على تخفيض : ${discountAmount.toStringAsFixed(0)} \$",
                                        textAlign: TextAlign.right,
                                        style: fonts.xsm.copyWith(
                                          color: color.success,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color.p500,
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Icon(
                                        Icons.card_giftcard,
                                        color: color.white,
                                      ),
                                    ),
                                  ],
                                ),

                                // اذا الخصم غير متفعل
                                if(!couponApplied && !showCouponInput)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "هل لديك قسيمة تخفيض؟",
                                      style: fonts.sm.copyWith(
                                        color: color.white,
                                      ),
                                    ),

                                    SizedBox(width: 6),

                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color.p500,
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Icon(
                                        Icons.card_giftcard,
                                        color: color.white,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // بعد ظهور input
                                if(showCouponInput)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //الايقونة + المدخل حق الخصم
                                    couponApplied 
                                      ? SizedBox()
                                      :Expanded( 
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color.dark2,
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(
                                                  color:
                                                  couponError.isNotEmpty
                                                    ? Colors.red
                                                    : color.g500,
                                                ),
                                              ),
                                              child: TextField(
                                                controller: couponController,
                                                // ارقام فقط
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
                                                style:fonts.xsb.copyWith(
                                                  color: color.white,
                                                ),
                                                textAlign: TextAlign.right,
                                                decoration:InputDecoration(
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                  hintText: "ادخل كود الخصم",
                                                  hintStyle: fonts.xsb.copyWith(
                                                    color: color.g400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // الخطأ
                                            if(couponError.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                                right: 4,
                                              ),
                                              child: Text(
                                                couponError,
                                                style: fonts.xss.copyWith(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ), 
                                          ],
                                        ),
                                      ),
                                                  
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: color.g400,
                      height: 4,
                    ),

                    // العنوان المحدد
                    _Box1_sections(
                      "تغير",
                      "شارع بيروت جوار شركه العملاق للصرافة والتحويلات ",
                      Icons.location_on,
                      (){},
                      st: fonts.xsm
                    ),
                    Divider(
                      color: color.g400,
                      height: 4,
                    ),
                   
                    // ================= ملاحظة الطلب =================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ================= الزر =================
                          InkWell(
                            borderRadius: BorderRadius.circular(48),
                            onTap: () {
                              // اول ضغطه = اظهار input
                              if (!showOrderNoteInput &&!orderNoteSaved) {
                                setState(() {
                                  showOrderNoteInput = true;
                                });
                                Future.delayed(
                                  Duration(milliseconds: 100),
                                  () {
                                    orderNoteFocus.requestFocus();
                                  },
                                );
                              }
                              // تاكيد
                              else if (showOrderNoteInput && !orderNoteSaved) {
                                setState(() {
                                  showOrderNoteInput = false;
                                  orderNoteSaved = true;
                                  CartData.orderNote = orderNoteController.text.trim();
                                });
                              }
                              // تعديل
                              else if (orderNoteSaved) {
                                setState(() {
                                  showOrderNoteInput = true;
                                  orderNoteSaved = false;
                                });
                                Future.delayed(
                                  Duration(milliseconds: 100),
                                  () {
                                    orderNoteFocus.requestFocus();
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                orderNoteSaved
                                  ? "تعديل"
                                  : showOrderNoteInput
                                      ? "تأكيد"
                                      : "إضافة",
                                style: fonts.xss.copyWith(
                                  color: color.info,
                                  decoration:TextDecoration.underline,
                                  decorationColor: color.info,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          // ================= المحتوى =================
                          Expanded(
                            child: Row(
                              children: [
                                // النص او input
                                Expanded(
                                  child: showOrderNoteInput
                                    // ================= input =================
                                    ? Container(
                                        padding:EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color.dark2,
                                          borderRadius:BorderRadius.circular(14),
                                          border: Border.all(
                                            color: color.g500,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: orderNoteController,
                                          focusNode: orderNoteFocus,
                                          style: fonts.xsb.copyWith(
                                            color: color.white,
                                          ),
                                          cursorColor: color.p500,
                                          textAlign: TextAlign.right,
                                          textDirection:  TextDirection.rtl,
                                          minLines: 1,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            isCollapsed: true,
                                            hintText: "اكتب ملاحظة الطلب",
                                            hintStyle: fonts.xsb.copyWith(
                                              color: color.g400,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                      // ================= النص =================
                                      : Text(
                                          orderNoteController
                                                  .text.isNotEmpty
                                              ? orderNoteController.text
                                              : "ملاحظة الطلب",
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          overflow: TextOverflow.ellipsis,
                                          style: fonts.sm.copyWith(
                                            color: color.white,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 6),
                                // ================= الايقونة =================
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.p500,
                                    borderRadius:
                                        BorderRadius.circular(48),
                                  ),
                                  child: Icon(
                                    Icons.note_alt_outlined,
                                    color: color.white,
                                    size: 24,
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

              //box 2
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // عنوان طرق الدفع
                    paymentTitle(selectedPayment), 
                    Divider(
                      color: color.g400,
                      height: 4,
                      thickness: 2,
                    ),

                    // اختيارات طرق الدفع
                    Column( 
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        paymentOption(
                          title: "الدفع عند الاستلام",
                          value: "عند الاستلام",
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                              CartData.selectedPayment =value;
                            });
                          },
                        ),
                        paymentOption(
                          title: "الدفع عبر حوالة شبكة محلية",
                          value: "حوالة شبكة محلية",
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                              CartData.selectedPayment =value;
                            });
                          },
                        ),      
                        paymentOption(
                          title: "الدفع عبر محفظه اكترونيه",
                          value: "عبر محفظه اكترونيه",
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                              CartData.selectedPayment =value;
                            });
                          },
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
              
              // box 3
              if(selectedPayment == "حوالة شبكة محلية")
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                      child: Text(
                        " عليك التحويل باسم: الوليد عبدالله عبدالكريم بشر",
                        textAlign: TextAlign.right,
                        style: fonts.sb.copyWith(
                          color: color.white,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                      child: Text(
                        "الرقم : 770411921",
                        textAlign: TextAlign.right,
                        style: fonts.sb.copyWith(
                          color: color.white,
                        ),
                      ),
                    ),
                    
                   // اسم الشبكه
                   Padding(
                      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // input of network name
                          Expanded(
                            child:Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5.5,
                              ),
                              decoration: BoxDecoration(
                                color: color.dark2,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border: Border.all(
                                  color: color.g500,
                                ),
                              ),
                              child: TextFormField(
                                controller: networkName,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* اسم الشبكة مطلوب";
                                  }
                                  return null;
                                },
                                style: fonts.xsb.copyWith(
                                  color: color.white,
                                ),
                                onChanged: (value){
                                  CartData.networkName = value;
                                },
                                cursorColor: color.p500,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                minLines: 1,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: "اسم الشبكه",
                                  hintStyle: fonts.xsb.copyWith(
                                    color: color.g400,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ), 
                          ),

                          // label of network name
                          Padding( 
                            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 4),
                            child: Text(
                              "اسم الشبكه",
                              textAlign: TextAlign.right,
                              style: fonts.sm.copyWith(
                                color: color.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), 

                    // رقم الحواله
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // input of network name
                          Expanded(
                            child:Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5.5,
                              ),
                              decoration: BoxDecoration(
                                color: color.dark2,
                                borderRadius:
                                    BorderRadius.circular(14),
                                border: Border.all(
                                  color: color.g500,
                                ),
                              ),
                              child: TextFormField(
                                controller: transferNumber,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* رقم الحواله مطلوب";
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  CartData.transferNumber = value;
                                },
                                style: fonts.xsb.copyWith(
                                  color: color.white,
                                ),
                                cursorColor: color.p500,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                minLines: 1,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: "رقم الحواله",
                                  hintStyle: fonts.xsb.copyWith(
                                    color: color.g400,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ), 
                          ),

                          // label of network name
                          Padding( 
                            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 4),
                            child: Text(
                              "رقم الحواله",
                              textAlign: TextAlign.right,
                              style: fonts.sm.copyWith(
                                color: color.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), 
                  ],
                ),
              ),

              
              

              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // المنتجات المطلوبه
                    boxTitles(
                      // المنتجات المطلوبه
                      show: showneededProducts,
                      title: "المنتجات المطلوبة",
                      onTap: () {
                        setState(() {
                          showneededProducts = !showneededProducts;
                        });
                      }
                    ),

                    if (showneededProducts)
                      Container(
                        child: Column(
                          children: [
                            orderedProducts(
                                "المنتج", "السعر", "الكميه", "الاجمالي",
                                isHeader: true),
                            ...CartData.cartItems.map((item) {
                              int total = item["newPrice"] * item["quantity"];

                              return orderedProducts(
                                item["title"],
                                item["newPrice"].toString(),
                                item["quantity"].toString(),
                                total.toString(),
                              );
                            }).toList(),

                            // اضافه منتج مخصص
                            if(CartData.customProduct.isNotEmpty)
                            orderedProducts(
                              CartData.customProduct,
                              "-",
                              "-",
                              "-",
                            ),
                          ],
                        ),
                      ),

                    // الاجمالي + سعر التوصيل
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          boxBody("الاجمالي", "${totalPrice.toStringAsFixed(0)} \$",
                              st: fonts.lb, isprice: true),
                          SizedBox(
                            height: 4,
                          ),
                          boxBody(
                              "سعر التوصيل", "${deliveryPrice.toStringAsFixed(0)} \$",
                              st: fonts.ss, isprice: true),
                          SizedBox(
                            height: 4,
                          ),
                          if(couponApplied)
                          boxBody(
                            "الخصم",
                            "- ${discountAmount.toStringAsFixed(0)} \$",
                            st: fonts.xss,
                            isprice: true,
                            discount: color.p500
                          ),
                        ],
                      ),
                    ),

                    // الاجمالي
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: color.p500,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${grandTotal.toStringAsFixed(0)} \$",
                            style: fonts.lb.copyWith(color: color.white),
                          ),
                          Text(
                            "الاجمالي",
                            style: fonts.lb.copyWith(color: color.white),
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
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
        color: color.dark2,
        child: Row(
          children: [
            Expanded(
              child: p_button(
                title: "تنفيذ الطلب", 
                onPressed: (){},
                fontType: fonts.mb,
              ),
            ),
            SizedBox(width: 6,),
            Expanded(
              child: p_button(
                title: "تعديل السله", 
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "editcart");
                }, 
                background: color.dark1,
                fontType: fonts.ms,
              ),
            ),
          ],
        ),
      ),

    );
  }
}