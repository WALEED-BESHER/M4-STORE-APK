import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Inputs/primary_input.dart';
import 'cart_data.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  //
  Widget theBoxShape(Widget finish) {
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

  //
  // ================== عناوين التوصيل ==================
  List<String> locations = [
    "شارع بيروت بجوار شركة الصادق للصرافة والحوالات",
    "حدة - صنعاء",
    "تعز - جولة وادي القاضي",
  ];

  String selectedLocation = "شارع بيروت بجوار شركة الصادق للصرافة والحوالات";

  // ================== المنتج المخصص ==================
  bool showCustomProductInput = false;

  TextEditingController customProductController = TextEditingController();

  // اضهار اضافه منتج مخصص
  bool showAddNewProduct = false;
  bool customProductSaved = false;
  FocusNode customProductFocus = FocusNode();

  int quantity = 1;

  // bottomNavigationBar
  int footerCurrentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // التاكد هل الصفحه فيها منتجات او لا
    bool hasItems = CartData.cartItems.isNotEmpty;
    double totalPrice = 0;
    for (var item in CartData.cartItems) {
      totalPrice += item["newPrice"] * item["quantity"];
    }
    int cartCount = 0;
    for (var item in CartData.cartItems) {
      cartCount += item["quantity"] as int;
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: color.dark1,
          appBar: p_appbar(
            title: "السلة",
            centerTheTitles: true,
            showAction: false,
            showLeading: false,
          ),

          // عرض الفواتير + الاجمالي
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  theBoxShape(
                    // box
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          // عناوين التوصيل
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // ========= اضاقه موقع جديد=======
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  color: color.p500,
                                  borderRadius: BorderRadius.circular(48),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.add,
                                    color: color.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Row(
                                // عناوين التوصيل
                                children: [
                                  Text(
                                    "عناوين التوصيل",
                                    style:
                                        fonts.mb.copyWith(color: color.white),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: color.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: color.g400,
                          height: 4,
                        ),
                        Container(
                          // عناوين التوصيل
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // ========= تحرير =======
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: color.p500,
                                  borderRadius: BorderRadius.circular(48),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "تحرير",
                                    style:
                                        fonts.sr.copyWith(color: color.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                // =========الاختيار بين المواقع=======
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      value: selectedLocation,
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 170,
                                        decoration: BoxDecoration(
                                          color: color.dark2,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: color.white,
                                          size: 26,
                                        ),
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        height: 60,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 60,
                                      ),
                                      selectedItemBuilder: (context) {
                                        return locations.map((location) {
                                          return Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              location,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: fonts.mr.copyWith(
                                                color: color.white,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: locations.map((location) {
                                        return DropdownMenuItem<String>(
                                          value: location,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              location,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.right,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: fonts.mr.copyWith(
                                                color: color.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedLocation = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: color.g400,
                          height: 4,
                        ),
                        Container(
                          // إضافه منتج مخصص
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customProductSaved
                                  ? Container(
                                      // ================= تعديل =================
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.p500,
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showAddNewProduct = true;
                                            customProductSaved = false;
                                          });
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                              customProductFocus.requestFocus();
                                            },
                                          );
                                        },
                                        child: Text(
                                          customProductController
                                                  .text.isNotEmpty
                                              ? "تعديل"
                                              : "إضافة",
                                          style: fonts.sr.copyWith(
                                            color: color.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : showAddNewProduct
                                      ? Container(
                                          // ================= تاكيد =================
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 2,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showAddNewProduct = false;
                                                customProductSaved = true;
                                              });
                                            },
                                            child: Text(
                                              "تأكيد",
                                              style: fonts.sr.copyWith(
                                                color: color.g400,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: color.g400,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          // ================= اضافه =================
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color.p500,
                                            borderRadius:
                                                BorderRadius.circular(48),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showAddNewProduct = true;
                                              });
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 100),
                                                () {
                                                  customProductFocus
                                                      .requestFocus();
                                                },
                                              );
                                            },
                                            child: Text(
                                              "إضافة",
                                              style: fonts.sr.copyWith(
                                                color: color.white,
                                              ),
                                            ),
                                          ),
                                        ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: showAddNewProduct
                                          ? Container(
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
                                                controller:
                                                    customProductController,
                                                focusNode: customProductFocus,
                                                style: fonts.xsb.copyWith(
                                                  color: color.white,
                                                ),
                                                cursorColor: color.p500,
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                                minLines: 1,
                                                maxLines: 4,
                                                decoration: InputDecoration(
                                                  isCollapsed: true,
                                                  hintText: "اسم المنتج",
                                                  hintStyle: fonts.xsb.copyWith(
                                                    color: color.g400,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                              child: Text(
                                                customProductController
                                                        .text.isNotEmpty
                                                    ? customProductController
                                                        .text
                                                    : "إضافة منتج مخصص",
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                                style: fonts.mr.copyWith(
                                                  color: color.white,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      color: color.white,
                                      size: 24,
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

                  // المنتجات المعروضه بسله
                  Container(
                    margin: hasItems
                        ? EdgeInsets.only(top: 2, bottom: 35)
                        : EdgeInsets.only(top: 2),
                    child: hasItems
                        ? Column(
                            children: CartData.cartItems.map((item) {
                              int quantity = item["quantity"];

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: color.dark2,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  // الصورة
                                  trailing: Container(
                                    width: 63,
                                    height: 63,
                                    decoration: BoxDecoration(
                                      color: color.white,
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        item["images"][0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // حذف
                                  leading: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        CartData.removeFromCart(item["id"]);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: color.p500,
                                    ),
                                  ),

                                  // اسم المنتج
                                  title: Text(
                                    item["title"],
                                    textAlign: TextAlign.right,
                                    style: fonts.ss.copyWith(
                                      color: color.white,
                                    ),
                                  ),

                                  // السعر والكمية
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item["newPrice"]} \$",
                                        style: fonts.mb.copyWith(
                                          color: color.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: color.dark1,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            // ناقص
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (item["quantity"] > 1) {
                                                      item["quantity"]--;
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: color.g200,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            // العدد
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color.p500,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "${item["quantity"]}",
                                                style: fonts.sb.copyWith(
                                                  color: color.g200,
                                                ),
                                              ),
                                            ),
                                            // زائد
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    item["quantity"]++;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: color.g200,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.32,
                                  child: Image.asset(
                                      "assets/images/emptycart.png"),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "السلة فارغة",
                                  style: fonts.xlb.copyWith(
                                    color: color.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "لا يوجد معك اي منتج في السله في الوقت الحالي",
                                  style: fonts.ss.copyWith(
                                    color: color.g400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
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
                  }
                  if (index == 1) {
                    return;
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
                        if (cartCount > 0)
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
                                  "$cartCount",
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
                        if (cartCount > 0)
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
                                  "$cartCount",
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
        ),

        // البانر الخص بي الاجمالي والنقل الى صفحه الفواتير
        if (hasItems)
          Positioned(
            bottom: 63,
            left: 10,
            right: 10,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: color.p500,
                borderRadius: BorderRadius.circular(48),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // السعر
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   "invoice",
                          // );
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24,
                        ),
                        color: color.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "${totalPrice.toStringAsFixed(0)} \$",
                        style: fonts.lb.copyWith(
                          color: color.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  // النص
                  Text(
                    "عرض الفاتورة",
                    style: fonts.lb.copyWith(
                      color: color.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
