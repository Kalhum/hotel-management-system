import 'package:flutter/material.dart';

import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../loginPage/screen/login_screen.dart';

class SplashScreenDesktopBody extends StatefulWidget {
  const SplashScreenDesktopBody({super.key});

  @override
  State<SplashScreenDesktopBody> createState() =>
      _SplashScreenDesktopBodyState();
}

class _SplashScreenDesktopBodyState extends State<SplashScreenDesktopBody> {
  void onTopToLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  child: Image.asset(
                'assets/images/HotelLogo.jpg',
                width: screenWidth * 0.4,
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
                  btnSize: screenWidth * 0.2,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
}
