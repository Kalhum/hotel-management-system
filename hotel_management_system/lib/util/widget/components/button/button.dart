// button.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Button extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color? color, textColor;
  final double? btnSize, btnHigh, btnPadding;

  Button(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color,
      this.btnSize,
      this.btnHigh,
      this.btnPadding,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnSize ?? double.infinity,
        height: btnHigh,
        padding:
            EdgeInsets.symmetric(vertical: btnPadding ?? Constants.padding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: Constants.fontSizeBody,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
