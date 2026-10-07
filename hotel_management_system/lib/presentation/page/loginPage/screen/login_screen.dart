// login_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/loginPage/login_page_route.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: LoginScreenMobileBody(),
      desktopBody: LoginScreenDesktopBody(),
    );
  }
}
