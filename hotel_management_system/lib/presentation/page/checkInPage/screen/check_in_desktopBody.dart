// check_in_screen_desktop_body.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/check_in_remote.dart';
import 'package:hotel_management_system/data/repositorise/check_in_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:hotel_management_system/util/widget/core/network/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../data/data_source/remote_data_source/promotion_remote.dart';
import '../../../../data/repositorise/promotion_repositorise.dart';
import '../../../../domain/use_case/promotion_usecase.dart';
import '../../../../data/data_source/remote_data_source/payment_remote.dart';
import '../../../../data/repositorise/payment_repositorise.dart';
import '../../../../domain/use_case/payment_usecase.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../../../../util/widget/core/form_enum.dart';
import '../provider/check_in_screen_provider.dart';
import '../../../../util/widget/components/dialog/dialog_helper.dart';
import '../../../../data/data_source/remote_data_source/user_profile_remote.dart';
import '../../../../data/repositorise/user_profile_respositorise.dart';
import '../../../../domain/use_case/user_profile_usecase.dart';

class CheckInScreenDesktopBody extends StatefulWidget {
  final String? bookingID;
  final double totalPrice;
  final double depositAmount;

  const CheckInScreenDesktopBody({
    super.key,
    this.bookingID,
    this.totalPrice = 0,
    this.depositAmount = 0,
  });

  @override
  State<CheckInScreenDesktopBody> createState() =>
      _CheckInScreenDesktopBodyState();
}

