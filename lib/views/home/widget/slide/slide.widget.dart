import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
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
        // SizedBox(
        //   height: 5,
        // ),
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width / 4,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 1,
            aspectRatio: 16 / 9,
            scrollPhysics: BouncingScrollPhysics(),
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.extraColor,
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
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
