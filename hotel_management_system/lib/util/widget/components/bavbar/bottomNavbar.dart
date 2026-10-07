import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/components/button/buttonIcon.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

import '../../../provider/cart_provider.dart';

class Bottomnavbar extends StatelessWidget {
  final bool? isVisibleHousekeeper;
  const Bottomnavbar({super.key, this.isVisibleHousekeeper = true});

  static const String _housekeeperRole = "housekeeper";

  void navigateToHome(BuildContext context) =>
      Navigator.pushNamed(context, "/home");

  void navigateToList(BuildContext context) =>
      Navigator.pushNamed(context, "/list_page");

  void navigateToNews(BuildContext context) =>
      Navigator.pushNamed(context, "/promotion_page");

  void navigateToHistory(BuildContext context) =>
      Navigator.pushNamed(context, "/history");

  void housekeeperRoomCheck_Screen(BuildContext context) =>
      Navigator.pushNamed(context, "/housekeeper");

  @override
  Widget build(BuildContext context) {
    // ใช้ watch เพราะต้อง rebuild ปุ่มนี้เองถ้า role เปลี่ยน (เช่น login/logout สลับ user)
    final role = context.watch<UserProvider>().user?.role;

    // เทียบแบบไม่สนตัวพิมพ์ใหญ่-เล็ก กัน "housekeeper" vs "Housekeeper" หลุด
    final isHousekeeper = role?.toLowerCase() == _housekeeperRole.toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Constants.borderRadius),
          topRight: Radius.circular(Constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToHome(context),
                text: "หน้าแรก",
                icon: Icons.home_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToList(context),
                text: "รายการ",
                icon: Icons.list_alt_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToNews(context),
                text: "ข่าวสาร",
                icon: Icons.campaign_outlined),
          ),
          Expanded(
            child: Buttonicon(
                onTap: () => navigateToHistory(context),
                text: "ประวัติ",
                icon: Icons.history_outlined),
          ),
          // โชว์ปุ่มแม่บ้านเฉพาะ role housekeeper เท่านั้น
          // (isVisibleHousekeeper ยังคงไว้เผื่อบางหน้าอยากซ่อนเองด้วย
          // เช่นตอนอยู่ในหน้า housekeeper เองแล้วไม่ต้องโชว์ซ้ำ)
          if ((isVisibleHousekeeper ?? true) && isHousekeeper)
            Expanded(
              child: Buttonicon(
                  onTap: () => housekeeperRoomCheck_Screen(context),
                  text: "แม่บ้าน",
                  icon: Icons.cleaning_services_outlined),
            ),

          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.white.withOpacity(0.3),
                ),
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart,
                        color: Constants.white, size: 40),
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        if (cart.itemCount == 0) {
                          return const SizedBox.shrink();
                        }
                        return Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                                minWidth: 18, minHeight: 18),
                            child: Text(
                              '${cart.itemCount}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
