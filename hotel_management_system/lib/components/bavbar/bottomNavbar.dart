import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button/buttonIcon.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/homePage/home_screen.dart';
import 'package:hotel_management_system/listPage/list_screen.dart';

class Bottomnavbar extends StatelessWidget {
  const Bottomnavbar({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void navigateToList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListScreen( checkInStatus: false,)),
    );
  }

  void navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Constants.padding),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Constants.borderRadius),
          topRight: Radius.circular(Constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Buttonicon(
              onTap: () => navigateToHome(context),
              text: "หน้าแรก",
              icon: Icons.home_outlined),
          Buttonicon(
              onTap: () => navigateToList(context),
              text: "รายการ",
              icon: Icons.list_alt_outlined),
          Buttonicon(
              onTap: () {}, text: "ประวัติ", icon: Icons.history_outlined),
        ],
      ),
    );
  }
}
