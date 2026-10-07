import 'package:flutter/material.dart';
import 'package:hotel_management_system/RoomConditionCheckPage/room_condition_check_screen.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';

class Boxshowdatahistory extends StatelessWidget {
  final int roomNumber;
  final String date, payamout, keyBooking, status, textStatus;
  final Color? statusColor;
  final bool? statusChekin;
  final Widget? ratingWidget;
  final Function()? onTap;

  Boxshowdatahistory({
    super.key,
    required this.roomNumber,
    required this.date,
    required this.payamout,
    required this.keyBooking,
    required this.status,
    required this.textStatus,
    required this.onTap,
    this.statusColor,
    this.statusChekin,
    this.ratingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ห้อง $roomNumber",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text("วันที่เข้า"),
                const Text("ยอดชำระ"),
                const Text("รหัสการจอง")
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(date, overflow: TextOverflow.ellipsis),
                  Text(payamout, overflow: TextOverflow.ellipsis),
                  Text(keyBooking, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. ส่วนแสดงดาว หรือ สถานะข้อความ
                if (ratingWidget != null)
                  ratingWidget!
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // แสดงจุดสีเฉพาะเมื่อมีการส่งสีมา
                      if (statusColor != null)
                        Icon(Icons.circle, size: 10, color: statusColor),
                      if (statusColor != null) const SizedBox(width: 5),

                      // แสดงข้อความสถานะเสมอ (เช่น "ยังไม่ได้ให้คะแนน")
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor ??
                              Colors.grey[600], // ถ้าไม่มีสีให้ใช้สีเทา
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                // 2. ส่วนแสดงความคิดเห็น (เช่น "ไม่ได้แสดงความคิดเห็น")
                Text(
                  textStatus,
                  style: TextStyle(
                    color: statusColor ?? Colors.grey[500],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),

                const SizedBox(height: 8),

                // 3. ปุ่มเช็คสภาพห้อง
                if (statusChekin == true)
                  Button(
                    text: "เช็คสภาพห้อง",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RoomConditionCheckScreen()));
                    },
                    color: Colors.green,
                    btnSize: 100,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
