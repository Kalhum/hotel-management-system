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
      required this.color,
      this.btnSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnSize != null ? btnSize : double.infinity,
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

void showSuccessDialog(BuildContext context, String textTitle, String textBody,
    Widget destination) {
  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการกดนอก Dialog เพื่อปิด
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ให้ Dialog ขนาดพอดีกับเนื้อหา
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                textTitle,
                style: TextStyle(
                  fontSize: Constants.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textBody,
                style: TextStyle(
                  fontSize: Constants.fontSizeBody,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Dialog
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => destination));
                  },
                  child: const Text('ตกลง',
                      style: TextStyle(
                        fontSize: Constants.fontSizeBody,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
