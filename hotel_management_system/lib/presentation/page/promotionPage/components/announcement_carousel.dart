import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entitise/announcement_entitise.dart';
import '../../../../util/widget/core/constants.dart';

class AnnouncementCarousel extends StatefulWidget {
  final List<AnnouncementEntitise> announcements;
  final ValueChanged<AnnouncementEntitise>? onTap;

  const AnnouncementCarousel({
    super.key,
    required this.announcements,
    this.onTap,
  });

  @override
  State<AnnouncementCarousel> createState() => _AnnouncementCarouselState();
}

class _AnnouncementCarouselState extends State<AnnouncementCarousel> {
  int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();

  int get _safeIndex => _current < widget.announcements.length ? _current : 0;

  @override
  Widget build(BuildContext context) {
    if (widget.announcements.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width < 700 ? 190 : 270,
            autoPlay: widget.announcements.length > 1,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
          items: widget.announcements.map((announcement) {
            return GestureDetector(
              onTap: () => widget.onTap?.call(announcement),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                child: Image.network(
                  announcement.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(
                    color: Color(0xFFF2F2F2),
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => widget.onTap?.call(widget.announcements[_safeIndex]),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Text(
              widget.announcements[_safeIndex].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ),
        if (widget.announcements.length > 1) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.announcements.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.primaryColor
                        .withOpacity(_current == entry.key ? 1 : 0.3),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
