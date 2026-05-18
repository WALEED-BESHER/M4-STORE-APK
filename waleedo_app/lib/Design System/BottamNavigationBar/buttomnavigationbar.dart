import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final double cartSize;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.cartSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.dark2,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
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
          currentIndex: currentIndex,
          backgroundColor: color.dark2,
          selectedItemColor: color.p400,
          unselectedItemColor: color.g400,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,

          onTap: (index) {
            if (index == currentIndex) return;

            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, "account");
                break;

              case 1:
                Navigator.pushReplacementNamed(context, "cart");
                break;

              case 2:
                Navigator.pushReplacementNamed(context, "orders");
                break;

              case 3:
                Navigator.pushReplacementNamed(context, "/");
                break;
            }
          },

          items: [
            const BottomNavigationBarItem(
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

            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: "طلباتي",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "الرئيسية",
            ),
          ],
        ),
      ),
    );
  }
}