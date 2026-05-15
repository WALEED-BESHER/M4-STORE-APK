import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'cart_data.dart';

class editCart extends StatefulWidget {
  const editCart({super.key});

  @override
  State<editCart> createState() => _editCartState();
}

class _editCartState extends State<editCart> {
  @override
  Widget build(BuildContext context) {
    bool hasItems = CartData.cartItems.isNotEmpty;
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "تعديل السله",
        centerTheTitles: true,
        showLeading: false,
        showAction: false,
      ),

      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              Container(
                margin: hasItems
                ? EdgeInsets.only(top: 2, bottom: 35)
                : EdgeInsets.only(top: 2),
                child: hasItems
                ?Column(
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
                :Container(
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

      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
        color: color.dark2,
        child: Row(
          children: [
            Expanded(
              child: p_button(
                title: "تعديل السله", 
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "checkout");
                },
                fontType: fonts.mb,
              ),
            ),
          ],
        ),
      ),

    );
  }
}