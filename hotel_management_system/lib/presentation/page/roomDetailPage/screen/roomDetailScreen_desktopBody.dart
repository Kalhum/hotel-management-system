// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../../../util/provider/cart_provider.dart';
import '../../../../util/function/login_flow.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../homePage/companents/typeRoom_enum.dart';
import '../provider/room_detail_screen_provider.dart';

Widget _buildInfoChip({required IconData icon, required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Constants.secondaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class RoomDetailScreenDesktopBody extends StatefulWidget {
  final String roomId;
  final RoomType roomType;

  const RoomDetailScreenDesktopBody(
      {super.key, required this.roomId, required this.roomType});

  @override
  State<RoomDetailScreenDesktopBody> createState() =>
      _RoomDetailScreenDesktopState();
}

class _RoomDetailScreenDesktopState extends State<RoomDetailScreenDesktopBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RoomDetailScreenProvider>()
          .getRoomDetail(widget.roomId, widget.roomType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Consumer<RoomDetailScreenProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }
            final room = provider.roomDetail;
            if (room == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Topnavbar(
                    widthFactor: 0.1,
                  ),

                  // --- Slider เต็มความกว้าง ---
                  RoomImageSlider(imageUrls: room.imageUrls),

                  // --- Content area ---
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Left: ข้อมูลหลัก ---
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        room.name.isNotEmpty
                                            ? room.name
                                            : (room.roomType == RoomType.rooms
                                                ? 'ห้องพัก'
                                                : 'บ้านพัก'),
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Constants.secondaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          room.roomType == RoomType.rooms
                                              ? 'ห้องพัก'
                                              : 'บ้านพัก',
                                          style: const TextStyle(
                                              color: Constants.secondaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ห้องหมายเลข ${room.roomId}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (room.building.isNotEmpty &&
                                          room.building != '0')
                                        _buildInfoChip(
                                          icon: Icons.apartment_outlined,
                                          label: 'ตึก ${room.building}',
                                        ),
                                      _buildInfoChip(
                                        icon: Icons.king_bed_outlined,
                                        label: room.bedType.isNotEmpty
                                            ? room.bedType
                                            : 'เตียงเดี่ยว',
                                      ),
                                      _buildInfoChip(
                                        icon: Icons.people_outline,
                                        label:
                                            'พักได้สูงสุด ${room.capacity} คน',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'รายละเอียดที่พัก',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    room.description,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        height: 1.8),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 32),

                            // --- Right: ราคา + ปุ่มจอง ---
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('ราคาต่อคืน',
                                        style: TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '฿${room.pricePerNight.toDouble()}',
                                      style: const TextStyle(
                                          fontSize: 32,
                                          color: Constants.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Button(
                                        text: 'เพิ่มลงตะกร้า',
                                        onTap: () async {
                                          final selection = context
                                              .read<RoomDetailScreenProvider>()
                                              .buildSelection();
                                          if (selection == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'กรุณาเลือกวันเช็คอิน - เช็คเอาท์')),
                                            );
                                            return;
                                          }

                                          final canContinue =
                                              await ensureLoggedIn(
                                            context,
                                            redirectRoute: '/cart',
                                            cartItemToAdd: selection,
                                          );
                                          if (!canContinue) return;

                                          try {
                                            await context
                                                .read<CartProvider>()
                                                .addItem(selection);
                                          } catch (error) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'ไม่สามารถเพิ่มลงตะกร้าได้')),
                                            );
                                            return;
                                          }
                                          if (!context.mounted) return;
                                          Navigator.pushNamed(context, "/cart");
                                        },
                                        color: Constants.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- RoomImageSlider ---
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // --- Slider ---
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: screenWidth * 0.35,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
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

        // --- Dot indicators ทับบนรูป ---
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _current == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white
                        .withOpacity(_current == entry.key ? 1.0 : 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
