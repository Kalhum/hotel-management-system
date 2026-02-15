import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // อย่าลืมลงเวอร์ชัน 5.1.1 ใน pubspec.yaml
import 'package:hotel_management_system/BookingFormScreen/booking_form_screen.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/typeRoom_enum.dart';
import 'package:hotel_management_system/core/constants.dart';

class RoomDetailScreen extends StatelessWidget {
  final int roomId;
  final RoomType roomType;
  final List<String> imageUrls;

  const RoomDetailScreen({
    super.key,
    required this.roomId,
    required this.roomType,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topnavbar(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "รายละเอียด ${roomType == RoomType.rooms ? 'ห้องพัก' : 'บ้านพัก'}",
                  style: TextStyle(fontSize: Constants.fontSizeHeader),
                ),
              ),
              // ส่วน Image Slider
              RoomImageSlider(imageUrls: imageUrls),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ห้องหมายเลข $roomId',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Constants.secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            roomType == RoomType.rooms
                                ? 'Standard Room'
                                : 'Private House',
                            style: const TextStyle(
                                color: Constants.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '฿${roomId * 500} / คืน',
                      style: const TextStyle(
                          fontSize: 22,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 40),
                    const Text(
                      'รายละเอียดที่พัก',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'สัมผัสประสบการณ์การพักผ่อนที่เหนือระดับ ด้วยห้องพักที่ตกแต่งอย่างทันสมัย พร้อมสิ่งอำนวยความสะดวกครบครัน อาทิ เครื่องปรับอากาศ Smart TV และฟรี Wi-Fi ความเร็วสูง',
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 30),

                    // ปุ่มจองด้านล่าง
                    Center(
                      child: Button(
                        text: 'จองห้องนี้',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingFormScreen(roomId: roomId) ));
                        },
                        color: Constants.secondaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ส่วนของ Slider ที่แก้ไข Controller แล้ว ---

class RoomImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  const RoomImageSlider({super.key, required this.imageUrls});

  @override
  State<RoomImageSlider> createState() => _RoomImageSliderState();
}

class _RoomImageSliderState extends State<RoomImageSlider> {
  int _current = 0;

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 300.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0, // ให้รูปเต็มหน้าจอในหน้า Detail
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.imageUrls.map((imageUrl) {
            return Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.primaryColor
                      .withOpacity(_current == entry.key ? 0.9 : 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
