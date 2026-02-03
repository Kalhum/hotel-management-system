import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/loginPage/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void onTopToLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // ตึงความกว้างหน้าจอ
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: screenWidth * 0.6,
                      child: Image.asset(
                        'assets/images/HotelLogo.png',
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'ยินดีต้อนรับ ให้เราช่วยดูแลการพักผ่อนและบริการทุกระดับประทับใจเพื่อคุณ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'เริ่มต้นการพักผ่อนที่สมบูรณ์แบบ จองห้องพักและบริการง่ายๆ ได้ที่นี่',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Button(
                      text: "เข้าสู่ระบบ",
                      onTap: onTopToLoginPage,
                      color: Constants.secondaryColor,
                      btnSize: double.infinity,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
