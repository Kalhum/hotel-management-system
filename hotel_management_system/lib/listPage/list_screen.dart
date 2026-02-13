import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/listPage/boxListCompanent.dart';
import 'package:hotel_management_system/listPage/infoAbout.dart';

class ListScreen extends StatefulWidget {
  final bool? checkInStatus;
  ListScreen({super.key, this.checkInStatus});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    String textStatus, textDetail = "";

    if (widget.checkInStatus == true) {
      textStatus = "Check in แล้ว";
      textDetail = "เช็คอินได้ตั้งแต่ 14.00 น.";
    } else {
      textStatus = "อนุมัติแล้ว";
      textDetail = "เอกสารได้รับการอนุมัติแล้ว";
    }
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  child: SingleChildScrollView(
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
                                style: TextStyle(
                                    fontSize: Constants.fontSizeHeader),
                              ),
                            ],
                          ),
                          Boxlistcompanent(
                            roomNumber: 205,
                            date: "15-17 ก.พ. 2569",
                            payamout: "1000 บาท",
                            keyBooking: "BK-10111223",
                            status: textStatus,
                            textStatus: textDetail,
                            statusColor: Colors.green,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                backgroundColor: Colors.white,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: SingleChildScrollView(
                                        child: Infoabout(
                                      status: true,
                                    )),
                                  );
                                },
                              );
                            },
                            statusChekin: widget.checkInStatus,
                          ),
                          Boxlistcompanent(
                            roomNumber: 305,
                            date: "10-12 ก.พ. 2569",
                            payamout: "2000 บาท",
                            keyBooking: "BK-10111213",
                            status: "รอดำเนินการ",
                            textStatus: "เจ้าหน้าที่กำลังตรวจสอบ",
                            statusColor: Colors.yellow,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                backgroundColor: Colors.white,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: SingleChildScrollView(
                                        child: Infoabout(
                                      status: false,
                                    )),
                                  );
                                },
                              );
                            },
                            statusChekin: null,
                          ),
                          Boxlistcompanent(
                            roomNumber: 105,
                            date: "23-15 ก.พ. 2569",
                            payamout: "1500",
                            keyBooking: "BK-10111233",
                            status: "ไม่ผ่าน",
                            textStatus: "เอกสารไม่ผ่าน",
                            statusColor: Colors.red,
                            onTap: () {},
                            statusChekin: null,
                          ),
                          SizedBox(
                            height: 150,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(top: 0, right: 0, left: 0, child: Topnavbar()),
                const Positioned(
                    bottom: 0, right: 0, left: 0, child: Bottomnavbar())
              ],
            ),
          )
        ],
      )),
    );
  }
}
