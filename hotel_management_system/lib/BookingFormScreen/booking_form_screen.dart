import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/homePage/home_screen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:hotel_management_system/core/constants.dart';

class BookingFormScreen extends StatefulWidget {
  final int roomId;

  BookingFormScreen({super.key, required this.roomId});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _myGender = "ชาย"; // ตัวแปรค่าเริ่มต้น radio

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  File? _idCardImage;
  File? _paymentSlipImage; // ตัวแปรเก็บรูปภาพ
  late SignatureController _sigController;

  @override
  void initState() {
    super.initState();
    _sigController =
        SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Center(
                        child: Text('จองห้องพักหมายเลข ${widget.roomId}',
                            style: TextStyle(
                                fontSize: Constants.fontSizeHeader,
                                fontWeight: Constants.fontWeightBold)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('กรุณากรอกข้อมูล',
                          style: TextStyle(
                            fontSize: Constants.fontSizeBody,
                          )),
                      const SizedBox(height: 20),
                      createInputField(InputFieldType.fullName,
                          controller: _nameController),
                      createInputField(InputFieldType.idCardNumber,
                          controller: _idController),
                      createInputField(InputFieldType.gender,
                          selectedValue: _myGender, onChanged: (value) {
                        setState(() {
                          _myGender = value.toString();
                        });
                      }),
                      createInputField(InputFieldType.address),
                      createInputField(InputFieldType.numberOfGuests),
                      createInputField(InputFieldType.numberOfNights),
                      const SizedBox(height: 20),
                      Text('รูปบัตรประชาชน',
                          style: TextStyle(fontSize: Constants.fontSizeBody)),
                      createInputField(InputFieldType.idCard,
                          imageFile: _idCardImage, onTap: _takeIdCardPhoto),
                      const SizedBox(height: 20),
                      Text('ลายเซ็นยืนยัน',
                          style: TextStyle(fontSize: Constants.fontSizeBody)),
                      createInputField(InputFieldType.signature,
                          sigController: _sigController),
                      Text(
                        "จ่ายเงิน",
                        style: TextStyle(fontSize: Constants.fontSizeBody),
                      ),
                      Center(
                        child: Container(
                          width: screenWidth,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Constants.secondaryColor,
                              borderRadius: BorderRadius.circular(
                                  Constants.borderRadius)),
                          child: Column(
                            children: [
                              Image.asset("assets/images/QRcodePay.png"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: _saveQRCode,
                        child: Center(
                          child: Text(
                            "บันทึก QRcode",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: Constants.fontSizeBody,
                              decoration: TextDecoration
                                  .underline, // เพิ่มขีดเส้นใต้ให้ดูเหมือนปุ่ม
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("หลักฐานการชำระเงิน",
                          style: TextStyle(fontSize: Constants.fontSizeBody)),
                      const SizedBox(height: 10),
                      createInputField(InputFieldType.paymentSlip,
                          imageFile: _paymentSlipImage,
                          onTap: _pickSlipImage // เรียกฟังก์ชันเปิด gallery
                          ),
                      const SizedBox(height: 30),
                      Center(
                        child: Button(
                            text: "จองห้องนี้",
                            onTap: () {
                              showSuccessDialog(
                                  context,
                                  "จองห้องนี้",
                                  "เราได้รับข้อมูลการจองห้องพักเลขที่ ${widget.roomId} เรียบร้อยแล้ว",
                                  HomeScreen());

                              // if (_formKey.currentState!.validate()) {
                              //   if (_idCardImage == null) {
                              //     // แสดง popup error
                              //     return;
                              //   }
                              //   if (_sigController.isEmpty) {
                              //     // แสดง popup error
                              //     return;
                              //   }
                              //   showSuccessDialog(context, "จองสำเร็จ!",
                              //       "เราได้รับข้อมูลการจองห้องพักเลขที่ ${widget.roomId} เรียบร้อยแล้ว");
                              // }
                            },
                            color: Constants.secondaryColor),
                      ),
                      SizedBox(
                        height: 120,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: Topnavbar()),
            Positioned(bottom: 0, left: 0, right: 0, child: Bottomnavbar())
          ],
        ),
      ),
    );
  }

  // funcion ถ่ายรูปภาพ
  Future<void> _takeIdCardPhoto() async {
    //1. ขออนุญาตกล้องก่อน
    var status = await Permission.camera.request();

    if (status.isGranted) {
      //2. ถ้าอนุญาตแล้วค่อยเปิดกล้อง
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) setState(() => _idCardImage = File(photo.path));
    } else if (status.isPermanentlyDenied) {
      // กรณีผู้ใช้กดปฏิเสธแบบถาวร ให้ส่งไปหน้าตั้งค่า
      openAppSettings();
    }
  }

  // Future<void> _takeIdCardPhoto() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  //   if (photo != null) setState(() => _idCardImage = File(photo.path));
  // }

  // function สำหรับเลือกรูปจากคลังภาพ
  Future<void> _pickSlipImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _paymentSlipImage = File(image.path);
      });
    }
  }

  // function บันทึกรูปภาพ
  Future<void> _saveQRCode() async {
    try {
      // 1. ดึงไฟล์รูปจาก Assets แปลงเป็น Byte
      ByteData byteData = await rootBundle.load("assets/images/QRcodePay.png");
      Uint8List bytes = byteData.buffer.asUint8List();

      // 2. สั่งบันทึกลง Gallery
      final result = await ImageGallerySaver.saveImage(bytes,
          quality: 100,
          name: "Hotel_QR_Payment_${DateTime.now().millisecondsSinceEpoch}");

      // 3. แจ้งเตือนผู้ใช้
      if (result['isSuccess']) {
        showSuccessSaveQRcodeDialog(context, "บันทึก QRcode แล้ว",
            "QRcode ถูกบันทึกลงในคลังรูปภาพของท่านแล้ว");
      } else {
        throw Exception("Save failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("เกิดข้อผิดพลาด: $e"), backgroundColor: Colors.red),
      );
    }
  }
}

void showSuccessSaveQRcodeDialog(
    BuildContext context, String textTitle, String textBody) {
  showDialog(
    context: context,
    barrierDismissible: false, // ป้องกันการกดนอก Dialog เพื่อปิด
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ให้ Dialog ขนาดพอดีกับเนื้อหา
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                textTitle,
                style: TextStyle(
                  fontSize: Constants.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textBody,
                style: TextStyle(
                  fontSize: Constants.fontSizeBody,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Dialog
                  },
                  child: const Text('ตกลง',
                      style: TextStyle(
                        fontSize: Constants.fontSizeBody,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
