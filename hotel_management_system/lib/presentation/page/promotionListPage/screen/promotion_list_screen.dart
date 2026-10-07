import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionListPage/screen/promotion_list_desktopBody.dart';
import 'package:hotel_management_system/presentation/responsiveLayout/responsive_layout.dart';

class PromotionListScreen extends StatelessWidget {
  const PromotionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: PromotionListDesktopbody(),
        desktopBody: PromotionListDesktopbody());
  }
}
