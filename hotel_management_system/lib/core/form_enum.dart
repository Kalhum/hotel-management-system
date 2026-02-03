import 'package:flutter/material.dart';
import 'package:hotel_management_system/core/constants.dart';

enum InputFieldType {
  username,
  password,
  email,
  phoneNumber,
  checkInDate,
  checkOutDate,
  roomNumber,
  guestCount,
  specialRequest, // Multiline
}

Widget createInputField(InputFieldType type) {
  switch (type) {
    case InputFieldType.username:
      return _buildBaseTextField(
        label: "ชื่อผู้ใช้",
        icon: Icons.person,
        hint: "กรอกชื่อ-นามสกุล",
      );
    case InputFieldType.password:
      return _buildBaseTextField(
        label: "รหัสผ่าน",
        icon: Icons.lock,
        isPassword: true,
      );
    case InputFieldType.email:
      return _buildBaseTextField(
        label: "อีเมล",
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
      );
    case InputFieldType.phoneNumber:
      return _buildBaseTextField(
        label: "เบอร์โทรศัพท์",
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
      );
    case InputFieldType.specialRequest:
      return _buildBaseTextField(
        label: "ความต้องการเพิ่มเติม",
        icon: Icons.note,
        maxLines: 3, // ขยายช่องให้พิมพ์ได้หลายบรรทัด
      );

    default:
      return const SizedBox.shrink();
  }
}

// ตกแต่ง Input Field 
Widget _buildBaseTextField({
  required String label,
  required IconData icon,
  String? hint,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Constants.padding),
    child: TextField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: Constants.fontSizeBody,
            fontWeight: FontWeight.w500,
            color: Constants.fontLabelColor),
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Constants.colorIcon,
          size: 25,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: Constants.inputFieldFillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: const BorderSide(color: Constants.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide:
              const BorderSide(color: Constants.inputFieldBorderColor, width: 3.0),
        ),
      ),
    ),
  );
}
