// booking_form_screen_mobileBody.dart
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
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../provider/booking_form_provider_route.dart';
import '../../../../util/widget/core/network/dio_client.dart';

class BookingFormScreenMobileBody extends StatefulWidget {
  const BookingFormScreenMobileBody({super.key});

  @override
  State<BookingFormScreenMobileBody> createState() =>
      _BookingFormScreenMobileBodyState();
}

class _BookingFormScreenMobileBodyState
    extends State<BookingFormScreenMobileBody> {
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

  // สรุปห้องพักทุกรายการในตะกร้า + ราคาเต็ม + ค่ามัดจำ 30%
  Widget _buildPriceSummary(CartProvider cart) {
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
        backgroundColor: Constants.white,
        floatingActionButton:
            Consumer2<BookingFormScreenProvider, CartProvider>(
          builder: (context, provider, cart, _) {
            return FloatingActionButton.extended(
              onPressed: provider.isLoading || cart.isEmpty
                  ? null
                  : () => provider.submitBooking(items: cart.items),
              label: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("จองห้องพัก"),
            );
          },
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Consumer2<BookingFormScreenProvider, CartProvider>(
                  builder: (context, provider, cart, _) {
                    if (provider.qrPayloadStatus == QrPayloadStatus.initial &&
                        cart.items.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => provider.loadQrPayload(cart.items));
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              'จองห้องพัก (${cart.itemCount} ห้อง)',
                              style: TextStyle(
                                  fontSize: Constants.fontSizeHeader,
                                  fontWeight: Constants.fontWeightBold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('กรุณากรอกข้อมูล',
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          const SizedBox(height: 20),
                          createInputField(InputFieldType.fullName,
                              controller: provider.fullNameController),
                          createInputField(InputFieldType.email,
                              controller: provider.emailController),
                          createInputField(InputFieldType.phoneNumber,
                              controller: provider.phoneController),
                          const SizedBox(height: 20),
                          _buildPriceSummary(cart),
                          const SizedBox(height: 20),
                          Text("จ่ายค่ามัดจำผ่าน QR code",
                              style:
                                  TextStyle(fontSize: Constants.fontSizeBody)),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Constants.secondaryColor,
                                borderRadius: BorderRadius.circular(
                                    Constants.borderRadius),
                              ),
                              child: provider.qrPayload != null
                                  ? QrImageView(
                                      data: provider.qrPayload!,
                                      size: 240,
                                      backgroundColor: Colors.white,
                                    )
                                  : const SizedBox(
                                      width: 240,
                                      height: 240,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: provider.qrPayload != null
                                  ? () =>
                                      provider.saveQRCode(cart.depositAmount)
                                  : null,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Constants.borderRadius),
                                ),
                                child: Text(
                                  "บันทึก QRcode",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Constants.fontSizeBody),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          createInputField(
                            InputFieldType.paymentSlip,
                            imageFile: provider.paymentSlipImage,
                            onTap: provider.pickSlipImage,
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Topnavbar(widthFactor: 0.2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
