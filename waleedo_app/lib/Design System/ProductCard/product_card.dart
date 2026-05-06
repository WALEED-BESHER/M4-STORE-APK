import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../productdetails.dart';
enum ProductCardType {
  full,
  hideDiscount,
  hideBoth,
  hideOldPrice,
}

class ProductCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final int newPrice;
  final int? oldPrice;
  final ProductCardType type;
  
  // final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.newPrice,
    this.oldPrice,
    this.type = ProductCardType.full,
    
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool inCart = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    bool showDiscount =
    widget.type == ProductCardType.full ||
    widget.type == ProductCardType.hideOldPrice;

bool showOldPrice =
    widget.type == ProductCardType.full ||
    widget.type == ProductCardType.hideDiscount;

int? discount;

if (widget.oldPrice != null && showDiscount) {
  discount =
      (((widget.oldPrice! - widget.newPrice) / widget.oldPrice!) * 100)
          .toInt();
}
    return GestureDetector(
      onTap: () {
        // الانتقال لصفحة التفاصيل
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Productdetails(
              productId: widget.id,
            ),
          ),
        );
        // print(widget.id);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color.dark2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =====  الخصم + الصورة =====
            SizedBox(
              width: double.infinity,
              height: 135,
              child: Stack(
                children: [
                  // ===== الصورة =====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.image,
                      width: double.infinity,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ===== الخصم =====
                  (widget.oldPrice != null && showDiscount ) ?
                  Positioned(
                    top: 0,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.p600,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "${discount} %",
                        style: fonts.sb.copyWith(color: color.g200),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) : Positioned(child: Text("")),
                ],
              ),
            ),

            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ===== العنوان =====
                  SizedBox(
                    height: 35, // مساحة ثابتة لسطرين
                    child: Text(
                      widget.title,
                      style: fonts.sb.copyWith(color: color.g200),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ===== السعر =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (widget.oldPrice != null && showOldPrice) ?
                      Text(
                        "\$" + widget.oldPrice.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: fonts.sb.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: color.tRed,
                          decorationThickness: 3,
                          color: color.tRed,
                        ),
                      ) : Text(""),
                      const SizedBox(width: 12),
                      Text(
                        "\$ " + widget.newPrice.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: fonts.mb.copyWith(color: color.g200),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  // ===== الزر + القلب =====
                  Row(
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
                          color: isFavorite ? color.p500 : color.g200,
                          size: 20,
                        ),
                      ),

                      SizedBox(width: 6),

                      // 🔥 هنا التغيير المهم
                      Expanded(
                        child: inCart
                            ? Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color.dark1, // الخلفية الداكنة
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    // ➖ ناقص
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 1) {
                                              quantity--;
                                            } else {
                                              // يرجع زر السلة
                                              inCart = false;
                                              quantity = 0;
                                            }
                                          });
                                        },
                                        icon: Icon(Icons.remove,
                                            color: color.g200, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                    ),

                                    // 🔢 العدد
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: color.p500,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "$quantity",
                                        style: fonts.sb
                                            .copyWith(color: color.g200),
                                      ),
                                    ),

                                    // ➕ زائد
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        icon: Icon(Icons.add,
                                            color: color.g200, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 32,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      inCart = true;
                                      quantity = 1;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color.p500,
                                    foregroundColor: color.g200,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'إضافة للسلة',
                                    style: fonts.sb,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
    );
  }
}
