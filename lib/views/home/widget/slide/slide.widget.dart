import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:products_app/constants/api.dart';
import 'package:products_app/constants/app_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Slide extends StatefulWidget {
  const Slide({super.key});

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            autoPlay: true, // Bật chế độ tự động trượt
            autoPlayInterval: Duration(seconds: 3), // Thời gian mỗi lần trượt
            enlargeCenterPage: true,
            viewportFraction: 1,
            aspectRatio: 16 / 9,
            scrollPhysics: BouncingScrollPhysics(), // Hiệu ứng cuộn giống iOS
            pauseAutoPlayOnTouch: true,
            pauseAutoPlayOnManualNavigate: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            padEnds: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: API.HOST_SLIDE.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: AppColor.extraColor,
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
        AnimatedSmoothIndicator(
          activeIndex: currentIndex,
          count: API.HOST_SLIDE.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.blue,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 2,
            dotColor: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
