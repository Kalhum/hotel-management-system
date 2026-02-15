import 'package:flutter/material.dart';
import 'package:hotel_management_system/core/constants.dart';

class Topnavbar extends StatelessWidget {
  const Topnavbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(Constants.padding),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(Constants.borderRadius),
          bottomRight: Radius.circular(Constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.white.withOpacity(0.3),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person, color: Constants.white, size: 40),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ยินดีต้อนรับ",
                    style: TextStyle(
                      color: Constants.white,
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Kritsada",
                    style: TextStyle(
                      color: Constants.white,
                      fontSize: Constants.fontSizeBody,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: screenWidth * 0.2,
                alignment: Alignment.center,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Constants.borderRadius)),
                  color: Constants.secondaryColor,
                ),
                child: const Text(
                  "กลับ",
                  style: TextStyle(
                      color: Colors.white, fontSize: Constants.fontSizeLabel),
                )),
          ),
        ],
      ),
    );
  }
}
