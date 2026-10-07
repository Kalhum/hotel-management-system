import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';
import 'package:signature/signature.dart';

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
  confirmPassword,
  gender, // เพิ่มเพศ
  roomType, // เพิ่มประเภทห้องพัก
  search,
  idCard,
  signature,
  idCardNumber,
  fullName,
  address,
  bDay,
  numberOfGuests,
  numberOfNights,
  paymentSlip,
  // --- เพิ่มส่วนของแม่บ้าน ---
  housekeeperCheck,
  housekeeperStatus,
  datePicker,
  bank
}

Widget createInputField(InputFieldType type,
    {Object? selectedValue,
    Function(Object?)? onChanged,
    BuildContext? context,
    TextEditingController? controller,
    SignatureController? sigController,
    File? file,
    VoidCallback? onTap,
    VoidCallback? onTogglePasswordVisibility,
    bool? obscureText,
    String? textLabel,
    File? imageFile}) {
  switch (type) {
    // --- ส่วนที่เพิ่มใหม่สำหรับแม่บ้าน ---
    case InputFieldType.housekeeperCheck:
      return _buildImagePickerBox(textLabel ?? "ถ่ายรูปยืนยันสภาพสิ่งของ",
          imageFile, onTap ?? () {}, Icons.camera_alt_outlined);

    case InputFieldType.housekeeperStatus:
      return _buildDropdownField(
        label: "สถานะการทำความสะอาด",
        value: selectedValue as String? ?? "ยังไม่ได้ทำความสะอาด",
        options: [
          "ยังไม่ได้ทำความสะอาด",
          "กำลังทำความสะอาด",
          "ทำความสะอาดเสร็จสิ้น"
        ],
        onChanged: onChanged,
      );
    // ---------------------------------

    case InputFieldType.fullName:
      return _buildBaseTextField(
        label: textLabel ?? "ชื่อ-นามสกุล", // ปรับให้รับ label จากภายนอกได้
        icon: Icons.person,
        controller: controller,
      );

    case InputFieldType.address:
      return _buildBaseTextField(
        label: textLabel ?? "ที่อยู่",
        icon: Icons.location_on,
        controller: controller,
      );
    case InputFieldType.idCardNumber:
      return _buildBaseTextField(
        label: textLabel ?? "เลขบัตรประชาชน",
        icon: Icons.credit_card,
        keyboardType: TextInputType.number,
        controller: controller,
      );

    case InputFieldType.paymentSlip:
      return _buildImagePickerBox(textLabel ?? "แนบหลักฐานการโอนเงิน",
          imageFile, onTap!, Icons.receipt_long);

    case InputFieldType.idCard:
      return _buildImagePickerBox(
          textLabel ?? "กดเพื่อถ่ายรูปบัตรประจำตัวประชาชน",
          imageFile,
          onTap ?? () {},
          Icons.add_a_photo_outlined);
    case InputFieldType.signature:
      return _buildSignaturePad(sigController!);
    case InputFieldType.username:
      return _buildBaseTextField(
        label: "ชื่อผู้ใช้",
        icon: Icons.person,
        hint: "กรอกชื่อ-นามสกุล",
        controller: controller,
      );
    case InputFieldType.bank:
      return _buildBaseTextField(
          label: "เลขบัญชีธนาคาร",
          icon: Icons.account_balance,
          hint: "กรอกเลขบัญชีธนาคาร",
          controller: controller);
    case InputFieldType.numberOfGuests:
      return _buildBaseTextField(
          label: "จำนวนคน",
          icon: Icons.people_alt,
          hint: "จำนวนคน",
          controller: controller);
    case InputFieldType.numberOfNights:
      return _buildBaseTextField(label: "จำนวนคืน", icon: Icons.night_shelter);
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
        obscureText: obscureText,
        onTogglePasswordVisibility: onTogglePasswordVisibility,
        controller: controller,
      );
    case InputFieldType.email:
      return _buildBaseTextField(
        label: "อีเมล",
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
      );
    case InputFieldType.phoneNumber:
      return _buildBaseTextField(
        label: "เบอร์โทรศัพท์",
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
        controller: controller,
      );
    case InputFieldType.specialRequest:
      return _buildBaseTextField(
        label: textLabel ?? "ความต้องการเพิ่มเติม",
        icon: Icons.note,
        maxLines: 3,
        controller: controller,
      );
    case InputFieldType.confirmPassword:
      return _buildBaseTextField(
        label: "ยืนยันรหัสผ่าน",
        icon: Icons.lock,
        isPassword: true,
        obscureText: obscureText,
        onTogglePasswordVisibility: onTogglePasswordVisibility,
        controller: controller,
      );
    case InputFieldType.gender:
      return _buildRadioField<String>(
        label: "เพศ",
        options: ["ชาย", "หญิง", "อื่นๆ"],
        selectedValue: (selectedValue as String?) ?? "ชาย",
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        },
      );
    case InputFieldType.datePicker:
      // ต้องเช็คก่อนว่า context ถูกส่งมาจริงๆ ถึงจะสร้าง DatePicker ได้
      if (context == null) return const SizedBox.shrink();
      return _buildDatePickerField(
        context: context,
        label: textLabel ?? "เลือกวันที่",
        controller: controller,
        onTap: onTap,
      );
    default:
      return const SizedBox.shrink();
  }
}

