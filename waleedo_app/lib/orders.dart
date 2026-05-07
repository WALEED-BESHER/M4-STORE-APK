import 'package:flutter/material.dart';
import 'package:waleedo_app/account.dart';
import 'package:waleedo_app/cart.dart';
import 'package:waleedo_app/constants/colors.dart';
import 'package:waleedo_app/constants/fonts.dart';
import 'package:waleedo_app/home.dart';
import 'package:waleedo_app/order_details.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'package:flutter/services.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

enum OrderStatus {
  // اشكال قالب الطلبات
  done,
  reject,
  processing,
  onTheWay,
}

Widget _orderbox(
  BuildContext context,
  Map order,
  List<Map<String, dynamic>> orderItems,
) {
  OrderStatus status;
  String title;
  IconData icon;
  switch (order["status"]) {
    case "done":
      status = OrderStatus.done;
      title = "تم التوصيل";
      icon = Icons.check_circle;
      break;
    case "reject":
      status = OrderStatus.reject;
      title = "مرفوض";
      icon = Icons.cancel;
      break;
    case "onTheWay":
      status = OrderStatus.onTheWay;
      title = "في الطريق اليك";
      icon = Icons.local_shipping;
      break;
    default:
      status = OrderStatus.processing;
      title = "قيد المعالجة";
      icon = Icons.hourglass_bottom;
  }
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetails(
                  order: order,
                  orderItems: orderItems,
                )),
      );
    },
    child: Container(
      // main box container
      width: double.infinity,
      padding: EdgeInsets.all(1),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.g400, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // title + order id
            width: double.infinity,
            color: color.f_secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    // orderid
                    decoration: BoxDecoration(
                      color: color.p500,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(50)),
                    ),
                    padding:
                        EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: order["id"].toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                              margin: EdgeInsets.all(12),
                              backgroundColor: color.p,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              content: Text(
                                "تم نسخ رقم الطلب",
                                style: fonts.mb.copyWith(color: color.white),
                                textAlign: TextAlign.end,
                              )),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            order["id"].toString(),
                            style: fonts.mb.copyWith(color: color.white),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.copy,
                            size: 20,
                            color: color.white,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  //state
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 7, bottom: 7, right: 10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: color.g400, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: fonts.mb.copyWith(color: color.white),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          icon,
                          size: 20,
                          color: color.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          status == OrderStatus.reject
              ? Container(
                  // the reason
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: color.g400, width: 1))),
                  child: Text(
                    order["why"],
                    style: fonts.ms.copyWith(color: color.white),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  ),
                )
              : SizedBox(),
          Container(
            // date + time
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: color.g400, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  //time
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      order["time"],
                      style: fonts.mb.copyWith(color: color.white),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: color.white,
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Row(
                  //date
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      order["date"],
                      style: fonts.mb.copyWith(color: color.white),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.calendar_month,
                      size: 20,
                      color: color.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            // total price
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: color.p500,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order["grand_total"].toString() + "\$",
                  style: fonts.lb.copyWith(color: color.white),
                ),
                Text(
                  "اجمالي الطلب ",
                  style: fonts.lb.copyWith(color: color.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// bottomNavigationBar
int footerCurrentIndex = 2;

class _OrdersState extends State<Orders> {
  //list
  List<Map<String, dynamic>> orders = [
    {
      "id": 1,
      "user_id": 5,
      "total": 9916,
      "delivery": 5,
      "grand_total": 9921,
      "status": "done",
      "date": "2026-05-04",
      "time": "19:20",
      "payment": "عند الاستلام",
      "location": " شارع بيروت جوار شركه العملاق للصرافة والتحويلات ",
      "orderNote": " يرجى الاسراع",
    },
    {
      "id": 2,
      "user_id": 6,
      "total": 6450,
      "delivery": 5,
      "grand_total": 6455,
      "status": "processing",
      "date": "2026-05-05",
      "time": "19:20",
      "payment": "حواله",
      "location": "   جوار شركه العملاق للصرافة والتحويلات ",
      "orderNote": " يرجى الاسراع",
    },
    {
      "id": 3,
      "user_id": 6,
      "total": 6450,
      "delivery": 5,
      "grand_total": 6455,
      "status": "onTheWay",
      "date": "2026-05-05",
      "time": "19:20",
      "payment": "حواله",
      "location": "   جوار شركه العملاق للصرافة والتحويلات ",
      "orderNote": " يرجى الاسراع",
    },
    {
      "id": 4,
      "user_id": 6,
      "total": 0,
      "delivery": 0,
      "grand_total": 0,
      "status": "reject",
      "why":" الحواله مزوره",
      "date": "2026-05-05",
      "time": "19:20",
      "payment": "حواله",
      "location": "   جوار شركه العملاق للصرافة والتحويلات ",
      "orderNote": " يرجى الاسراع",
    },
  ];

  List<Map<String, dynamic>> orderItems = [
    {
      "id": 1,
      "order_id": 1,
      "product": "ايكي روسي طويل وكاله AK-103  زيرو ما قد استخدم",
      "price": 3200,
      "qty": 1,
    },
    {
      "id": 2,
      "order_id": 1,
      "product": " ايكي AK-104 روسي قصير أسود مقرطس ",
      "price": 3250,
      "qty": 1,
    },
    {
      "id": 3,
      "order_id": 1,
      "product": "شرمه جديد مع التوابع استخدام اسبوع فقط",
      "price": 3466,
      "qty": 1,
    },
    {
      "id": 4,
      "order_id": 2,
      "product": "ايكي روسي طويل وكاله AK-103  زيرو ما قد استخدم",
      "price": 3200,
      "qty": 1,
    },
    {
      "id": 5,
      "order_id": 2,
      "product": " ايكي AK-104 روسي قصير أسود مقرطس ",
      "price": 3250,
      "qty": 1,
    },
    {
      "id": 6,
      "order_id": 3,
      "product": "ايكي روسي طويل وكاله AK-103  زيرو ما قد استخدم",
      "price": 3200,
      "qty": 1,
    },
    {
      "id": 7,
      "order_id": 3,
      "product": " ايكي AK-104 روسي قصير أسود مقرطس ",
      "price": 3250,
      "qty": 1,
    },
    {
      "id": 8,
      "order_id": 4,
      "product": " ايكي AK-104 روسي قصير أسود مقرطس ",
      "price": 3250,
      "qty": 1,
    },
  ];
  @override
  Widget build(BuildContext context) {
    //
    var rejectOrders = orders.where((o) => o["status"] == "reject").toList();
    var doneOrders = orders.where((o) => o["status"] == "done").toList();

    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "طلباتي",
        centerTheTitles: true,
        showLeading: true,
        showbtn2: false,
        btn1icon: Icons.refresh,
        btn1_Onprss: () {
          setState(() {});
        },
        showLeadingBorder: false,
        showAction: false,
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 2,
        child: Column(
          children: [
            // 🔴 التابات tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.p900, width: 2),
              ),
              child: TabBar(
                labelStyle: fonts.sb.copyWith(color: color.white),
                unselectedLabelColor: color.g500,
                indicator: BoxDecoration(
                  color: color.p700,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.all(1.5),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                splashFactory: InkSparkle.splashFactory,
                enableFeedback: true,
                tabs: const [
                  // 🔹 ملغي
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("ملغي"),
                        SizedBox(width: 4),
                        Icon(Icons.cancel, size: 20),
                      ],
                    ),
                  ),

                  // 🔹 تم التوصيل
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("تم التوصيل"),
                        SizedBox(width: 4),
                        Icon(Icons.check_circle, size: 20),
                      ],
                    ),
                  ),

                  // 🔹 الكل
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("الكل"),
                        SizedBox(width: 4),
                        Icon(Icons.list, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔽 محتوى كل تاب
            Expanded(
              child: TabBarView(
                children: [
                  // 🔹 ملغي
                  Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rejectOrders.length,
                            itemBuilder: (context, index) {
                              var order = rejectOrders[index];
                              var currentOrderItems = orderItems.where((item) {
                                return item["order_id"] == order["id"];
                              }).toList();
                              return _orderbox(
                                  context, order, currentOrderItems);
                            }),
                      )),

                  // 🔹 تم التوصيل
                  Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: doneOrders.length,
                            itemBuilder: (context, index) {
                              var order = doneOrders[index];
                              var currentOrderItems = orderItems.where((item) {
                                return item["order_id"] == order["id"];
                              }).toList();
                              return _orderbox(
                                  context, order, currentOrderItems);
                            }),
                      )),
                  // 🔹 الكل
                  Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              var order = orders[index];
                              var currentOrderItems = orderItems.where((item) {
                                return item["order_id"] == order["id"];
                              }).toList();
                              return _orderbox(
                                  context, order, currentOrderItems);
                            }),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),

      //bottom navigation bar
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
                return ;
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
