import 'package:flutter/material.dart';

import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen_desktopBody.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen_mobileBody.dart';
import 'package:hotel_management_system/presentation/responsiveLayout/responsive_layout.dart';

class PromotionDetailScreen extends StatelessWidget {
  const PromotionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final String? promoId = args is String ? args : null;

    if (promoId == null) {
      // เผื่อกรณีเข้าหน้านี้โดยไม่มี id มา (พิมพ์ url ตรงๆ, deep link ผิด ฯลฯ)
      return const Scaffold(
        body: Center(child: Text('ไม่พบข้อมูลโปรโมชั่น')),
      );
    }

    return ResponsiveLayout(
      mobileBody: PromotionDetailScreenMobilebody(promoId: promoId),
      desktopBody: PromotionDetailScreenDesktopbody(promoId: promoId),
    );
  }
}
