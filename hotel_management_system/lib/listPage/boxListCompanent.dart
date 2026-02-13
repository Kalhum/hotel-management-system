import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';

class Boxlistcompanent extends StatelessWidget {
  final int roomNumber;
  final String date, payamout, keyBooking, status, textStatus;
  final Color statusColor;
  final bool? statusChekin;

  final Function()? onTap;

  Boxlistcompanent(
      {super.key,
      required this.roomNumber,
      required this.date,
      required this.payamout,
      required this.keyBooking,
      required this.status,
      required this.textStatus,
      required this.statusColor,
      required this.onTap,
      required this.statusChekin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(Constants.borderRadius)),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ห้อง $roomNumber"),
                  Text("วันที่เข้า"),
                  Text("ยอดชำระ"),
                  Text("รหัสการจอง")
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Text(date),
                  Text(payamout),
                  Text(keyBooking)
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 15,
                          color: statusColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          status,
                          style: TextStyle(
                              color: statusColor,
                              fontSize: Constants.fontSizeBody),
                        ),
                      ],
                    ),
                    Text(
                      textStatus,
                      style: TextStyle(
                          color: statusColor, fontSize: Constants.fontSizeBody),
                    ),
                    if (statusChekin == true)
                      Button(
                        text: "เช็คสภาพห้อง",
                        onTap: () {},
                        color: Colors.green,
                        btnSize: 150,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