// --- ฟังก์ชัน Helper สำหรับ Dropdown (แม่บ้านใช้) ---
Widget _buildDropdownField({
  required String label,
  required String value,
  required List<String> options,
  Function(Object?)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Constants.fontLabelColor)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Constants.inputFieldFillColor,
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: options.map((String val) {
              return DropdownMenuItem<String>(value: val, child: Text(val));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

// ... (เก็บ _buildBaseTextField, _buildRadioField, _buildImagePickerBox, _buildSignaturePad ไว้เหมือนเดิมทุกประการ) ...

// ตกแต่ง Input Field
Widget _buildBaseTextField({
  required String label,
  IconData? icon,
  String? hint,
  bool isPassword = false,
  bool? obscureText,
  VoidCallback? onTogglePasswordVisibility,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: obscureText ?? isPassword,
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
        suffixIcon: isPassword && onTogglePasswordVisibility != null
            ? IconButton(
                tooltip: (obscureText ?? isPassword)
                    ? 'แสดงรหัสผ่าน'
                    : 'ซ่อนรหัสผ่าน',
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  (obscureText ?? isPassword)
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
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

Widget _buildImagePickerBox(
    String label, File? imageFile, VoidCallback onTap, IconData icon) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Constants.inputFieldFillColor,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: imageFile == null
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 50, color: Colors.grey),
              Text(label),
            ])
          : ClipRRect(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
    ),
  );
}

Widget _buildSignaturePad(SignatureController controller) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          child: Signature(
              controller: controller,
              height: 180,
              backgroundColor: Colors.white),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () => controller.clear(),
            child: Text('ล้างลายเซ็น', style: TextStyle(color: Colors.red))),
      ),
    ],
  );
}

Widget _buildDatePickerField({
  required BuildContext context,
  required String label,
  TextEditingController? controller,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: InkWell(
      onTap: onTap ??
          () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), // วันที่เก่าสุดที่เลือกได้
              lastDate: DateTime(2101), // วันที่อนาคตสุดที่เลือกได้
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Constants.secondaryColor, // สีหลักของปฏิทิน
                      onPrimary: Colors.white,
                      onSurface: Constants.fontLabelColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null && controller != null) {
              // จัดรูปแบบวันที่ตามต้องการ เช่น 2024-05-20
              String formattedDate =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              controller.text = formattedDate;
            }
          },
      child: IgnorePointer(
        // ใช้ IgnorePointer เพื่อให้ TextField ไม่รับ input จากคีย์บอร์ด แต่รับจาก onTap ของ InkWell แทน
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: Constants.fontSizeBody,
                fontWeight: FontWeight.w500,
                color: Constants.fontLabelColor),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: Constants.colorIcon,
              size: 22,
            ),
            filled: true,
            fillColor: Constants.inputFieldFillColor,
            border: InputBorder.none,
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
      ),
    ),
  );
}





// เรียกใช้ 
// Consumer<LoginScreenProvider>(
//                   builder: (context, provider, child) => Column(
//                     children: [
//                       createInputField(InputFieldType.username,
//                           controller: provider.usernameController),
//                       const SizedBox(height: 12),
//                       createInputField(InputFieldType.password,
//                           controller: provider.passwordController),


//                       // ...buildTest(data2)


//                     ],
//                   ),
//                 ),





// enum DataType { TextField, DateTime, Radio }

// final data = {
//   "username": DataType.TextField,
//   "date": DataType.DateTime,
//   "gender": DataType.Radio
// };

// final data2 = {
//   "username": {
//     "type": DataType.TextField,
//     "placeHolder": "กรุณากรอก",
//     "borderColor": "codeColor",
//     "errorColor": "codeColor"
//   },
//   "email": {"type": DataType.TextField, "placeHolder": "กรุณากรอก"},
//   "date": {"type": DataType.DateTime, "placeHolder": "กรุณากรอก"},
//   "gender": {"type": DataType.Radio, "placeHolder": "กรุณากรอก"}
// };

// List<Widget> buildTest(Map<String, dynamic> val) {
//   List<Widget> listWidget = List.empty(growable: true);
//   val.forEach((key, value) {
//     final widget = switch (value["type"]) {
//       DataType.TextField => Column(
//           children: [
//             Text(key),
//             TextField(
//               decoration: InputDecoration(hintText: value["placeHolder"]),
//             )
//           ],
//         ),
//       DataType.DateTime => Column(
//           children: [
//             Text(key),
//             DatePickerDialog(
//                 firstDate: DateTime.now(), lastDate: DateTime.now())
//           ],
//         ),
//       DataType.Radio => Column(
//           children: [
//             Text(key),
//             Row(
//               children: [
//                 Radio(
//                     value: value,
//                     groupValue: "",
//                     onChanged: (_) {
//                       print(_);
//                     }),
//                 Radio(
//                     value: value,
//                     groupValue: "",
//                     onChanged: (_) {
//                       print(_);
//                     }),
//               ],
//             )
//           ],
//         ),
//       _ => Column()
//     };

//     listWidget.add(widget);
//   });

//   return listWidget;
// }
