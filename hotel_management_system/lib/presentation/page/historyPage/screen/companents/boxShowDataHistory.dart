import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Boxshowdatahistory extends StatelessWidget {
  final String roomNumber;
  final String date, payamout, keyBooking, status, textStatus;
  final Color? statusColor;
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
    this.ratingWidget,
  });

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
            // --- Header ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: (statusColor ?? Colors.grey).withOpacity(0.07),
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
                  if (ratingWidget != null)
                    ratingWidget!
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (statusColor ?? Colors.grey).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (statusColor != null) ...[
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: 6),
                          ],
                          Text(status,
                              style: TextStyle(
                                  color: statusColor ?? Colors.grey[600],
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
                  _buildInfoRow(
                      Icons.calendar_today_outlined, "วันที่เข้า", date),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.payments_outlined, "ยอดชำระ", payamout),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.confirmation_number_outlined,
                      "รหัสการจอง", keyBooking),
                  if (textStatus.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.comment_outlined, "ความคิดเห็น", textStatus,
                        color: statusColor ?? Colors.grey[600]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text("$label  ", style: TextStyle(fontSize: 13, color: Colors.black)),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.grey[800]),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
