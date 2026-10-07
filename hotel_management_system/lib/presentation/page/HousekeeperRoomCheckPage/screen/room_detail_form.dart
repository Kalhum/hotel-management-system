import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/components/button/button.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/core/constants.dart';
import '../provider/HousekeeperRoomCheck_Screen_provider.dart';

class RoomDetailFormScreen extends StatefulWidget {
  final String roomNo;

  const RoomDetailFormScreen({
    super.key,
    required this.roomNo,
  });

  @override
  State<RoomDetailFormScreen> createState() => _RoomDetailFormScreenState();
}

class _RoomDetailFormScreenState extends State<RoomDetailFormScreen> {
  String _cleaningStatus = "กำลังทำความสะอาด";
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<HousekeeperRoomCheckScreenProvider>()
          .getRoomFurniture(widget.roomNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.inputFieldFillColor,
      appBar: AppBar(
        title: Text(
          "ห้อง ${widget.roomNo}",
          style: const TextStyle(
            fontSize: Constants.fontSizeTitle,
            fontWeight: Constants.fontWeightBold,
          ),
        ),
        backgroundColor: Constants.white,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Constants.inputFieldBorderColor,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // สถานะการทำความสะอาด
            // ============================================================
            _sectionCard(
              icon: Icons.cleaning_services_rounded,
              title: "สถานะการทำความสะอาด",
              child: _buildDropdown(),
            ),

            const SizedBox(height: 16),

            // ============================================================
            // ตรวจสอบความเรียบร้อย
            // ============================================================
            _sectionCard(
              icon: Icons.camera_alt_rounded,
              title: "ตรวจสอบความเรียบร้อย",
              child: Consumer<HousekeeperRoomCheckScreenProvider>(
                builder: (context, provider, _) {
                  if (provider.isFurnitureLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.roomFurniture.isEmpty) {
                    return const Text(
                      'ไม่พบรายการของในห้องนี้',
                    );
                  }

                  return Column(
                    children:
                        provider.roomFurniture.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      final isLast = index == provider.roomFurniture.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : 12,
                        ),
                        child: _furnitureCard(
                          context,
                          provider,
                          index,
                          item,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ============================================================
            // เพิ่มของนอกรายการ
            // ============================================================
            OutlinedButton.icon(
              onPressed: () => _showAddExtraFurniture(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("เพิ่มของนอกรายการ"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.primaryColor,
                minimumSize: const Size(double.infinity, 44),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // บันทึกข้อมูลทั้งหมด
            // ============================================================
            Button(
              text: _isSaving ? "กำลังบันทึก..." : "บันทึกข้อมูล",
              onTap: () async {
                if (_isSaving) return;

                setState(() {
                  _isSaving = true;
                });

                bool success = false;

                try {
                  success = await context
                      .read<HousekeeperRoomCheckScreenProvider>()
                      .submitRoomInspection(
                        roomNo: widget.roomNo,
                        cleaningStatus: _cleaningStatus,
                      );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isSaving = false;
                    });
                  }
                }

                if (!mounted) return;

                if (success) {
                  final messenger = ScaffoldMessenger.of(context);

                  Navigator.pop(context);

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        "บันทึกห้อง ${widget.roomNo} สำเร็จ",
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                } else {
                  final provider =
                      context.read<HousekeeperRoomCheckScreenProvider>();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.errorMessage.isEmpty
                            ? 'ไม่สามารถบันทึกข้อมูลได้'
                            : provider.errorMessage,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              color: Colors.green,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Section Card
  // ===========================================================================

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(
          Constants.borderRadius,
        ),
        border: Border.all(
          color: Constants.inputFieldBorderColor,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Constants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: Constants.fontSizeTitle,
                  fontWeight: Constants.fontWeightBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ===========================================================================
  // Furniture Card
  // ===========================================================================

  Widget _furnitureCard(
    BuildContext context,
    HousekeeperRoomCheckScreenProvider provider,
    int index,
    HousekeeperFurnitureItem item,
  ) {
    final bool isDamaged = item.status == 'ชำรุด';

    // ------------------------------------------------------------
    // รูปหลักของเฟอร์นิเจอร์
    // ------------------------------------------------------------
    ImageProvider? previewImage;

    if (item.photo != null) {
      previewImage = FileImage(item.photo!);
    } else if (item.lastDamageImageUrl != null &&
        item.lastDamageImageUrl!.isNotEmpty) {
      previewImage = NetworkImage(item.lastDamageImageUrl!);
    }

    // ------------------------------------------------------------
    // รูปความเสียหายที่ถ่ายใหม่
    // ------------------------------------------------------------
    final File? damagePhoto = item.damagePhoto;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.inputFieldFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDamaged
              ? Colors.red.withOpacity(0.35)
              : Constants.inputFieldBorderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // รูป + ชื่อเฟอร์นิเจอร์
          // ============================================================
          Row(
            children: [
              GestureDetector(
                onTap: () => provider.pickFurniturePhoto(
                  context,
                  index,
                ),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Constants.white,
                    border: Border.all(
                      color: Constants.inputFieldBorderColor,
                    ),
                    image: previewImage != null
                        ? DecorationImage(
                            image: previewImage,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: previewImage == null
                      ? Icon(
                          _iconForFurniture(item.title),
                          color: Constants.primaryColor,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: Constants.fontSizeBody,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // ลบเฉพาะรายการที่เพิ่มเอง
                        if (item.isCustom)
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              provider.removeFurnitureAt(index);
                            },
                            tooltip: "ลบรายการนี้",
                          ),
                      ],
                    ),
                    Text(
                      previewImage == null
                          ? "แตะรูปเพื่อถ่ายหลักฐาน"
                          : "มีรูปหลักฐานแล้ว",
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            previewImage == null ? Colors.grey : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ============================================================
          // สถานะ ปกติ / ชำรุด
          // ============================================================
          Row(
            children: [
              _statusChip(
                label: "ปกติ",
                selected: !isDamaged,
                color: Colors.green,
                // ระหว่างรอเปลี่ยนของใหม่ (แจ้งซ่อมไปแล้ว) ห้ามกดสลับกลับ
                // "ปกติ" ตรงนี้ ต้องยืนยันผ่านปุ่ม "ยืนยันเปลี่ยนของใหม่แล้ว"
                // เท่านั้น เพื่อไม่ให้ damageReported ค้าง state ผิด
                onTap: item.damageReported
                    ? null
                    : () {
                        provider.updateFurnitureStatus(index, "ปกติ");
                      },
              ),
              const SizedBox(width: 8),
              _statusChip(
                label: "ชำรุด",
                selected: isDamaged,
                color: Colors.red,
                onTap: item.damageReported
                    ? null
                    : () {
                        provider.updateFurnitureStatus(index, "ชำรุด");
                      },
              ),
            ],
          ),

          // ============================================================
          // แสดงรายละเอียดเมื่อเลือก "ชำรุด"
          // ============================================================
          if (isDamaged) ...[
            const SizedBox(height: 12),

            // ----------------------------------------------------------
            // รายละเอียดความเสียหาย
            // ----------------------------------------------------------
            TextField(
              onChanged: (value) {
                provider.updateFurnitureNote(
                  index,
                  value,
                );
              },
              decoration: InputDecoration(
                labelText: "รายละเอียดความเสียหาย",
                hintText: "เช่น เตียงมีรอยแตก, แอร์ไม่เย็น",
                isDense: true,
                filled: true,
                fillColor: Constants.white,
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.25),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: item.priority,
              decoration: InputDecoration(
                labelText: 'ระดับความเร่งด่วน',
                isDense: true,
                filled: true,
                fillColor: Constants.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('ปกติ')),
                DropdownMenuItem(value: 'medium', child: Text('ปานกลาง')),
                DropdownMenuItem(value: 'high', child: Text('เร่งด่วน')),
              ],
              onChanged: (value) {
                if (value != null) {
                  provider.updateFurniturePriority(index, value);
                }
              },
            ),

            const SizedBox(height: 12),

            // ----------------------------------------------------------
            // รูปความเสียหาย
            // ----------------------------------------------------------
            _buildDamagePhotoBox(
              context,
              provider,
              index,
              damagePhoto,
            ),

            const SizedBox(height: 12),

            // ----------------------------------------------------------
            // ปุ่มแจ้งซ่อม / ขั้นตอนรอเปลี่ยนของใหม่
            // ----------------------------------------------------------
            if (!item.damageReported)
              // ----- ยังไม่แจ้งซ่อม -----
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.build_circle_outlined),
                  label: const Text("แจ้งซ่อมรายการนี้"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: damagePhoto == null
                      ? null
                      : () async {
                          final ok = await provider.reportIssueNow(
                            index,
                            widget.roomNo,
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok
                                    ? "แจ้งซ่อม ${item.title} แล้ว"
                                    : provider.errorMessage,
                              ),
                              backgroundColor: ok ? Colors.green : Colors.red,
                            ),
                          );
                        },
                ),
              )
            else ...[
              // ----- แจ้งซ่อมแล้ว รอเปลี่ยนของใหม่ -----
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.orange, size: 18),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "แจ้งซ่อมแล้ว — ถ่ายรูปของใหม่เมื่อเปลี่ยนเสร็จ",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => provider.pickReplacementPhoto(context, index),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.4),
                    ),
                  ),
                  child: item.replacementPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.file(
                            item.replacementPhoto!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Text(
                            "แตะเพื่อถ่ายรูปของใหม่ที่นำมาเปลี่ยน",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: item.replacementPhoto == null
                      ? null
                      : () => provider.confirmReplacement(index),
                  child: const Text("ยืนยันเปลี่ยนของใหม่แล้ว"),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // Damage Photo
  // ===========================================================================

  Widget _buildDamagePhotoBox(
    BuildContext context,
    HousekeeperRoomCheckScreenProvider provider,
    int index,
    File? damagePhoto,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "รูปความเสียหาย",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            await provider.pickDamagePhoto(
              context,
              index,
            );
          },
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.red.withOpacity(0.25),
              ),
            ),
            child: damagePhoto != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          damagePhoto,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "ถ่ายใหม่",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: Colors.red,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "แตะเพื่อถ่ายรูปความเสียหาย",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "แนะนำให้ถ่ายรูปเพื่อใช้เป็นหลักฐาน",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Status Chip
  // ===========================================================================

  Widget _statusChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final bool disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Furniture Icon
  // ===========================================================================

  IconData _iconForFurniture(String title) {
    final value = title.toLowerCase();

    if (value.contains('เตียง') || value.contains('bed')) {
      return Icons.bed_rounded;
    }

    if (value.contains('แอร์') || value.contains('air')) {
      return Icons.air_rounded;
    }

    if (value.contains('ห้องน้ำ') || value.contains('bath')) {
      return Icons.bathtub_rounded;
    }

    if (value.contains('ทีวี') || value.contains('tv')) {
      return Icons.tv_rounded;
    }

    return Icons.inventory_2_outlined;
  }

  // ===========================================================================
  // Cleaning Status Dropdown
  // ===========================================================================

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Constants.inputFieldFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.inputFieldBorderColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _cleaningStatus,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Constants.primaryColor,
          ),
          items: [
            _dropdownItem(
              "ยังไม่ได้ทำความสะอาด",
              Colors.red,
            ),
            _dropdownItem(
              "กำลังทำความสะอาด",
              Constants.secondaryColor,
            ),
            _dropdownItem(
              "ทำความสะอาดเสร็จสิ้น",
              Colors.green,
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _cleaningStatus = value;
            });
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> _dropdownItem(
    String value,
    Color color,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(
              right: 10,
            ),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: Constants.fontSizeBody,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Add Extra Furniture
  // ===========================================================================

  void _showAddExtraFurniture(BuildContext context) {
    final provider = context.read<HousekeeperRoomCheckScreenProvider>();

    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Constants.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Constants.inputFieldBorderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Constants.primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "เพิ่มของนอกรายการ ห้อง ${widget.roomNo}",
                    style: const TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: Constants.fontWeightBold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "ชื่อของที่ต้องการเพิ่ม",
                prefixIcon: const Icon(
                  Icons.inventory_2_outlined,
                ),
                filled: true,
                fillColor: Constants.inputFieldFillColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "รายละเอียด / เหตุผลที่ต้องเพิ่ม",
                filled: true,
                fillColor: Constants.inputFieldFillColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Button(
              text: "เพิ่มรายการ",
              onTap: () {
                final title = titleController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(
                    sheetContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "กรุณากรอกชื่อของที่ต้องการเพิ่ม",
                      ),
                    ),
                  );
                  return;
                }

                provider.addExtraFurniture(
                  title,
                  note: descController.text.trim(),
                );

                Navigator.pop(sheetContext);
              },
              color: Constants.primaryColor,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
