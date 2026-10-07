// room_condition_check_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../util/function/image_url.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/room_condition_check_screen_provider.dart';

class RoomConditionCheckScreenMobileBody extends StatefulWidget {
  final String roomId;
  final String bookingId;
  const RoomConditionCheckScreenMobileBody({
    super.key,
    required this.roomId,
    required this.bookingId,
  });

  @override
  State<RoomConditionCheckScreenMobileBody> createState() =>
      _RoomConditionCheckScreenMobileBodyState();
}

class _RoomConditionCheckScreenMobileBodyState
    extends State<RoomConditionCheckScreenMobileBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RoomConditionCheckScreenProvider>()
          .init(widget.roomId, widget.bookingId); 
    });
  }

  Widget _buildTimerBadge(int seconds) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200)),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.red, size: 20),
          const SizedBox(width: 5),
          Text(
            context
                .read<RoomConditionCheckScreenProvider>()
                .formatTime(seconds),
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(FurnitureItem item) {
    final imageUrl = ImageUrlHelper.toFullImageUrl(item.inspectionImageUrl) ??
        ImageUrlHelper.toFullImageUrl(item.image?.toString());
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) {
          debugPrint("โหลดรูปไม่สำเร็จ");
          debugPrint("URL: $imageUrl");
          debugPrint("ERROR: $error");

          return const Icon(
            Icons.broken_image,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    }

    return Container(
      width: 60,
      height: 60,
      color: Colors.orange.shade100,
      child: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.orange,
      ),
    );
  }

  Widget _buildStatusPicker(int index, FurnitureItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ["ปกติ", "ชำรุด"].map((s) {
        final bool active = item.status == s;
        final bool isDamaged = s == "ชำรุด";

        return GestureDetector(
          onTap: () {
            context
                .read<RoomConditionCheckScreenProvider>()
                .updateStatus(index, s);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: active
                  ? (isDamaged ? Colors.red.shade50 : Colors.green.shade50)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: active
                    ? (isDamaged ? Colors.red : Colors.green)
                    : Colors.grey.shade300,
                width: active ? 1.5 : 1,
              ),
            ),
            child: Text(
              s,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active
                    ? (isDamaged ? Colors.red : Colors.green.shade700)
                    : Colors.grey.shade600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDamageDetailBox(int index, FurnitureItem item) {
    final provider = context.read<RoomConditionCheckScreenProvider>();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade600,
                size: 19,
              ),
              const SizedBox(width: 7),
              Text(
                "รายละเอียดความเสียหาย",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // รายละเอียด
          TextFormField(
            initialValue: item.note,
            onChanged: (value) {
              provider.updateNote(
                index,
                value,
              );
            },
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "เช่น เตียงมีรอยแตก หรือชำรุดบริเวณขาเตียง",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // รูปความเสียหาย
          GestureDetector(
            onTap: () => provider.pickDamageImage(index),
            child: item.damageImage == null
                ? Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "เลือกรูปความเสียหายจากคลัง",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "แตะเพื่อเลือกไฟล์รูปภาพ",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.file(
                          item.damageImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                provider.pickDamageImage(index);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFurnitureRow(int index, FurnitureItem item) {
    final bool isDamaged = item.status == "ชำรุด";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDamaged ? Colors.red.shade200 : Colors.grey.shade300,
          width: isDamaged ? 1.2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // รูป + ชื่อ
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildItemImage(item),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDamaged
                          ? "กรุณาระบุรายละเอียดความเสียหาย"
                          : "ตรวจสอบสภาพและเลือกสถานะ",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDamaged
                            ? Colors.red.shade400
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // สถานะ
          Row(
            children: [
              Text(
                "สถานะ",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusPicker(index, item),
              ),
            ],
          ),

          // ถ้าชำรุด → แสดงรายละเอียด + รูป
          if (isDamaged) _buildDamageDetailBox(index, item),
        ],
      ),
    );
  }

  void _showAddExtraDamageSheet() {
    String extraTitle = "";
    File? tempImage;

    //ดักจับ provider ไว้ก่อนเปิด modal เพราะ context ข้างใน builder ของ
    // showModalBottomSheet อยู่คนละ tree กับ context ปัจจุบัน หาไม่เจอ provider
    final provider = context.read<RoomConditionCheckScreenProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: provider,
        child: StatefulBuilder(
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
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                        borderSide: BorderSide(
                            color: Constants.primaryColor, width: 2)),
                  ),
                ),
                const SizedBox(height: 16),
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
                            Positioned(
                                right: 10,
                                top: 10,
                                child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 18))),
                          ]),
                        ),
                ),
                const SizedBox(height: 24),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("กรุณาระบุชื่อสิ่งของ")));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog({String msg = "บันทึกข้อมูลสำเร็จ"}) async {
    try {
      await context
          .read<RoomConditionCheckScreenProvider>()
          .submitCheckCondition(widget.roomId);

      if (!context.mounted) return;
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
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("บันทึกข้อมูลไม่สำเร็จ กรุณาลองใหม่อีกครั้ง"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<RoomConditionCheckScreenProvider>(
              builder: (context, provider, _) {
                if (provider.consumeAutoSubmitTrigger()) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSuccessDialog(
                        msg: "หมดเวลาตรวจเช็ค ระบบยืนยันอัตโนมัติ");
                  });
                }

                if (provider.isLoading) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: CircularProgressIndicator(),
                  ));
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 200, left: 24, right: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(provider.errorMessage!,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<RoomConditionCheckScreenProvider>()
                                .init(widget.roomId, widget.bookingId),
                            child: const Text("ลองใหม่อีกครั้ง"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 140, bottom: 120, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("ตรวจเช็คเฟอร์นิเจอร์",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text("กรุณาตรวจสอบสภาพเฟอร์นิเจอร์ทุกชิ้น",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500])),
                            ],
                          ),
                          _buildTimerBadge(provider.remainingSeconds),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryChip(
                                "ปกติ", provider.normalCount, Colors.green),
                            _buildSummaryChip(
                                "ชำรุด", provider.damagedCount, Colors.red),
                            _buildSummaryChip(
                                "ยังไม่ตรวจ",
                                provider.furnitureList
                                    .where((f) => f.status.isEmpty)
                                    .length,
                                Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(0.05),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.chair_outlined,
                                      color: Constants.primaryColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text("รายการทั้งหมด",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Constants.primaryColor)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                        "${provider.furnitureList.length} รายการ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constants.primaryColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: provider.furnitureList
                                    .asMap()
                                    .entries
                                    .map((entry) => _buildFurnitureRow(
                                        entry.key, entry.value))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Button(
                          text: "บันทึกข้อมูลการตรวจเช็ค",
                          onTap: () => _showSuccessDialog(),
                          color: Constants.primaryColor),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () => _showAddExtraDamageSheet(),
                        icon: const Icon(Icons.add),
                        label: const Text("แจ้งของชำรุดเพิ่มเติม"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                          side: BorderSide(color: Colors.orange.shade700),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.borderRadius)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Topnavbar(
                  widthFactor: 0.2,
                )),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryChip(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text("$count",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
