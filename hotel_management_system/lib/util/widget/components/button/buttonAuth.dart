import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class ButtonAuth extends StatelessWidget {
  final Function() onTap;
  final String ImagePath;
  ButtonAuth({super.key, required this.onTap, required this.ImagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: Constants.padding),
        decoration: BoxDecoration(
          color: Constants.bgButon,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        child: Center(
            child:
                SizedBox(width: 70, height: 70, child: Image.asset(ImagePath))),
      ),
    );
  }
}
