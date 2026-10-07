// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hotel_management_system/util/provider/cart_provider.dart';
import '../../../../util/function/login_flow.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entitise/extra_bed_entitise.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../homePage/companents/typeRoom_enum.dart';
import '../provider/room_detail_screen_provider.dart';

// ---------- helpers ----------
String _formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

/// 1234.5 -> ฿1,234.50
String _baht(double v) {
  final parts = v.toStringAsFixed(2).split('.');
  final intPart =
      parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '฿$intPart.${parts[1]}';
}

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

class RoomDetailScreenMobileBody extends StatefulWidget {
  final String roomId;
  final RoomType roomType;

  const RoomDetailScreenMobileBody(
      {super.key, required this.roomId, required this.roomType});

  @override
  State<RoomDetailScreenMobileBody> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreenMobileBody> {
  Future<void> _pickDateRange(RoomDetailScreenProvider provider) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: provider.dateRange,
      helpText: 'เลือกวันเช็คอิน - เช็คเอาท์',
      saveText: 'ตกลง',
    );

    if (picked != null) provider.setDateRange(picked);
  }

  Future<void> _onAddToCartTap(RoomDetailScreenProvider provider) async {
    final selection = provider.buildSelection();

    if (selection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกวันเช็คอิน - เช็คเอาท์')),
      );
      return;
    }

    final canContinue = await ensureLoggedIn(
      context,
      redirectRoute: '/cart',
      cartItemToAdd: selection,
    );
    if (!canContinue) return;

    try {
      await context.read<CartProvider>().addItem(selection);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเพิ่มลงตะกร้าได้')),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('เพิ่มลงตะกร้าแล้ว'),
        action: SnackBarAction(
          label: 'ดูตะกร้า',
          onPressed: () => Navigator.pushNamed(context, "/cart"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Topnavbar(widthFactor: 0.2),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "รายละเอียด ${room.roomType == RoomType.rooms ? 'ห้องพัก' : 'บ้านพัก'}",
                      style: TextStyle(fontSize: Constants.fontSizeHeader),
                    ),
                  ),
                  RoomImageSlider(imageUrls: room.imageUrls),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.name.isNotEmpty
                                        ? room.name
                                        : (room.roomType == RoomType.rooms
                                            ? 'ห้องพัก'
                                            : 'บ้านพัก'),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ห้องหมายเลข ${room.roomId}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    Constants.secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
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
                        const SizedBox(height: 10),
                        Text(
                          '${_baht(room.pricePerNight)} / คืน',
                          style: const TextStyle(
                              fontSize: 22,
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold),
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
                              label: 'พักได้สูงสุด ${room.capacity} คน',
                            ),
                          ],
                        ),
                        const Divider(height: 40),
                        const _SectionTitle('รายละเอียดที่พัก'),
                        const SizedBox(height: 10),
                        Text(
                          room.description,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey, height: 1.5),
                        ),

                        // ---------- วันที่เข้าพัก ----------
                        const Divider(height: 40),
                        const _SectionTitle('วันที่เข้าพัก'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _DateBox(
                                label: 'เช็คอิน',
                                date: provider.checkIn,
                                onTap: () => _pickDateRange(provider),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DateBox(
                                label: 'เช็คเอาท์',
                                date: provider.checkOut,
                                onTap: () => _pickDateRange(provider),
                              ),
                            ),
                          ],
                        ),
                        if (provider.nights > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'พัก ${provider.nights} คืน',
                              style: const TextStyle(
                                  color: Constants.secondaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                        // ---------- จำนวนผู้เข้าพัก ----------
                        const Divider(height: 40),
                        const _SectionTitle('จำนวนผู้เข้าพัก'),
                        const SizedBox(height: 4),
                        _CounterRow(
                          title: 'ผู้ใหญ่',
                          value: provider.adultCount,
                          min: 1,
                          max: RoomDetailScreenProvider.maxAdults,
                          onDecrement: provider.decrementAdult,
                          onIncrement: provider.incrementAdult,
                        ),
                        _CounterRow(
                          title: 'เด็ก',
                          value: provider.childCount,
                          min: 0,
                          max: RoomDetailScreenProvider.maxChildren,
                          onDecrement: provider.decrementChild,
                          onIncrement: provider.incrementChild,
                        ),

                        // ---------- เตียงเสริม (แสดงเมื่อมีเด็ก) ----------
                        if (provider.childCount > 0 &&
                            provider.extraBedTypes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'ต้องการเตียงเสริมสำหรับเด็ก',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            value: provider.wantExtraBed,
                            activeColor: Constants.secondaryColor,
                            onChanged: provider.toggleExtraBed,
                          ),
                          if (provider.wantExtraBed) ...[
                            const SizedBox(height: 4),
                            ...provider.extraBedTypes.map(
                              (type) => _ExtraBedOption(
                                type: type,
                                selected: provider.selectedExtraBedType?.id ==
                                    type.id,
                                onTap: () => provider.selectExtraBedType(type),
                              ),
                            ),
                            _CounterRow(
                              title: 'จำนวนเตียงเสริม',
                              subtitle:
                                  'ไม่เกินจำนวนเด็ก (${provider.childCount})',
                              value: provider.extraBedQuantity,
                              min: 1,
                              max: provider.childCount,
                              onDecrement: provider.decrementExtraBed,
                              onIncrement: provider.incrementExtraBed,
                            ),
                          ],
                        ],

                        // ---------- สรุปราคา ----------
                        if (provider.nights > 0) ...[
                          const Divider(height: 40),
                          const _SectionTitle('สรุปราคา'),
                          const SizedBox(height: 12),
                          _PriceSummary(
                              provider: provider,
                              pricePerNight: room.pricePerNight),
                        ],

                        const SizedBox(height: 30),
                        Center(
                          child: Button(
                            text: 'เพิ่มลงตะกร้า',
                            onTap: () => _onAddToCartTap(provider),
                            color: Constants.secondaryColor,
                          ),
                        ),
                        if (!provider.canProceed)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Center(
                              child: Text(
                                'เลือกวันเช็คอิน - เช็คเอาท์ก่อนทำการจอง',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
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

// ---------- small widgets ----------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _DateBox extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateBox({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: Constants.secondaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date == null ? 'เลือกวันที่' : _formatDate(date!),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: date == null ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int value;
  final int min;
  final int max;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: Constants.secondaryColor,
            onPressed: value > min ? onDecrement : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Constants.secondaryColor,
            onPressed: value < max ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}

class _ExtraBedOption extends StatelessWidget {
  final ExtraBedTypeEntitise type;
  final bool selected;
  final VoidCallback onTap;

  const _ExtraBedOption({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? Constants.secondaryColor.withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(
            color: selected ? Constants.secondaryColor : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? Constants.secondaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  if (type.description.isNotEmpty)
                    Text(type.description,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('สำหรับเด็กอายุไม่เกิน ${type.maxChildAge} ปี',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('${_baht(type.price)} / คืน',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor)),
          ],
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final RoomDetailScreenProvider provider;
  final double pricePerNight;

  const _PriceSummary({required this.provider, required this.pricePerNight});

  @override
  Widget build(BuildContext context) {
    final nights = provider.nights;
    final bed = provider.selectedExtraBedType;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: 'ห้องพัก ${_baht(pricePerNight)} × $nights คืน',
            value: _baht(provider.roomPrice),
          ),
          if (provider.hasExtraBed && bed != null) ...[
            const SizedBox(height: 8),
            _PriceRow(
              label:
                  '${bed.name} ${_baht(bed.price)} × ${provider.extraBedQuantity} ชิ้น × $nights คืน',
              value: _baht(provider.extraBedPrice),
            ),
          ],
          const Divider(height: 24),
          _PriceRow(
            label: 'รวมทั้งหมด',
            value: _baht(provider.totalPrice),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: bold ? Constants.primaryColor : Colors.black87,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: style)),
        const SizedBox(width: 8),
        Text(value, style: style),
      ],
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
    if (widget.imageUrls.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child:
            const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
      );
    }
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 300.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.imageUrls.map((imageUrl) {
            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image,
                      size: 40, color: Colors.grey),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
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
