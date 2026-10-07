import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../util/widget/core/constants.dart';

class PromotionImage {
  final int id;
  final String imageUrl;

  PromotionImage({
    required this.id,
    required this.imageUrl,
  });
}

class BoxshowNew extends StatefulWidget {
  final List<PromotionImage> images;
  final Function(int id)? onTap;

  const BoxshowNew({
    super.key,
    required this.images,
    this.onTap,
  });

  @override
  State<BoxshowNew> createState() => _BoxshowNewState();
}

class _BoxshowNewState extends State<BoxshowNew> {
  int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width < 700 ? 170 : 270,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.images.map((image) {
            return GestureDetector(
              onTap: () {
                widget.onTap?.call(image.id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Constants.borderRadius,
                ),
                child: Image.network(
                  image.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                _controller.animateToPage(entry.key);
              },
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryColor.withOpacity(
                    _current == entry.key ? 1 : 0.3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
