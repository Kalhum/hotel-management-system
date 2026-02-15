import 'package:flutter/material.dart';
import 'package:hotel_management_system/checkInPage/check_in_screen.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';

class Infoabout extends StatelessWidget {
  final bool? status;
  Infoabout({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  status == true ? "รายละเอียดการเข้าพัก" : "รายละเอียดการจอง",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 30),
            _infoRow("ชื่อ-นามสกุล", "นาย สมชาย สมหวัง", null),
            _infoRow("เบอร์โทร", "090-909-9900", null),
            _infoRow("Email", "test@gmail.com", null),
            const SizedBox(height: 20),
            _infoRow("เลขห้อง", "305", null),
            _infoRow("วันที่เข้าพัก", "15-17 ก.พ. 2569", null),
            _infoRow("จำนวนคืน", "2", null),
            _infoRow("จำนวนคน", "2", null),
            // if (status == true) _infoRow("เงินทั้งหมด", "2,000 บาท", null),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("สถานะการชำระเงิน ${status == true ? "" : "มัดจำ"} ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Container(
              width: double.infinity,
              child: Image.asset("assets/images/slip.png"),
            ),

            
            SizedBox(
              height: 20,
            ),
            if (status == true)
              Button(text: "Check-in", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckInScreen()));
              }, color: Colors.green),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget ช่วยจัดบรรทัดให้ตรงกัน

Widget _infoRow(String label, String value, Color? textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[700], fontSize: Constants.fontSizeBody)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Constants.fontSizeBody,
                color: textColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
