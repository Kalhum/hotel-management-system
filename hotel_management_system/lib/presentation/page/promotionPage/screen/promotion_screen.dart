import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/screen/promotion_screen_desktopBody.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/screen/promotion_screen_mobileBody.dart';
import 'package:hotel_management_system/presentation/responsiveLayout/responsive_layout.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: PromotionScreenMobilebody(),
        desktopBody: promotion_screen_desktopBody());
  }
}
