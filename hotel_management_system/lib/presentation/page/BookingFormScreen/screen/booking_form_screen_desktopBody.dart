// booking_form_screen_desktopBody.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/booking_form_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/payment_remote.dart';
import 'package:hotel_management_system/data/repositorise/payment_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/payment_usecase.dart';
import 'package:hotel_management_system/util/provider/cart_provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/components/button/button.dart';
import 'package:hotel_management_system/presentation/page/BookingFormScreen/provider/Booking_form_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../../../../util/widget/core/network/dio_client.dart';

class BookingFormScreenDesktopBody extends StatefulWidget {
  const BookingFormScreenDesktopBody({super.key});

  @override
  State<BookingFormScreenDesktopBody> createState() =>
      _BookingFormScreenDesktopBodyState();
}

class _BookingFormScreenDesktopBodyState
    extends State<BookingFormScreenDesktopBody> {
  late final BookingFormScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final bookingUsecase = BookingFormUsecase(
      BookingFormRepositoriseImpl(
          BookingFormRemoteDataSourceImpl(DioClient.dio),
          HomeRemoteDataSourceImpl(DioClient.dio)),
    );
    final paymentUsecase = PaymentUsecase(
        PaymentRepositoriseImpl(PaymentRemoteDataSourceImpl(DioClient.dio)));
    _provider = BookingFormScreenProvider(bookingUsecase, paymentUsecase);
    _provider.addListener(_onProviderChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().user;
      _provider.prefillUserInfo(user);
    });
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _provider.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    _handleBookingResult();
    _handleSaveQRResult();
  }

  void _handleBookingResult() {
    if (_provider.status == BookingFormStatus.success) {
      context.read<CartProvider>().clear();
      showSuccessDialog(
        context,
        "จองห้องพัก",
        "เราได้รับข้อมูลการจองห้องพักของคุณเรียบร้อยแล้ว",
        "/list_page",
        "",
        "",
        "",
      );
      _provider.resetStatus();
    } else if (_provider.status == BookingFormStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_provider.errorMessage), backgroundColor: Colors.red),
      );
      _provider.resetStatus();
    }
  }

  void _handleSaveQRResult() {
    if (_provider.saveQRStatus == SaveQRStatus.success) {
      showSuccessSaveQRcodeDialog(
          context, "บันทึก QRcode แล้ว", "QRcode ถูกบันทึกลงในคลังรูปภาพแล้ว");
      _provider.resetSaveQRStatus();
    } else if (_provider.saveQRStatus == SaveQRStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_provider.saveQRErrorMessage),
            backgroundColor: Colors.red),
      );
      _provider.resetSaveQRStatus();
    }
  }

  String _formatBaht(double value) => "${value.toStringAsFixed(2)} บาท";

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _buildCartSummary(CartProvider cart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ห้อง ${item.roomId} (${_formatDate(item.checkIn)} - ${_formatDate(item.checkOut)}, ${item.nights} คืน)',
                      style: TextStyle(fontSize: Constants.fontSizeBody),
                    ),
                  ),
                  Text(_formatBaht(item.totalPrice),
                      style: TextStyle(fontSize: Constants.fontSizeBody)),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ราคาค่าเช่าซื้อทั้งหมด",
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      fontWeight: FontWeight.bold)),
              Text(_formatBaht(cart.totalPrice),
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ค่ามัดจำที่ต้องชำระตอนนี้ (30%)",
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      color: Colors.red[600])),
              Text(_formatBaht(cart.depositAmount),
                  style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600])),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, _) => Scaffold(
        backgroundColor: Constants.bgcolor,
        body: SafeArea(
          child: Column(
            children: [
              Topnavbar(
                widthFactor: 0.1,
              ),
              Expanded(
                child: Consumer2<BookingFormScreenProvider, CartProvider>(
                  builder: (context, provider, cart, _) {
                    if (provider.qrPayloadStatus == QrPayloadStatus.initial &&
                        cart.items.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => provider.loadQrPayload(cart.items));
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- Header ---
                              Center(
                                child: Text(
                                  'จองห้องพัก (${cart.itemCount} ห้อง)',
                                  style: TextStyle(
                                      fontSize: Constants.fontSizeHeader,
                                      fontWeight: Constants.fontWeightBold),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // --- 2 คอลัมน์ ---
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // --- Left: ฟอร์ม ---
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.06),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ข้อมูลผู้จอง',
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeTitle,
                                                  fontWeight: Constants
                                                      .fontWeightBold)),
                                          const SizedBox(height: 20),
                                          createInputField(
                                              InputFieldType.fullName,
                                              controller:
                                                  provider.fullNameController),
                                          createInputField(InputFieldType.email,
                                              controller:
                                                  provider.emailController),
                                          createInputField(
                                              InputFieldType.phoneNumber,
                                              controller:
                                                  provider.phoneController),
                                          const SizedBox(height: 20),
                                          Text('รายการห้องพักในตะกร้า',
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeTitle,
                                                  fontWeight: Constants
                                                      .fontWeightBold)),
                                          const SizedBox(height: 12),
                                          _buildCartSummary(cart),
                                          const SizedBox(height: 20),
                                          Text('หลักฐานการโอนเงิน',
                                              style: TextStyle(
                                                  fontSize:
                                                      Constants.fontSizeTitle,
                                                  fontWeight: Constants
                                                      .fontWeightBold)),
                                          const SizedBox(height: 12),
                                          createInputField(
                                            InputFieldType.paymentSlip,
                                            imageFile:
                                                provider.paymentSlipImage,
                                            onTap: provider.pickSlipImage,
                                          ),
                                          const SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Button(
                                              text: provider.isLoading
                                                  ? "กำลังจอง..."
                                                  : "จองห้องพัก",
                                              onTap: provider.isLoading ||
                                                      cart.isEmpty
                                                  ? () {}
                                                  : () =>
                                                      provider.submitBooking(
                                                          items: cart.items),
                                              color: Constants.secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 24),

                                  // --- Right: QR + ข้อมูลธนาคาร ---
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.06),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text('ชำระค่ามัดจำ',
                                                  style: TextStyle(
                                                      fontSize: Constants
                                                          .fontSizeTitle,
                                                      fontWeight: Constants
                                                          .fontWeightBold)),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Constants.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .borderRadius),
                                                ),
                                                child: provider.qrPayload !=
                                                        null
                                                    ? QrImageView(
                                                        data:
                                                            provider.qrPayload!,
                                                        size: 240,
                                                        backgroundColor:
                                                            Colors.white,
                                                      )
                                                    : const SizedBox(
                                                        width: 240,
                                                        height: 240,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      ),
                                              ),
                                              const SizedBox(height: 16),
                                              SizedBox(
                                                width: double.infinity,
                                                child: OutlinedButton.icon(
                                                  onPressed: provider
                                                              .qrPayload !=
                                                          null
                                                      ? () => provider
                                                          .saveQRCode(cart
                                                              .depositAmount)
                                                      : null,
                                                  icon: const Icon(
                                                      Icons.download),
                                                  label: const Text(
                                                      "บันทึก QRcode"),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        Constants.primaryColor,
                                                    side: BorderSide(
                                                        color: Constants
                                                            .primaryColor),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Constants
                                                              .borderRadius),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
