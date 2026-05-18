import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/colors.dart';

class HomeSlider extends StatefulWidget {

  final List<String> sliderImages;

  const HomeSlider({
    super.key,
    required this.sliderImages,
  });

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState
    extends State<HomeSlider> {

  int sliderCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        // ===== السلايدر =====
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval:const Duration(seconds: 1),
            autoPlayAnimationDuration:const Duration(milliseconds: 400),
            height: 170,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                sliderCurrentIndex = index;
              });
            },
          ),
          items:widget.sliderImages.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6,),
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.dark2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 5),
        // ===== النقاط =====
        AnimatedSmoothIndicator(
          activeIndex: sliderCurrentIndex,
          count: widget.sliderImages.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 5,
            dotColor: color.p50,
            activeDotColor: color.p500,
            paintStyle: PaintingStyle.fill,
          ),
        ),
      ],
    );
  }
}