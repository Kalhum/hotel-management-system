import 'package:flutter/material.dart';

class Constants {

  static const double depositPercent = 0.30;
  
  // Colors App
  static const Color secondaryColor = Color(0xFFFF9500);
  static const Color primaryColor = Color.fromRGBO(147, 37, 87, 1);
  static const successColor = Color.fromARGB(0, 37, 154, 50);
  static const bgcolor = Colors.white;

  static const Color bgButon = Color.fromARGB(255, 240, 240, 240);

  // ----------------------------------------------------
  // color form
  static const Color white = Color(0xFFFFFFFF);
  static Color? inputFieldFillColor = Colors.grey[200];
  static const Color inputFieldBorderColor = Color(0xFFE0E0E0);

  static const Color colorIcon = Color.fromARGB(255, 0, 0, 0);
  static const Color fontLabelColor = Color.fromARGB(255, 54, 54, 54);

//-------------------------------------------------------
  // btnton colors

  static const Color submitButtonColor = Color(0x49BF57);
  static const Color cancelButtonColor = Color(0xFF0000);

// ตัวเลข ควรจะหาร 2 ลงตัว

// padding and border radius
  static const double padding = 16.0;
  static const double borderRadius = 16;
// ---------------------------------------------------------
  //Font Sizes

  // Headings (หัวข้อ)
  static const double fontSizeDisplay = 32.0; // หัวข้อใหญ่พิเศษ
  static const double fontSizeHeader = 24.0; // หัวข้อหน้า (Page Title)
  static const double fontSizeTitle = 18.0; // หัวข้อย่อย หรือชื่อโรงแรมใน List

  // Body (เนื้อหา)
  static const double fontSizeBody =
      16.0; // ข้อความทั่วไป (มาตรฐานที่อ่านง่ายที่สุด)
  static const double fontSizeLabel =
      14.0; // ข้อความอธิบายสั้นๆ หรือ Label ใน Input
  static const double fontSizeSmall = 12.0; // ตัวหนังสือหมายเหตุ หรือวันที่

  // Font Weights (ความหนา)
  static const FontWeight fontWeightBold = FontWeight.bold;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightNormal = FontWeight.normal;
}
