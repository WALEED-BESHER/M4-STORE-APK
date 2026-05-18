import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class Bannered extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback action;
  final bool showBanner;
  
  const Bannered({
    super.key,
    required this.title,
    required this.image,
    required this.action,
    required this.showBanner,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBanner) {
      return const SizedBox();
    }
    return InkWell(
      onTap: action,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            color: color.dark2,
            borderRadius: BorderRadius.circular(48)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/${image}",
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: fonts.lb.copyWith(color: color.g100),
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}