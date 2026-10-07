import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button.dart';
import 'package:hotel_management_system/components/buttonAuth.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/registerPage/register_screen.dart';
import 'package:hotel_management_system/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  void confrimLogin(context) {
    // Logic การยืนยันการเข้าสู่ระบบ
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    print("Login confirmed");
  }

  void registerPage(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  void loginWithGoogle(context) {
    // Logic การเข้าสู่ระบบด้วย Google
    print("Login with Google");
  }

  void loginWithFacebook(context) {
    // Logic การเข้าสู่ระบบด้วย Facebook
    print("Login with Facebook");
  }

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
                  'เข้าสู่ระบบสำเร็จ',
                  style: TextStyle(
                    fontSize: Constants.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ยินดีต้อนรับเข้าสู่ระบบครับ',
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
                          builder: (context) => const SplashScreen()));
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/HotelLogo.png',
                    width: screenWidth * 0.6,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              createInputField(InputFieldType.username),
              createInputField(InputFieldType.password),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ลืมรหัสผ่าน?',
                    style: TextStyle(
                      fontSize: Constants.fontSizeLabel,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Button(
                text: "เข้าสู่ระบบ",
                onTap: () {
                  widget.showSuccessDialog(context);
                },
                color: Constants.secondaryColor,
                btnSize: 300,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยังไม่มีบัญชีผู้ใช้?',
                    style: TextStyle(
                      fontSize: Constants.fontSizeLabel,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.registerPage(context);
                    },
                    child: const Text(
                      ' สมัครสมาชิก',
                      style: TextStyle(
                        fontSize: Constants.fontSizeLabel,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'หรือเข้าสู่ระบบด้วย',
                style: TextStyle(
                  fontSize: Constants.fontSizeLabel,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonAuth(
                      onTap: () => widget.loginWithGoogle(context),
                      ImagePath: "assets/images/authLogo/Google_Logo.png"),
                  SizedBox(width: 20),
                  ButtonAuth(
                      onTap: () => widget.loginWithFacebook(context),
                      ImagePath: "assets/images/authLogo/FacebookLogo.png")
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
