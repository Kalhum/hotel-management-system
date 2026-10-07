// dialog_helper.dart
import 'package:flutter/material.dart';
import '../../core/constants.dart';




void showSuccessDialog(
  BuildContext context,
  String textTitle,
  String textBody,
  String destinationRouteName,
  String code,
  String dateStrat,
  String dateEnd, {
  Object? arguments, //สำหรับส่ง argument ไปหน้าถัดไป
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการกดนอก Dialog เพื่อปิด
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: screenWidth * 0.2), // กำหนดความกว้างสูงสุดของ Dialog
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
                Column(
                  children: [
                    if (code == "")
                      Text(
                        textBody,
                        style: TextStyle(
                          fontSize: Constants.fontSizeBody,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else ...[
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: Constants.fontSizeDisplay,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        dateStrat,
                        style: TextStyle(
                          fontSize: Constants.fontSizeBody,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        dateEnd,
                        style: TextStyle(
                          fontSize: Constants.fontSizeBody,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]
                  ],
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
                      Navigator.pushNamed(
                        context,
                        destinationRouteName,
                        arguments: arguments,
                      );
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
        ),
      );
    },
  );
}

void showSuccessSaveQRcodeDialog(
    BuildContext context, String textTitle, String textBody) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(textTitle,
                  style: TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(textBody,
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      color: Colors.grey[700]),
                  textAlign: TextAlign.center),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ตกลง',
                      style: TextStyle(
                          fontSize: Constants.fontSizeBody,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
