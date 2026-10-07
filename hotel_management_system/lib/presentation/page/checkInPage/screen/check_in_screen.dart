// check_in_screen.dart
import 'package:flutter/material.dart';
import 'check_in_desktopBody.dart';
import 'check_in_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class CheckInScreen extends StatelessWidget {
  final String? bookingId;
  final double totalPrice;
  final double depositAmount;

  const CheckInScreen({
    super.key,
    this.bookingId,
    this.totalPrice = 0,
    this.depositAmount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: CheckInScreenMobileBody(
        bookingID: bookingId,
        totalPrice: totalPrice,
        depositAmount: depositAmount,
      ),
      desktopBody: CheckInScreenDesktopBody(
        bookingID: bookingId,
        totalPrice: totalPrice,
        depositAmount: depositAmount,
      ),
    );
  }
}
