import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class CartBanner extends StatelessWidget {

  final bool inCart;

  final double totalPrice;

  const CartBanner({
    super.key,
    required this.inCart,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {

    // اذا السله فاضيه لا تعرض شيء
    if (!inCart) {
      return const SizedBox();
    }

    return Positioned(
      bottom: 2,
      left: 10,
      right: 10,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, "cart",);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: color.p500,
            borderRadius:BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_new,
                    color: color.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${totalPrice.toStringAsFixed(0)} \$",
                    style: fonts.lb.copyWith(
                      color: color.white,
                      decoration:TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Text(
                "عرض السلة",
                style: fonts.lb.copyWith(
                  color: color.white,
                  decoration:TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}