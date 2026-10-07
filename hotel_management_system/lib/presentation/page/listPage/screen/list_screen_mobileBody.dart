// list_screen_mobileBody.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/provider/user_provider.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';
import 'boxListCompanent.dart';
import 'infoAbout.dart';

class ListScreenMobileBody extends StatefulWidget {
  const ListScreenMobileBody({super.key});

  @override
  State<ListScreenMobileBody> createState() => _ListScreenMobileBodyState();
}

class _ListScreenMobileBodyState extends State<ListScreenMobileBody> {
  Future<void> _cancelBooking(String bookingId) async {
    var reasonText = '';
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยกเลิกการจอง'),
        content: TextField(
          maxLines: 3,
          onChanged: (value) => reasonText = value,
          decoration: const InputDecoration(
            labelText: 'เหตุผลการยกเลิก',
            hintText: 'กรุณาระบุเหตุผล',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              if (reasonText.trim().isEmpty) return;
              Navigator.pop(dialogContext, reasonText.trim());
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
    if (reason == null || !mounted) return;
    await context.read<ListScreenProvider>().cancelBooking(bookingId, reason);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLogin = context.read<UserProvider>().isLogin;

      if (!isLogin) {
        // ยังไม่ login → เด้งไปหน้า login แทนที่จะยิง API แล้ว crash
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      context.read<ListScreenProvider>().getBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    child: Consumer<ListScreenProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final bookingList = provider.bookingList;

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(Constants.padding),
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                const Row(
                                  children: [
                                    Text("รายการของฉัน",
                                        style: TextStyle(
                                            fontSize:
                                                Constants.fontSizeHeader)),
                                  ],
                                ),
                                if (bookingList.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: Text(
                                      "ไม่มีรายการ",
                                      style: TextStyle(
                                          fontSize: Constants.fontSizeBody,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                                ...bookingList.map((booking) {
                                  return Boxlistcompanent(
                                    roomNumber: booking.roomId,
                                    payamout: booking.totalPrice ?? 0,
                                    keyBooking: booking.bookingId,
                                    status: booking.status,
                                    textStatus: booking.textStatus,
                                    statusColor: booking.statusColor,
                                    statusChekin: booking.checkInStatus,
                                    statusCheckout: booking.checkOutStatus,
                                    statusConCheck: booking.statusConCheck,
                                    roomKey: booking.roomKey,
                                    cancelReason: booking.cancelReason,
                                    onCancel: booking.checkInStatus != true &&
                                            booking.checkOutStatus != true &&
                                            ![
                                              'CANCELLED_BY_USER',
                                              'CANCELLED_BY_ADMIN',
                                              'REJECTED'
                                            ].contains(booking.status)
                                        ? () =>
                                            _cancelBooking(booking.bookingId)
                                        : null,
                                    onCheckOut: () async {
                                      final success = await context
                                          .read<ListScreenProvider>()
                                          .checkOutBooking(booking.bookingId);
                                      if (!success) {
                                        throw Exception(
                                            "เช็คเอาท์ไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
                                      }
                                    },
                                    onSubmitReview: (rating, comment) async {
                                      // เพิ่ม
                                      final success = await context
                                          .read<ListScreenProvider>()
                                          .submitReview(
                                            bookingId: booking.bookingId,
                                            rating: rating,
                                            comment: comment,
                                          );
                                      if (!success) {
                                        throw Exception(
                                            "ส่งรีวิวไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
                                      }
                                    },
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        showDragHandle: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        backgroundColor: Colors.white,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: SingleChildScrollView(
                                              child: Infoabout(
                                                bookingId: booking.bookingId,
                                                status: booking.bookingStatus,
                                                checkInStatus:
                                                    booking.checkInStatus,
                                                checkOutStatus:
                                                    booking.checkOutStatus,
                                                doNotDisturb:
                                                    booking.doNotDisturb,
                                                isUpdatingDoNotDisturb: provider
                                                    .isUpdatingDoNotDisturb(
                                                        booking.bookingId),
                                                onDoNotDisturbChanged:
                                                    (enabled) => provider
                                                        .setDoNotDisturb(
                                                            booking.bookingId,
                                                            enabled),
                                                customerName:
                                                    booking.customerName,
                                                phone: booking.phone,
                                                email: booking.email,
                                                roomId: booking.roomId,
                                                checkIn: booking.checkIn,
                                                checkOut: booking.checkOut,
                                                roomsCount: booking.roomsCount,
                                                personCount:
                                                    booking.personCount,
                                                slipUrl: booking.slipUrl,
                                                remainingAmount:
                                                    booking.remainingAmount,
                                                roomKey: booking.roomKey,
                                                cancelReason:
                                                    booking.cancelReason,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }),
                                const SizedBox(height: 150),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Topnavbar(
                        widthFactor: 0.2,
                      )),
                  const Positioned(
                      bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
