import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hotel_management_system/core/constants.dart';

class Button extends StatelessWidget {
  Function() onTap = () {};
  final String text;
  final Color color;
  final double? btnSize;  

  Button(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color, this.btnSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: Constants.padding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: Constants.fontSizeBody,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
