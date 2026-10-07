// booking_form_screen.dart
import 'package:flutter/material.dart';
import '../../../responsiveLayout/responsive_layout.dart';
import 'booking_form_screen_route.dart';

class BookingFormScreen extends StatelessWidget {
  const BookingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ห้องพักที่จะจองอ่านจาก CartProvider (global) แล้ว ไม่ต้องรับ arguments
    return const ResponsiveLayout(
      mobileBody: BookingFormScreenMobileBody(),
      desktopBody: BookingFormScreenDesktopBody(),
    );
  }
}
