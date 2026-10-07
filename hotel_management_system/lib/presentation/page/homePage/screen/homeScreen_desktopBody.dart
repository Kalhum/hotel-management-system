// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../companents/typeRoom_enum.dart';
import '../provider/home_screen_provider.dart';

class HomeScreenDesktopBody extends StatefulWidget {
  final HomeFilterArgs? filterArgs;

  const HomeScreenDesktopBody({super.key, this.filterArgs});

  @override
  State<HomeScreenDesktopBody> createState() => _HomeScreenDesktopBodyState();
}

class _HomeScreenDesktopBodyState extends State<HomeScreenDesktopBody> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;

      final provider = context.read<HomeScreenProvider>();

      if (widget.filterArgs != null) {
        // มีวันที่ส่งมาจาก Promotion page -> กรองห้องตามวันที่เลย
        provider.setDateRange(
          widget.filterArgs!.checkIn,
          widget.filterArgs!.checkOut,
        );
      }
    });
  }

  Widget _buildTabButton(BuildContext context, String label, RoomType type) {
    final provider = context.watch<HomeScreenProvider>();
    bool isSelected = provider.selectedRoomType == type;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Constants.primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () => context.read<HomeScreenProvider>().selectRoomType(type),
      child: Text(label),
    );
  }

  Widget _buildFilterChipsSection(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();
    final names = provider.availableNames;

    String priceLabel;
    IconData priceIcon;
    Color priceColor = Colors.grey.shade700;
    Color priceBgColor = Colors.grey.shade100;

    switch (provider.priceSortOrder) {
      case PriceSortOrder.lowToHigh:
        priceLabel = "ราคา: ต่ำ-สูง";
        priceIcon = Icons.arrow_upward;
        priceColor = Constants.primaryColor;
        priceBgColor = Constants.primaryColor.withOpacity(0.12);
        break;
      case PriceSortOrder.highToLow:
        priceLabel = "ราคา: สูง-ต่ำ";
        priceIcon = Icons.arrow_downward;
        priceColor = Constants.primaryColor;
        priceBgColor = Constants.primaryColor.withOpacity(0.12);
        break;
      case PriceSortOrder.none:
        priceLabel = "ราคา";
        priceIcon = Icons.swap_vert;
        break;
    }

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // ปุ่มกรอง/เรียงลำดับราคา
          InkWell(
            onTap: () => context.read<HomeScreenProvider>().togglePriceSort(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: priceBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: provider.priceSortOrder != PriceSortOrder.none
                      ? Constants.primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(priceIcon, size: 16, color: priceColor),
                  const SizedBox(width: 4),
                  Text(
                    priceLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: provider.priceSortOrder != PriceSortOrder.none
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: priceColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // รายการ Filter Chips ตามชื่อประเภทห้อง
          ...names.map((name) {
            final isSelected = provider.selectedNameFilter == name;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(name),
                selected: isSelected,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                backgroundColor: Colors.grey.shade100,
                selectedColor: Constants.primaryColor,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Constants.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                onSelected: (_) =>
                    context.read<HomeScreenProvider>().selectNameFilter(name),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final provider = context.read<HomeScreenProvider>();
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange:
          provider.checkInDate != null && provider.checkOutDate != null
              ? DateTimeRange(
                  start: provider.checkInDate!, end: provider.checkOutDate!)
              : null,
    );

    if (picked != null) {
      provider.setDateRange(picked.start, picked.end);
    }
  }

  Widget _buildDateFilterChip(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();
    final hasDateFilter =
        provider.checkInDate != null && provider.checkOutDate != null;

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickDateRange(context),
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(
            hasDateFilter
                ? "${provider.checkInDate!.day}/${provider.checkInDate!.month} - ${provider.checkOutDate!.day}/${provider.checkOutDate!.month}"
                : "เลือกวันที่เข้าพัก",
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.primaryColor,
            side: BorderSide(color: Constants.primaryColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        if (hasDateFilter) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () =>
                context.read<HomeScreenProvider>().clearDateFilter(),
            tooltip: "ล้างตัวกรองวันที่",
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Topnavbar(
                  widthFactor: 0.1,
                )),
            Positioned(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 83),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateFilterChip(context), // เพิ่มตัวกรองวันที่
                        Row(
                          children: [
                            SizedBox(
                                width: screenWidth * 0.3,
                                child: createInputField(InputFieldType.search)),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Constants.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.search,
                                    color: Constants.white, size: 35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabButton(context, "ห้องพัก", RoomType.rooms),
                        const SizedBox(width: 10),
                        _buildTabButton(context, "บ้านพัก", RoomType.house),
                      ],
                    ),
                    Consumer<HomeScreenProvider>(
                      builder: (context, provider, child) {
                        if (!provider.hasDateFilter ||
                            provider.roomData.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _buildFilterChipsSection(context),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Consumer<HomeScreenProvider>(
                      builder: (context, provider, child) {
                        return Expanded(
                          child: provider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : provider.errorMessage.isNotEmpty
                                  ? Center(child: Text(provider.errorMessage))
                                  : provider.filteredRoomData.isEmpty
                                      ? const Center(
                                          child: Text(
                                              "ไม่พบห้องพักที่ตรงกับตัวกรอง"))
                                      : createBoxShowData(
                                          provider.selectedRoomType,
                                          provider.filteredRoomData,
                                          len: provider.len,
                                          crossAxisCount: 4,
                                          onRoomTap: (room) async {
                                            final available = await provider
                                                .refreshAndCheckRoom(
                                                    room.roomId);
                                            if (!context.mounted) return;
                                            if (available != true) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(available ==
                                                          false
                                                      ? 'ห้องนี้ถูกจองไปแล้ว กรุณาเลือกห้องอื่น'
                                                      : 'ตรวจสอบห้องไม่สำเร็จ กรุณาลองอีกครั้ง'),
                                                ),
                                              );
                                              return;
                                            }
                                            Navigator.pushNamed(
                                              context,
                                              '/room_detail',
                                              arguments: RoomDetailArguments(
                                                roomId: room.roomId,
                                                roomType: room.roomType,
                                                checkIn: provider.checkInDate,
                                                checkOut: provider.checkOutDate,
                                              ),
                                            );
                                          },
                                        ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Bottomnavbar(isVisibleHousekeeper: false)),
          ],
        ),
      ),
    );
  }
}
