import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Buttonicon extends StatelessWidget {
  final Function() onTap;
  final String text;
  final IconData icon;

  Buttonicon(
      {super.key, required this.onTap, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, color: Constants.white, size: 30),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: Constants.white,
                fontSize: Constants.fontSizeBody,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
