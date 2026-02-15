import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/historyPage/boxShowDataHistory.dart';

class BookingHistory {
  final int roomNumber;
  final String date;
  final String payAmount;
  final String keyBooking;
  // ส่วนที่เปลี่ยนแปลงได้
  int selectedRating;
  String reviewComment;
  String reviewStatus;
  bool isReviewed;

  BookingHistory({
    required this.roomNumber,
    required this.date,
    required this.payAmount,
    required this.keyBooking,
    this.selectedRating = 0,
    this.reviewComment = "ไม่ได้แสดงความคิดเห็น",
    this.reviewStatus = "ยังไม่ได้ให้คะแนน",
    this.isReviewed = false,
  });
}


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BookingHistory> myBookings = [
    BookingHistory(
      roomNumber: 205,
      date: "15-17 ก.พ. 2569",
      payAmount: "1000 บาท",
      keyBooking: "BK-10111223",
    ),
    BookingHistory(
      roomNumber: 305,
      date: "10-12 ก.พ. 2569",
      payAmount: "2000 บาท",
      keyBooking: "BK-10111213",
    ),
    BookingHistory(
      roomNumber: 105,
      date: "23-25 ก.พ. 2569",
      payAmount: "1500 บาท",
      keyBooking: "BK-10111233",
    ),
  ];

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
          child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Constants.padding),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Row(
                      children: [
                        Text(
                          "รายการของฉัน",
                          style: TextStyle(fontSize: Constants.fontSizeHeader),
                        ),
                      ],
                    ),
                    ...myBookings
                        .map((booking) => Boxshowdatahistory(
                              roomNumber: booking.roomNumber,
                              date: booking.date,
                              payamout: booking.payAmount,
                              keyBooking: booking.keyBooking,
                              status: booking.reviewStatus,
                              textStatus: booking.reviewComment,
                              onTap: booking.isReviewed
                                  ? null
                                  : () => _showRatingBottomSheet(context,
                                      booking), // ส่งตัวแปร booking เข้าไป
                              ratingWidget: booking.isReviewed
                                  ? Row(
                                      children: List.generate(
                                          5,
                                          (index) => Icon(
                                                Icons.star,
                                                size: 15,
                                                color: index <
                                                        booking.selectedRating
                                                    ? Colors.amber
                                                    : Colors.grey[300],
                                              )),
                                    )
                                  : null,
                            ))
                        .toList(),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
            Positioned(top: 0, right: 0, left: 0, child: Topnavbar()),
            Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar())
          ],
        ),
      )),
    );
  }

  // รับ BookingHistory เข้ามาด้วย
  void _showRatingBottomSheet(BuildContext context, BookingHistory booking) {
    int tempRating = 0;
    _commentController.clear(); // ล้างข้อความเก่าออกก่อนพิมพ์ใหม่

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "ให้คะแนนห้อง ${booking.roomNumber}", // แสดงเลขห้องที่กำลังรีวิว
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < tempRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () =>
                          setSheetState(() => tempRating = index + 1),
                    );
                  }),
                ),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                      hintText: "เขียนความคิดเห็นของคุณ..."),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Button(
                  text: "ส่งรีวิว",
                  color: Constants.primaryColor,
                  onTap: () {
                    // อัปเดตข้อมูลเฉพาะของกล่องนี้
                    setState(() {
                      booking.selectedRating = tempRating;
                      booking.reviewComment = _commentController.text.isEmpty
                          ? "ไม่ได้แสดงความคิดเห็น"
                          : _commentController.text;
                      booking.reviewStatus = "ให้คะแนนแล้ว ($tempRating/5)";
                      booking.isReviewed = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