class _CheckInScreenDesktopBodyState extends State<CheckInScreenDesktopBody> {
  late final CheckInScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    final checkInUsecase = CheckInUsecase(
        CheckInRepositoriseImpl(CheckInRemoteDataSourceImpl(DioClient.dio)));
    final promotionUsecase = PromotionUsecase(PromotionRepositoriseImpl(
        PromotionRemoteDataSourceImpl(DioClient.dio)));
    final paymentUsecase = PaymentUsecase(
        PaymentRepositoriseImpl(PaymentRemoteDataSourceImpl(DioClient.dio)));
    _provider =
        CheckInScreenProvider(checkInUsecase, promotionUsecase, paymentUsecase);
    _provider.addListener(_onProviderChanged);
    _provider.setPricing(
      totalPrice: widget.totalPrice,
      depositAmount: widget.depositAmount,
      bookingId: widget.bookingID,
    );
    _provider.loadCoupons();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProfileUseCase(
        repository: UserProfileRepositoryImpl(
          remoteDataSource: UserProfileRemoteDataSourceImpl(),
        ),
      ).getMyProfile().then(_provider.prefillProfile).catchError((_) {});
    });
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _provider.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    _handleCheckInResult();
    _handleSaveQRResult();
  }

  void _handleCheckInResult() {
    if (_provider.status == CheckInStatus.success) {
      showSuccessDialog(
        context,
        "Check in แล้ว",
        "Check in สำเร็จแล้ว ตรวจสภาพห้องก่อนเข้าพัก",
        "/list_page",
        "รหัสเข้าห้อง[ 839201 ]",
        "ใช้ได้ตั้งแต่: 15 ก.พ. 14:00",
        "หมดอายุ: 17 ก.พ. 12:00",
      );
      _provider.resetStatus();
    } else if (_provider.status == CheckInStatus.error) {
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

  String _formatBaht(double value) {
    return "${value.toStringAsFixed(2)} บาท";
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? Constants.fontSizeBody : Constants.fontSizeBody - 2,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: amount < 0 ? Colors.red[400] : Colors.black87,
    );
    final displayAmount =
        amount < 0 ? "-${_formatBaht(amount.abs())}" : _formatBaht(amount);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(displayAmount, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: Column(
            children: [
              Topnavbar(widthFactor: 0.1),
              Expanded(
                child: Consumer<CheckInScreenProvider>(
                  builder: (context, provider, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text("เช็คอินเข้าพัก",
                                    style: TextStyle(
                                        fontSize: Constants.fontSizeHeader,
                                        fontWeight: Constants.fontWeightBold)),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        _buildCard(
                                          title: "ข้อมูลผู้เข้าพัก",
                                          icon: Icons.person_outline,
                                          child: Column(
                                            children: [
                                              createInputField(
                                                  InputFieldType.idCardNumber,
                                                  controller: provider
                                                      .idCardNumberController),
                                              createInputField(
                                                  InputFieldType.fullName,
                                                  controller: provider
                                                      .fullNameController),
                                              createInputField(
                                                InputFieldType.gender,
                                                selectedValue: provider.gender,
                                                onChanged: (value) =>
                                                    provider.setGender(
                                                        value.toString()),
                                              ),
                                              createInputField(
                                                  InputFieldType.address,
                                                  controller: provider
                                                      .addressController),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildCard(
                                          title: "รูปบัตรประชาชน",
                                          icon: Icons.credit_card_outlined,
                                          child: createInputField(
                                            InputFieldType.idCard,
                                            imageFile: provider.idCardImage,
                                            onTap: () => provider
                                                .takeIdCardPhoto(context),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildCard(
                                          title: "ลายเซ็นยืนยัน",
                                          icon: Icons.draw_outlined,
                                          child: createInputField(
                                            InputFieldType.signature,
                                            sigController:
                                                provider.sigController,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildCard(
                                          title: "หลักฐานการชำระเงิน",
                                          icon: Icons.receipt_outlined,
                                          child: createInputField(
                                            InputFieldType.paymentSlip,
                                            imageFile:
                                                provider.paymentSlipImage,
                                            onTap: provider.pickSlipImage,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        provider.isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Button(
                                                text: "ยืนยันการเช็คอิน",
                                                onTap: () =>
                                                    provider.submitCheckIn(
                                                        widget.bookingID ?? ""),
                                                color: Constants.secondaryColor,
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        // ================= คูปองส่วนลด =================
                                        _buildCard(
                                          title: "คูปองส่วนลด",
                                          icon: Icons.local_offer_outlined,
                                          child: provider.couponLoadStatus ==
                                                  CouponLoadStatus.loading
                                              ? const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12),
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                )
                                              : provider.couponLoadStatus ==
                                                      CouponLoadStatus.error
                                                  ? Text(
                                                      provider.couponLoadError,
                                                      style: const TextStyle(
                                                          color: Colors.red))
                                                  : provider.coupons.isEmpty
                                                      ? Text(
                                                          "ไม่มีคูปองที่ใช้ได้ในขณะนี้",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[500]))
                                                      : Column(
                                                          children: [
                                                            RadioListTile<int?>(
                                                              value: null,
                                                              groupValue: provider
                                                                  .selectedCoupon
                                                                  ?.userPromotionId,
                                                              title: const Text(
                                                                  "ไม่ใช้คูปอง"),
                                                              onChanged: (value) =>
                                                                  provider
                                                                      .selectCoupon(
                                                                          null),
                                                            ),
                                                            ...provider.coupons
                                                                .map((coupon) {
                                                              return RadioListTile<
                                                                  int?>(
                                                                value: coupon
                                                                    .userPromotionId,
                                                                groupValue: provider
                                                                    .selectedCoupon
                                                                    ?.userPromotionId,
                                                                title: Text(
                                                                    coupon
                                                                        .title),
                                                                subtitle: Text(
                                                                    coupon
                                                                        .code),
                                                                onChanged: (value) =>
                                                                    provider
                                                                        .selectCoupon(
                                                                            value),
                                                              );
                                                            }),
                                                          ],
                                                        ),
                                        ),
                                        const SizedBox(height: 20),
                                        // ================= สรุปค่าใช้จ่าย =================
                                        _buildCard(
                                          title: "สรุปค่าใช้จ่าย",
                                          icon: Icons.receipt_long_outlined,
                                          child: Column(
                                            children: [
                                              _priceRow("ค่าเช่าซื้อทั้งหมด",
                                                  provider.totalPrice),
                                              _priceRow("หัก ค่าหมัดจำ",
                                                  -provider.depositAmount),
                                              if (provider.discountAmount > 0)
                                                _priceRow(
                                                  "หัก ส่วนลดคูปอง (${provider.selectedCoupon?.title ?? ''})",
                                                  -provider.discountAmount,
                                                ),
                                              const Divider(height: 24),
                                              _priceRow(
                                                "ยอดที่ต้องชำระ",
                                                provider.amountDue,
                                                isTotal: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildCard(
                                          title: "ชำระค่าบริการ",
                                          icon: Icons.qr_code_outlined,
                                          child: Column(
                                            children: [
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
                                                          .saveQRCode(provider
                                                              .amountDue)
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
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(Constants
                                                                .borderRadius)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
              Bottomnavbar(isVisibleHousekeeper: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Constants.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: Constants.fontSizeTitle,
                      fontWeight: Constants.fontWeightBold,
                      color: Constants.primaryColor)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
