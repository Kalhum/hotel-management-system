import 'package:flutter/material.dart';

import '../../../../util/model/model.dart';
import '../../../../util/widget/core/constants.dart';

class Boxlistcompanent extends StatelessWidget {
  final String roomNumber;
  final String status, textStatus;
  final String keyBooking;
  final double payamout;
  final Color statusColor;
  final bool? statusChekin;
  final bool? statusCheckout;
  final bool? statusConCheck;
  final String? roomKey;

  final Function()? onTap;
  final Future<void> Function()? onCheckOut;
  final Future<void> Function()? onCancel;
  final String? cancelReason;
  final Future<void> Function(int rating, String comment)?
      onSubmitReview; // เพิ่ม

  Boxlistcompanent(
      {super.key,
      required this.roomNumber,
      required this.payamout,
      required this.keyBooking,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      required this.onTap,
      required this.statusChekin,
      this.statusCheckout,
      this.statusConCheck,
      this.roomKey,
      this.onCheckOut,
      this.onCancel,
      this.cancelReason,
      this.onSubmitReview}); // เพิ่ม

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            // --- Header: ห้องและสถานะ ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.07),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.meeting_room_outlined,
                          color: Constants.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text("ห้อง $roomNumber",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 6),
                        Text(status,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Body: ข้อมูล ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.payments_outlined, "ยอดชำระ",
                      "฿${payamout.toStringAsFixed(2)}"),
                  _buildInfoRow(Icons.confirmation_number_outlined,
                      "รหัสการจอง", keyBooking),
                  if (textStatus.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.info_outline, "สถานะ", textStatus,
                        color: statusColor),
                  ],
                  if (cancelReason != null && cancelReason!.isNotEmpty)
                    _buildInfoRow(
                        Icons.info_outline, "เหตุผลยกเลิก", cancelReason!,
                        color: Colors.red),
                  if (roomKey != "" && roomKey != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.key, "รหัสเข้าห้อง", roomKey,
                        color: statusColor),
                  ]
                ],
              ),
            ),

            // --- User cancellation is available before check-in ---
            if (onCancel != null)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text("ยกเลิกการจอง"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

            // --- Check-in/check-out actions ---
            if (statusChekin == true)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    if (statusConCheck == true)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                              context, "/room_condition_check",
                              arguments: RoomConditionCheckArguments(
                                roomId: roomNumber,
                                bookingId: keyBooking,
                              )),
                          icon: const Icon(Icons.checklist_outlined, size: 18),
                          label: const Text("ตรวจสภาพห้อง"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    if (statusConCheck == true) const SizedBox(width: 10),
                    Expanded(
                      child: statusCheckout == true
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 18, color: Colors.grey.shade600),
                                  const SizedBox(width: 6),
                                  Text(
                                    "เช็คเอาท์แล้ว",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text('ยืนยันการเช็คเอาท์'),
                                      content: const Text(
                                          'คุณแน่ใจว่าต้องการเช็คเอาท์หรือไม่?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('ยกเลิก'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Constants.secondaryColor),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await _handleCheckOut(context);
                                          },
                                          child: const Text('ยืนยัน'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text("เช็คเอาท์"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text("$label  ", style: const TextStyle(fontSize: 13, color: Colors.black)),
        Expanded(
          child: Text(value.toString(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.grey[800]),
              textAlign: TextAlign.end),
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    double selectedRating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title:
                  const Text('คะแนนความพึงพอใจ', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ความพึงพอใจต่อการเข้าพักของคุณ'),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'แสดงความคิดเห็นเพิ่มเติม...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _showSuccessDialog(context)
                  },
                  child: const Text('ข้าม'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    Navigator.of(context).pop(); // ปิดหน้า Feedback ก่อน
                    await _handleSubmitReview(context, selectedRating.toInt(),
                        commentController.text); // แก้: เรียกส่งรีวิวจริง
                  },
                  child: const Text('ส่งความเห็น'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เช็คเอาท์สำเร็จ'),
          content:
              const Text('คุณได้เช็คเอาท์เรียบร้อยแล้ว ขอบคุณที่ใช้บริการ'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryColor),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/list_page',
                  (route) => false,
                );
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (onCheckOut != null) {
        await onCheckOut!();
      }
      Navigator.of(rootContext).pop(); // ปิด loading dialog
      _showFeedbackDialog(rootContext);
    } catch (e) {
      Navigator.of(rootContext).pop(); // ปิด loading dialog
      _showErrorDialog(rootContext, e.toString().replaceAll('Exception: ', ''));
    }
  }

  // เพิ่มฟังก์ชันใหม่: ส่งรีวิวจริงผ่าน onSubmitReview
  Future<void> _handleSubmitReview(
      BuildContext context, int rating, String comment) async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (onSubmitReview != null) {
        await onSubmitReview!(rating, comment);
      }
      Navigator.of(rootContext).pop(); // ปิด loading
      _showSuccessDialog(rootContext);
    } catch (e) {
      Navigator.of(rootContext).pop(); // ปิด loading
      _showErrorDialog(rootContext, e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('เกิดข้อผิดพลาด'),
        content: Text(message),
        actions: [
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }
}
