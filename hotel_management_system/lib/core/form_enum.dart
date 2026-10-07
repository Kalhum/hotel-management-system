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
  conformPassword,
  gender, // เพิ่มเพศ
  roomType, // เพิ่มประเภทห้องพัก
  search,
}

Widget createInputField(InputFieldType type,
    {Object? selectedValue, Function(Object?)? onChanged}) {
  switch (type) {
    case InputFieldType.username:
      return _buildBaseTextField(
        label: "ชื่อผู้ใช้",
        icon: Icons.person,
        hint: "กรอกชื่อ-นามสกุล",
      );
    case InputFieldType.search:
      return _buildBaseTextField(
        label: "ค้นหา",
        hint: "ค้นหา...",
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
    case InputFieldType.conformPassword:
      return _buildBaseTextField(
        label: "ยืนยันรหัสผ่าน",
        icon: Icons.lock,
        isPassword: true,
      );
    case InputFieldType.gender:
      return _buildRadioField<String>(
        label: "เพศ",
        options: ["ชาย", "หญิง", "อื่นๆ"],
        selectedValue: (selectedValue as String?) ??
            "ชาย", // ป้องกัน Error ถ้าค่าเป็น null
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value); // ส่งค่ากลับไปหา function ที่รับมา
          }
        },
      );
    default:
      return const SizedBox.shrink();
  }
}

// ตกแต่ง Input Field
Widget _buildBaseTextField({
  required String label,
  IconData? icon,
  String? hint,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Constants.colorIcon,
                size: 25,
              )
            : null,
        border: InputBorder.none,
        filled: true,
        fillColor: Constants.inputFieldFillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: const BorderSide(color: Constants.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: const BorderSide(
              color: Constants.inputFieldBorderColor, width: 3.0),
        ),
      ),
    ),
  );
}

Widget _buildRadioField<T>({
  required String label,
  required List<T> options,
  required T selectedValue,
  required Function(T?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: TextStyle(
            fontSize: Constants.fontSizeBody,
            fontWeight: Constants.fontWeightMedium,
            color: Constants.fontLabelColor,
          )),
      Row(
        children: options.map((option) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: option,
                groupValue: selectedValue,
                activeColor: Constants.secondaryColor,
                onChanged: onChanged,
              ),
              GestureDetector(
                onTap: () => onChanged(option),
                child: Text(option.toString(),
                    style: TextStyle(
                      fontSize: Constants.fontSizeBody,
                      color: Constants.fontLabelColor,
                    )),
              ),
              const SizedBox(width: 16),
            ],
          );
        }).toList(),
      ),
    ],
  );
}
