import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/listPage/list_screen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String _genDer = "ชาย"; // ตัวแปรค่าเริ่มต้น radio

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          SizedBox(
            height: 500,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Constants.padding),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    createInputField(InputFieldType.idCardNumber),
                    createInputField(InputFieldType.fullName),
                    createInputField(InputFieldType.gender,
                        selectedValue: _genDer, onChanged: (value) {
                      setState(() {
                        _genDer = value.toString();
                      });
                    }),
                    createInputField(InputFieldType.address),
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
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Constants.secondaryColor,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
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
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                        text: "ตกลง",
                        onTap: () {
                          showSuccessDialog(
                              context,
                              "Check in แล้ว",
                              "Check in สำเร็จแล้ว ตรวจสภาพห้องก่อนเข้าพัก",
                              ListScreen(
                                checkInStatus: true,
                              ),
                              "รหัสเข้าห้อง[ 839201 ]",
                              "ใช้ได้ตั้งแต่: 15 ก.พ. 14:00",
                              "หมดอายุ: 17 ก.พ. 12:00");
                        },
                        color: Constants.secondaryColor),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 0, right: 0, left: 0, child: Topnavbar()),
          Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar())
        ]),
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
