// register_screen.dart
import 'package:flutter/material.dart';
import 'registerScreen_desktopBody.dart';
import 'registerScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: RegisterScreenMobileBody(),
      desktopBody: RegisterScreenDesktopBody(),
    );
  }
}
