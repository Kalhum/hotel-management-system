import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';
import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/components/button/button.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/listPage/list_screen.dart';
import 'package:image_picker/image_picker.dart';

class RoomConditionCheckScreen extends StatefulWidget {
  const RoomConditionCheckScreen({super.key});

  @override
  State<RoomConditionCheckScreen> createState() =>
      _RoomConditionCheckScreenState();
}

class _RoomConditionCheckScreenState extends State<RoomConditionCheckScreen> {
  final Map<String, bool> _checkStatus = {
    "เตียงนอน": false,
    "เครื่องปรับอากาศ": false,
    "ตู้เย็น / มินิบาร์": false,
    "ทีวี และ รีโมท": false,
  };
  File? _paymentSlipImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: SizedBox.expand(
          // ใช้ expand เพื่อให้ Stack เต็มจอแน่นอน
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 100, // เว้นที่ให้ Topnavbar
                  bottom: 100, // เว้นที่ให้ Bottomnavbar
                  left: Constants.padding,
                  right: Constants.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ตรวจเช็ค เฟอร์นิเจอร์",
                      style: TextStyle(
                        fontSize: Constants.fontSizeHeader,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ส่วนแสดงรูปภาพและ Checkbox
                    _buildFurnitureItem(
                        "เตียงนอน", 'assets/images/furnitures/bed.jpg'),
                    _buildFurnitureItem("เครื่องปรับอากาศ",
                        'assets/images/furnitures/airconditioner.jpg'),
                    _buildFurnitureItem("ตู้เย็น / มินิบาร์",
                        'assets/images/furnitures/fridge.jpg'),
                    _buildFurnitureItem(
                        "ทีวี และ รีโมท", 'assets/images/furnitures/TV.jpg'),
                    SizedBox(
                      height: 20,
                    ),

                    Button(
                      text: "ยืนยันสภาพห้องปกติ",
                      onTap: () {
                        showSuccessDialog(
                            context,
                            "สำเร็จ",
                            "คุณได้ยืนยันสภาพห้องแล้ว",
                            ListScreen(
                              roomConCheck: true,
                            ),"","","");
                      },
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Button(
                      text: "แจ้งของชำรุด",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) =>
                                  FractionallySizedBox(
                                heightFactor: 0.9,
                                child: SingleChildScrollView(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("แนบรูปของชำรุด",
                                          style: TextStyle(
                                              fontSize:
                                                  Constants.fontSizeBody)),
                                      const SizedBox(height: 10),
                                      createInputField(
                                          InputFieldType.paymentSlip,
                                          imageFile: _paymentSlipImage,
                                          onTap: () async {
                                        await _pickSlipImage();
                                        setModalState(() {});
                                      }, textLabel: "เพิ่มรูป"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        // controller: controller,
                                        decoration: InputDecoration(
                                          labelText: "หมายเหตุ",
                                          labelStyle: TextStyle(
                                              fontSize: Constants.fontSizeBody,
                                              fontWeight: FontWeight.w500,
                                              color: Constants.fontLabelColor),
                                          hintText: "หมายเหตุ",
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor:
                                              Constants.inputFieldFillColor,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.borderRadius),
                                            borderSide: const BorderSide(
                                                color: Constants.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.borderRadius),
                                            borderSide: const BorderSide(
                                                color: Constants
                                                    .inputFieldBorderColor,
                                                width: 3.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Button(
                                          text: "ยืนยัน",
                                          onTap: () {},
                                          color: Colors.green),
                                      SizedBox(
                                        height: 80,
                                      )
                                    ],
                                  ),
                                )),
                              ),
                            );
                          },
                        );
                      },
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              const Positioned(top: 0, left: 0, right: 0, child: Topnavbar()),
              const Positioned(
                  bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
            ],
          ),
        ),
      ),
    );
  }

// ฟังก์ชันสร้าง Item ที่มีทั้งรูปและ Checkbox
  Widget _buildFurnitureItem(String title, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey), // ถ้าไม่มีรูปจะไม่พัง
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CheckboxListTile(
                title: Text(title,
                    style: const TextStyle(fontSize: Constants.fontSizeBody)),
                value: _checkStatus[title],
                onChanged: (bool? val) {
                  setState(() {
                    _checkStatus[title] = val!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

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
}
