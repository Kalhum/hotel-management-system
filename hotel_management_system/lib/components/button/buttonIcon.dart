import 'package:flutter/material.dart';
import 'package:hotel_management_system/core/constants.dart';

class Buttonicon extends StatelessWidget {
  Function() onTap = () {};
  final String text;
  final IconData icon ;

  Buttonicon({super.key, required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: Constants.white, size: 30),
            Text(
              text,
              style: TextStyle(
                color: Constants.white,
                fontSize: Constants.fontSizeBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
