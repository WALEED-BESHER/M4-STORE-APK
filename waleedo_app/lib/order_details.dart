import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waleedo_app/constants/colors.dart';
import 'package:waleedo_app/constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'package:flutter/services.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

//
Widget theBoxShape(Widget finish){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(1),
    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.g400, width: 2),
    ),
    child: finish,
  );
}


// العناوين حق الصناديق
Widget boxTitles({
  required bool show,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 6),
    decoration: BoxDecoration(
      color: color.f_secondary,
      border: Border(
        bottom: BorderSide(
          color: show ? color.g400 : Colors.transparent,width: show ? 2 :0
        )
      )
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DottedBorder(
          color: color.white,
          strokeWidth: 2,
          dashPattern: [8,12],
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Icon(show? Icons.expand_less :Icons.expand_more,size: 28,color: color.white,),
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

// الكلام داخل  الصندوق
Widget boxBody(String title , String body, {TextStyle? st, bool? isprice}){
  TextStyle trying = st ?? fonts.sb;
  bool ispriceing = isprice ?? false;
  return Container( //===========  تاريخ الطلب  =========
    width: double.infinity,
    padding: ispriceing ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          body,
          style: trying.copyWith(color: color.white) ,
        ),
        Text(
          title,
          style: trying.copyWith(color: color.white),
        ),
      ],
    ),
  );
}

// صندوق حاله الطلب الدواير الذي فيه
Widget circleStatus(bool isDone){
  return Container(
    width: 30,
    height: 30,
    margin: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: color.p,width: 2),
      color: isDone ? color.p : Colors.transparent,
    ),
    child: Icon(Icons.check,size: 20,color: color.white,),
  );
}
Widget lineStatus(bool isDone){
  return Container(
    padding: EdgeInsets.only(right: 14),
    child: Container(
      width: 2,
      height: 20,
      color: isDone ? color.p : color.white,
    ),
  );
}
Widget textStatus(String text ){
  return Text(text,style: fonts.mb.copyWith(color: color.white),);                         
}

Widget orderedProducts(String product , String price , String qty , String total , {bool? isHeader} ){
  isHeader = isHeader ?? false;
  return Container( 
    padding: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color.g400,width: isHeader ? 2 : 1)
      ),
      color: color.f_secondary
    ),
    child: Row(
      children: [
        Expanded( // الاجمالي
          child: Text(
            total,
            textAlign: TextAlign.center,style: isHeader ? fonts.sb.copyWith(color: color.white) : fonts.xsb.copyWith(color: color.g200),
          ) ,
        ),
        Expanded( // الكميه
          child: Text(
            qty,
            textAlign: TextAlign.center,style: isHeader ? fonts.sb.copyWith(color: color.white) : fonts.xsb.copyWith(color: color.g200),
          ) ,
        ),
        Expanded( // السعر
          child: Text(
            price,
            textAlign: TextAlign.center,style: isHeader ? fonts.sb.copyWith(color: color.white) : fonts.xsb.copyWith(color: color.g200),
          ) ,
        ),
        Expanded( // المنتج
          flex: 3,
          child: Text(
            product,
            textAlign: TextAlign.end,style: isHeader ? fonts.sb.copyWith(color: color.white) : fonts.xsb.copyWith(color: color.g200),
          ) ,
        ),
      ],
    ),
  );
}





class _OrderDetailsState extends State<OrderDetails> {
bool showOrderStatus = false;
bool showneededProducts = false;
bool showLocation = false;
bool showOrderNote = false;

