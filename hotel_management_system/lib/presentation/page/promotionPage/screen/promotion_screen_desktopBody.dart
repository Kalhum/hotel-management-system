import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/provider/announcement_provider.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/provider/promotion_provider.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/components/announcement_carousel.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import '../components/boxShow_promotion_card.dart';

class promotion_screen_desktopBody extends StatefulWidget {
  const promotion_screen_desktopBody({super.key});

  @override
  State<promotion_screen_desktopBody> createState() =>
      _promotion_screen_desktopBodyState();
}

class _promotion_screen_desktopBodyState
    extends State<promotion_screen_desktopBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PromotionProvider>().fetchActivePromotions();
      context.read<AnnouncementProvider>().fetchActiveAnnouncements();
    });
  }

  Widget _buildAnnouncementCarousel() {
    return Consumer<AnnouncementProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final announcements = provider.announcements
            .where((announcement) => announcement.imageUrl.isNotEmpty)
            .toList();

        if (announcements.isEmpty) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Text(
                provider.error ?? 'ยังไม่มีข่าวสารและประชาสัมพันธ์',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return AnnouncementCarousel(
          announcements: announcements,
          onTap: (announcement) {
            Navigator.pushNamed(
              context,
              '/announcement_detail_page',
              arguments: announcement,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(fit: StackFit.expand, children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "ข่าวสารและประชาสัมพันธ์",
                          style: TextStyle(
                            fontSize: Constants.fontSizeHeader,
                            fontWeight: Constants.fontWeightBold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnnouncementCarousel(),
                        const SizedBox(height: 20),
                        Text(
                          "โปรโมชั่นพิเศษ",
                          style: TextStyle(
                            fontSize: Constants.fontSizeHeader,
                            fontWeight: Constants.fontWeightBold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        BoxshowPromotionCard(
                          title: "พักผ่อนเหนือระดับที่เชียงราย",
                          description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                          bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                          price: "฿2,500",
                          textColor: Colors.black,
                          rating: 4.97,
                          reviewCount: 156,
                          imageUrl:
                              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                          onTap: () {},
                          onFavoriteChanged: (value) {},
                        ),
                        BoxshowPromotionCard(
                          title: "พักผ่อนเหนือระดับที่เชียงราย",
                          description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                          bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                          price: "฿2,500",
                          textColor: Colors.black,
                          rating: 4.97,
                          reviewCount: 156,
                          imageUrl:
                              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                          onTap: () {},
                          onFavoriteChanged: (value) {},
                        ),
                        BoxshowPromotionCard(
                          title: "พักผ่อนเหนือระดับที่เชียงราย",
                          description: "บ้านพักส่วนตัวพร้อมวิวภูเขา",
                          bedsInfo: "เตียงคู่ • 1 ห้องน้ำ",
                          price: "฿2,500",
                          textColor: Colors.black,
                          rating: 4.97,
                          reviewCount: 156,
                          imageUrl:
                              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                          onTap: () {},
                          onFavoriteChanged: (value) {},
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Topnavbar(
              widthFactor: 0.2,
              showBackButton: false,
            )),
        Positioned(bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
      ])),
    );
  }
}
