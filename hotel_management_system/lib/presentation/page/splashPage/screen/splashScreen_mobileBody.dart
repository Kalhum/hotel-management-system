import 'package:flutter/material.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';

class SplashScreenMobileBody extends StatefulWidget {
  const SplashScreenMobileBody({super.key});

  @override
  State<SplashScreenMobileBody> createState() => _SplashScreenMobileBodyState();
}

class _SplashScreenMobileBodyState extends State<SplashScreenMobileBody> {
  void onTapToLoginPage() {
    Navigator.pushNamed(context, "/login");
  }

  void onTapToHomePage() {
    Navigator.pushNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/HotelLogo.jpg',
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
              onTap: onTapToLoginPage,
              color: Constants.secondaryColor,
              btnSize: double.infinity,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Button(
              text: "เลือกดูห้องเลย",
              onTap: onTapToHomePage,
              color: Constants.secondaryColor,
              btnSize: double.infinity,
            ),
          )
        ],
      )),
    );
  }
}
