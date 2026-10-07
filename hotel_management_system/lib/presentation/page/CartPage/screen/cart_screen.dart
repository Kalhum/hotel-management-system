// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entitise/cart_item_entitise.dart';
import '../../../../util/function/login_flow.dart';
import '../../../../util/provider/cart_provider.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../homePage/companents/typeRoom_enum.dart';

String _formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

String _baht(double v) {
  final parts = v.toStringAsFixed(2).split('.');
  final intPart =
      parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  return '฿$intPart.${parts[1]}';
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await context.read<CartProvider>().load();
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถโหลดตะกร้าได้')),
        );
      }
    });
  }

  Future<void> _onCheckoutTap(BuildContext context) async {
    final canContinue = await ensureLoggedIn(
      context,
      redirectRoute: '/booking_form',
    );
    if (!canContinue || !context.mounted) return;
    Navigator.pushNamed(context, "/booking_form");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cart, _) {
            return Column(
              children: [
                const Topnavbar(widthFactor: 0.2),
                Expanded(
                  child: cart.isEmpty
                      ? const Center(child: Text('ยังไม่มีห้องพักในตะกร้า'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return _CartItemCard(
                              item: item,
                              onRemove: () => cart.removeItem(item.id),
                            );
                          },
                        ),
                ),
                if (!cart.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('รวมทั้งหมด',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(_baht(cart.totalPrice),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constants.primaryColor)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'ค่ามัดจำ (${(Constants.depositPercent * 100).toStringAsFixed(0)}%)',
                                style: const TextStyle(color: Colors.grey)),
                            Text(_baht(cart.depositAmount),
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Button(
                          text: 'ดำเนินการชำระเงิน',
                          onTap: () => _onCheckoutTap(context),
                          color: Constants.secondaryColor,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemEntitise item;
  final VoidCallback onRemove;

  const _CartItemCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.imageUrl == null
                ? Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  )
                : Image.network(
                    item.imageUrl!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ห้องหมายเลข ${item.roomId} (${item.roomType == RoomType.rooms ? 'ห้องพัก' : 'บ้านพัก'})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                    '${_formatDate(item.checkIn)} - ${_formatDate(item.checkOut)} (${item.nights} คืน)',
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                    'ผู้ใหญ่ ${item.adultCount} คน  เด็ก ${item.childCount} คน',
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
                if (item.extraBedType != null)
                  Text(
                      'เตียงเสริม: ${item.extraBedType!.name} x ${item.extraBedQuantity}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(_baht(item.totalPrice),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
