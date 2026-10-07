import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/promotionDetail_provider.dart';

class PromotionDetailScreenDesktopbody extends StatefulWidget {
  final String promoId;

  const PromotionDetailScreenDesktopbody({super.key, required this.promoId});

  @override
  State<PromotionDetailScreenDesktopbody> createState() =>
      _PromotionDetailScreenDesktopbodyState();
}

class _PromotionDetailScreenDesktopbodyState
    extends State<PromotionDetailScreenDesktopbody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<PromotiondetailProvide>()
          .fetchPromotionDetail(widget.promoId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Consumer<PromotiondetailProvide>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage.isNotEmpty) {
                return Center(child: Text(provider.errorMessage));
              }

              final promo = provider.promotion;
              if (promo == null) {
                return const Center(child: Text('ไม่พบข้อมูลโปรโมชั่น'));
              }

              return _buildContent(promo);
            },
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Topnavbar(
                widthFactor: 0.2,
              )),
          const Positioned(
              bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
        ]),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year + 543}";
  }

  Widget _buildContent(PromotionEntitise promo) {
    final remainingUses = promo.usageLimit != null
        ? (promo.usageLimit! - promo.usedCount).clamp(0, promo.usageLimit!)
        : null;
    final discountText = promo.discountType == 'percentage'
        ? "ลด ${promo.discountValue.toStringAsFixed(0)}%"
        : "ลด ฿${promo.discountValue.toStringAsFixed(0)}";
    final hasMaxDiscount =
        promo.discountType == 'percentage' && promo.maxDiscountAmount != null;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(Constants.borderRadius),
      child: AspectRatio(
        aspectRatio: 1,
        child: (promo.imageUrl != null && promo.imageUrl!.isNotEmpty)
            ? Image.network(
                promo.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[200]),
              )
            : Container(color: Colors.grey[200]),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          promo.title,
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, height: 1.4),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Constants.primaryColor,
              Constants.primaryColor.withOpacity(0.75),
            ]),
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_offer_outlined,
                  color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("สิทธิพิเศษ",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(discountText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  if (hasMaxDiscount)
                    Text(
                        "สูงสุด ฿${promo.maxDiscountAmount!.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: promo.code));
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('คัดลอกรหัสแล้ว')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Constants.primaryColor.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Text("รหัส", style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    promo.code,
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Icon(Icons.copy_rounded,
                    size: 18, color: Constants.primaryColor),
              ],
            ),
          ),
        ),
        if (promo.description != null && promo.description!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(promo.description!,
              style: const TextStyle(fontSize: 16, height: 1.7)),
        ],
        const SizedBox(height: 24),
        const Text("เงื่อนไขการใช้บริการ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F8),
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          child: Column(
            children: [
              if (promo.minBookingAmount > 0)
                _buildConditionRow(Icons.receipt_long,
                    "ยอดจองขั้นต่ำ ฿${promo.minBookingAmount.toStringAsFixed(0)}"),
              if (promo.startDate != null && promo.endDate != null)
                _buildConditionRow(
                  Icons.date_range,
                  "ใช้ได้ตั้งแต่วันที่ ${_formatDate(promo.startDate!)} "
                  "ถึง ${_formatDate(promo.endDate!)}",
                ),
              if (remainingUses != null)
                _buildConditionRow(
                  Icons.confirmation_number,
                  remainingUses > 0
                      ? "เหลือสิทธิ์การใช้งานอีก $remainingUses ครั้ง"
                      : "สิทธิ์การใช้งานหมดแล้ว",
                ),
              _buildConditionRow(
                  Icons.info_outline, "ไม่สามารถใช้ร่วมกับโปรโมชั่นอื่นได้",
                  isLast: true),
            ],
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 120),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: image),
                const SizedBox(width: 32),
                Expanded(flex: 5, child: details),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionRow(IconData icon, String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: Constants.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text,
                  style: const TextStyle(fontSize: 15, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }
}
