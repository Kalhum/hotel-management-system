// RoomConditionCheckPage_desktopBody.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/provider/room_condition_check_screen_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/function/image_url.dart';

class RoomConditionCheckScreenDesktopBody extends StatefulWidget {
  final String roomId;
  final String bookingId;
  const RoomConditionCheckScreenDesktopBody({
    super.key,
    required this.roomId,
    required this.bookingId,
  });

  @override
  State<RoomConditionCheckScreenDesktopBody> createState() =>
      _RoomConditionCheckScreenDesktopBodyState();
}

class _RoomConditionCheckScreenDesktopBodyState
    extends State<RoomConditionCheckScreenDesktopBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RoomConditionCheckScreenProvider>()
          .init(widget.roomId, widget.bookingId);
    });
  }

  // ... โค้ดส่วนอื่นเหมือนเดิมทั้งหมด ไม่ต้องแก้

  Widget _buildTimerBadge(int seconds) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200)),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.red, size: 22),
          const SizedBox(width: 8),
          Text(
            context
                .read<RoomConditionCheckScreenProvider>()
                .formatTime(seconds),
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(FurnitureItem item) {
    final imageUrl = ImageUrlHelper.toFullImageUrl(item.inspectionImageUrl) ??
        ImageUrlHelper.toFullImageUrl(
            item.image is String ? item.image as String : null);
    if (imageUrl != null) {
      return Image.network(imageUrl,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
    }
    return Container(
        width: 70,
        height: 70,
        color: Colors.orange.shade100,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.orange));
  }

  Widget _buildStatusPicker(int index, FurnitureItem item) {
    return Row(
      children: ["ปกติ", "ชำรุด"].map((s) {
        bool active = item.status == s;
        return GestureDetector(
          onTap: () => context
              .read<RoomConditionCheckScreenProvider>()
              .updateStatus(index, s),
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
                color: active
                    ? (s == "ปกติ" ? Colors.green : Colors.red)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(25)),
            child: Text(s,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.white : Colors.grey[600])),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDamageDetailBox(int index, FurnitureItem item) {
    final provider = context.read<RoomConditionCheckScreenProvider>();
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.red.shade50.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("รายละเอียดความเสียหาย",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (val) => provider.updateNote(index, val),
            decoration: InputDecoration(
                hintText: "กรอกหมายเหตุที่นี่...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => provider.pickDamageImage(index),
            child: item.damageImage == null
                ? Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400)),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_enhance,
                              size: 30, color: Colors.grey),
                          Text("กดเพื่อถ่ายรูปความเสียหาย",
                              style: TextStyle(color: Colors.grey))
                        ]),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(children: [
                      Image.file(item.damageImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover),
                      Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () =>
                                      provider.pickDamageImage(index)))),
                    ]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFurnitureRow(int index, FurnitureItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildItemImage(item)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  _buildStatusPicker(index, item),
                ],
              ),
              if (item.status == "ชำรุด") _buildDamageDetailBox(index, item),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  void _showAddExtraDamageSheet() {
    String extraTitle = "";
    File? tempImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Handle bar ---
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // --- Header ---
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.warning_amber_rounded,
                        color: Colors.orange.shade700, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("แจ้งของชำรุดเพิ่มเติม",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("ระบุรายการที่ไม่มีในรายการตรวจเช็ค",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Input ชื่อสิ่งของ ---
              TextField(
                autofocus: true,
                onChanged: (v) => extraTitle = v,
                decoration: InputDecoration(
                  labelText: "ชื่อสิ่งของที่ชำรุด",
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Constants.primaryColor, width: 2)),
                ),
              ),
              const SizedBox(height: 16),

              // --- ถ่ายรูป ---
              Text("รูปภาพความเสียหาย",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700])),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  if (image != null) {
                    setModalState(() => tempImage = File(image.path));
                  }
                },
                child: tempImage == null
                    ? Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.5)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_enhance_outlined,
                                  size: 36, color: Colors.grey[400]),
                              const SizedBox(height: 6),
                              Text("กดเพื่อถ่ายรูปความเสียหาย",
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 13)),
                            ]),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(children: [
                          Image.file(tempImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover),
                          const Positioned(
                              right: 10,
                              top: 10,
                              child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 18))),
                        ]),
                      ),
              ),
              const SizedBox(height: 24),

              // --- ปุ่ม ---
              Button(
                text: "ยืนยันการเพิ่มรายการ",
                color: Constants.primaryColor,
                onTap: () {
                  if (extraTitle.isNotEmpty) {
                    context
                        .read<RoomConditionCheckScreenProvider>()
                        .addExtraFurniture(
                          title: extraTitle,
                          damageImage: tempImage,
                        );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("กรุณาระบุชื่อสิ่งของ")));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog({String msg = "บันทึกข้อมูลสำเร็จ"}) async {
    await context
        .read<RoomConditionCheckScreenProvider>()
        .submitCheckCondition(widget.roomId);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green));
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/list_page',
      (route) => false,
      // arguments: ListScreenArguments(
      //   checkInStatus: true,
      //   statusConCheck: true,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            const Topnavbar(
              widthFactor: 0.1,
            ),
            Expanded(
              child: Consumer<RoomConditionCheckScreenProvider>(
                builder: (context, provider, _) {
                  if (provider.isTimeUp) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showSuccessDialog(
                          msg: "หมดเวลาตรวจเช็ค ระบบยืนยันอัตโนมัติ");
                    });
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Header ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ตรวจเช็คเฟอร์นิเจอร์",
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[900])),
                                    const SizedBox(height: 4),
                                    Text("กรุณาตรวจสอบสภาพเฟอร์นิเจอร์ทุกชิ้น",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500])),
                                  ],
                                ),
                                _buildTimerBadge(provider.remainingSeconds),
                              ],
                            ),
                            const SizedBox(height: 28),

                            // --- 2 คอลัมน์ ---
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Left: รายการเฟอร์นิเจอร์ ---
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 20,
                                            offset: const Offset(0, 4))
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Card header
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 28, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Constants.primaryColor
                                                .withOpacity(0.05),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(20)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.chair_outlined,
                                                  color: Constants.primaryColor,
                                                  size: 22),
                                              const SizedBox(width: 10),
                                              const Text("รายการเฟอร์นิเจอร์ทั้งหมด",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Constants
                                                          .primaryColor)),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Constants.primaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "${provider.furnitureList.length} รายการ",
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Constants
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // รายการ
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 28),
                                          child: Column(
                                            children: provider.furnitureList
                                                .asMap()
                                                .entries
                                                .map((entry) =>
                                                    _buildFurnitureRow(
                                                        entry.key, entry.value))
                                                .toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 24),

                                // --- Right: action panel ---
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      // สรุปสถานะ
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 20,
                                                offset: const Offset(0, 4))
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("สรุปสถานะ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[900])),
                                            const SizedBox(height: 16),
                                            _buildSummaryRow(
                                              icon: Icons.check_circle_outline,
                                              label: "ปกติ",
                                              count: provider.furnitureList
                                                  .where(
                                                      (f) => f.status == "ปกติ")
                                                  .length,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(height: 10),
                                            _buildSummaryRow(
                                              icon:
                                                  Icons.warning_amber_outlined,
                                              label: "ชำรุด",
                                              count: provider.furnitureList
                                                  .where((f) =>
                                                      f.status == "ชำรุด")
                                                  .length,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(height: 10),
                                            _buildSummaryRow(
                                              icon: Icons.help_outline,
                                              label: "ยังไม่ตรวจ",
                                              count: provider.furnitureList
                                                  .where((f) =>
                                                      f.status.isEmpty ||
                                                      f.status == "")
                                                  .length,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // ปุ่ม action
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 20,
                                                offset: const Offset(0, 4))
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text("การดำเนินการ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[900])),
                                            const SizedBox(height: 16),
                                            Button(
                                                text: "บันทึกข้อมูลการตรวจเช็ค",
                                                onTap: () =>
                                                    _showSuccessDialog(),
                                                color: Constants.primaryColor),
                                            const SizedBox(height: 10),
                                            OutlinedButton.icon(
                                              onPressed: () =>
                                                  _showAddExtraDamageSheet(),
                                              icon: const Icon(Icons.add),
                                              label: const Text(
                                                  "แจ้งของชำรุดเพิ่มเติม"),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    Colors.orange.shade700,
                                                side: BorderSide(
                                                    color:
                                                        Colors.orange.shade700),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Constants
                                                                .borderRadius)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Bottomnavbar(isVisibleHousekeeper: false),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("$count",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }
}