  @override
  Widget build(BuildContext context) {
    int status = 0;// admin change this number
    bool doneProcessing = status >=1;
    bool onWay = status >=2;
    bool orderDone = status >=3;
    bool step1 = doneProcessing;
    bool step2 = doneProcessing && onWay;
    bool step3 = doneProcessing && onWay && orderDone;
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "تفاصيل الطلب",
        centerTheTitles: true,
        showLeading: true,
        showbtn2: true,
        btn1icon: Icons.refresh,
        btn2icon: Icons.print_outlined,
        btn1_Onprss: () {
          setState(() {});
        },
        btn2_Onprss: () {},
        showLeadingBorder: false,
        showAction: true,
      ),

      
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [

              // box 1
              //=========== صندوق تفاصيل الطلب =========
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container( //===========  تفاصيل الطلب + الحاله =========
                      width: double.infinity,
                      color: color.f_secondary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(//===========  حاله الطلب =========
                            decoration: BoxDecoration(
                              color: color.p500,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(50)),
                            ),
                            padding: EdgeInsets.only(
                                left: 8, right: 16, top: 8, bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  "تم التوصيل",
                                  style: fonts.mb.copyWith(color: color.white),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: color.white,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(top: 7, bottom: 7, right: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: color.g400, width: 2)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "تفاصيل الطلب",
                                    style:
                                        fonts.mb.copyWith(color: color.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //===========  تاريخ الطلب  =========
                    boxBody("تاريخ الطلب ","04-02-2026 19:20"),
                    Divider(color: color.g400,height: 0,),

                    //=========== طرق الدفع =========
                    boxBody("طرق الدفع","عند الاستلام"),
                    Divider(color: color.g400,height: 0,),
                   
                    Container( // =========== رقم الطلب ===========
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  Clipboard.setData(ClipboardData(text: "3583133"));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                      margin: EdgeInsets.all(12),
                                      backgroundColor: color.p,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      content: Text("تم نسخ رقم الطلب",style: fonts.mb.copyWith(color: color.white),textAlign: TextAlign.end,)
                                    ),
                                  );
                                },
                                child: Icon(Icons.copy_outlined,size: 20,color: color.white,),
                              ),
                              SizedBox(width: 6,),
                              Text(
                                "3583133",
                                style: fonts.mb.copyWith(color: color.p500),
                              ),
                            ],
                          ),
                          Text(
                            "رقم الطلب",
                            style: fonts.sb.copyWith(color: color.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //box 2
              //=========== صندوق حاله الطلب =========
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    boxTitles( // حاله الطلب
                      show: showOrderStatus, 
                      title: "حالة الطلب",
                      onTap: (){
                        setState(() {
                          showOrderStatus = !showOrderStatus;
                        });
                      }
                    ),

                    if(showOrderStatus)
                    Container( // الحالات
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              textStatus("قيد المراجعة"),
                              SizedBox(width: 12,),
                              circleStatus(step1),
                            ],
                          ),
                          lineStatus(step1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              textStatus("في الطريق اليك"),
                              SizedBox(width: 12,),
                              circleStatus(step2),
                            ],
                          ),
                          lineStatus(step2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              textStatus("تم التوصيل"),
                              SizedBox(width: 12,),
                              circleStatus(step3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //box3
              //=========== صندوق المنتجات المطلوبه =========
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // المنتجات المطلوبه
                    boxTitles( // المنتجات المطلوبه
                      show: showneededProducts, 
                      title: "المنتجات المطلوبة",
                      onTap: (){
                        setState(() {
                          showneededProducts = !showneededProducts;
                        });
                      }
                    ),
                    
                    if(showneededProducts)
                    Container(
                     child: Column(
                      children: [
                        orderedProducts("المنتج", "السعر" ,"الكميه" ,"الاجمالي" ,isHeader: true),
                        orderedProducts("امفور جديد كرت", "5000" ,"2" ,"10000"),
                        orderedProducts("امفور جديد كرت", "5000" ,"2" ,"10000"),
                        orderedProducts("امفور جديد كرت", "5000" ,"2" ,"10000"),
                      ],
                     ),
                    ),

                    // الاجمالي + سعر التوصيل                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          boxBody("الاجمالي", "15000 \$",st: fonts.lb,isprice: true),
                          SizedBox(height: 4,),
                          boxBody("سعر التوصيل", "5 \$",st: fonts.ss,isprice: true),
                        ],
                      ),
                    ),
                    
                    // الاجمالي
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      decoration: BoxDecoration(
                        color: color.p500,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "15005 \$",
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

              //box4
              //=========== صندوق  عنوان التوصيل=========
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    boxTitles( // عنوان التوصيل
                      show: showLocation, 
                      title: "عنوان التوصيل",
                      onTap: (){
                        setState(() {
                          showLocation = !showLocation;
                        });
                      }
                    ),

                    // العنوان
                    if(showLocation)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              " شارع بيروت جوار شركه العملاق للصرافة والتحويلات " ,
                              style: fonts.mb.copyWith(color: color.white),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(width: 12,),
                          Icon(Icons.location_on,size: 20,color: color.white,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //box 5
              // ============= ملاحظه الطلب =============
              theBoxShape(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    boxTitles( // ملاحظه الطلب
                      show:showOrderNote , 
                      title: "ملاحظة التوصيل", 
                      onTap: (){
                        setState(() {
                          showOrderNote = !showOrderNote;
                        });
                      }
                    ),

                    if(showOrderNote)
                    Container( // الملاحظه
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ملاحظة الطلب" ,
                              style: fonts.mb.copyWith(color: color.white),
                              textAlign: TextAlign.end,
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
      ),
    );
  }
}
