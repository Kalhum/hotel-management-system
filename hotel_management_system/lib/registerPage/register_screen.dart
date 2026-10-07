import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/loginPage/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  void showSuccessDialog(BuildContext context) {
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
                const Text(
                  'สมัครสมาชิกสำเร็จ',
                  style: TextStyle(
                    fontSize: Constants.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'กลับไปหน้าเข้าสู่ระบบครับ',
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
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

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _myGender = "ชาย";

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: Column(
        children: [
          // nav bar
          Container(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: screenWidth * 0.2,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius)),
                        color: Constants.secondaryColor,
                      ),
                      child: const Text(
                        "กลับ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Constants.fontSizeLabel),
                      )),
                ),
              ],
            ),
          ),

          // content body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                      fontSize: Constants.fontSizeDisplay,
                      fontWeight: Constants.fontWeightMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Constants.padding),
                    child: Column(
                      children: [
                        createInputField(InputFieldType.username),
                        createInputField(InputFieldType.email),
                        createInputField(InputFieldType.phoneNumber),
                        createInputField(InputFieldType.gender,
                            selectedValue: _myGender, onChanged: (value) {
                          setState(() {
                            _myGender = value.toString();
                          });
                        }),
                        createInputField(InputFieldType.password),
                        createInputField(InputFieldType.conformPassword),
                        SizedBox(height: 100),
                        Button(
                          text: "สมัครสมาชิก",
                          onTap: () {
                            widget.showSuccessDialog(context);
                          },
                          color: Constants.secondaryColor,
                          btnSize: 300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
