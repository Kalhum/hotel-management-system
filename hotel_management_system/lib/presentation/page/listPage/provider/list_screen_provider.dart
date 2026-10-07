import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/list_entitise.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';

import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:hotel_management_system/domain/use_case/history_usecase.dart'; // เพิ่ม

class BookingItem {
  final String bookingId;
  final String roomId;
  final double? totalPrice;
  final double? remainingAmount;
  final String status;
  final String? checkinStatus; // ค่าดิบจาก checkins table
  final String textStatus;
  final Color statusColor;
  final bool? checkInStatus;
  final bool? checkOutStatus;
  final bool? statusConCheck;
  final String? bookingStatus;
  final String? roomKey;
  final String customerName;
  final String phone;
  final String email;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int roomsCount;
  final int personCount;
  final String? slipUrl;
  final String? cancelReason;
  bool doNotDisturb;

  BookingItem(
      {required this.bookingId,
      required this.roomId,
      required this.totalPrice,
      this.remainingAmount,
      required this.status,
      this.checkinStatus,
      required this.textStatus,
      required this.statusColor,
      this.checkInStatus,
      this.checkOutStatus,
      this.statusConCheck,
      this.bookingStatus,
      this.roomKey,
      required this.customerName,
      required this.phone,
      required this.email,
      required this.checkIn,
      required this.checkOut,
      required this.roomsCount,
      required this.personCount,
      this.slipUrl,
      this.cancelReason,
      this.doNotDisturb = false});
}

class ListScreenProvider extends ChangeNotifier {
  final ListUsecase usecase;
  final CheckInUsecase checkInUsecase;
  final BookingHistoryUseCase historyUsecase; // เพิ่ม
  ListScreenProvider(this.usecase, this.checkInUsecase,
      this.historyUsecase); // แก้ constructor

  List<BookingItem> _bookingList = [];
  bool _isLoading = false;
  bool _isCheckingOut = false;
  String? _updatingDoNotDisturbBookingId;

  List<BookingItem> get bookingList => _bookingList;
  bool get isLoading => _isLoading;
  bool get isCheckingOut => _isCheckingOut;
  bool isUpdatingDoNotDisturb(String bookingId) =>
      _updatingDoNotDisturbBookingId == bookingId;

  Future<void> setDoNotDisturb(String bookingId, bool enabled) async {
    final booking = _bookingList.firstWhere(
      (item) => item.bookingId == bookingId,
    );
    final previousValue = booking.doNotDisturb;

    _updatingDoNotDisturbBookingId = bookingId;
    booking.doNotDisturb = enabled;
    notifyListeners();

    try {
      final success = await usecase.setDoNotDisturb(bookingId, enabled);
      if (!success) throw Exception('เปลี่ยนสถานะห้ามรบกวนไม่สำเร็จ');
    } catch (error) {
      booking.doNotDisturb = previousValue;
      notifyListeners();
      rethrow;
    } finally {
      _updatingDoNotDisturbBookingId = null;
      notifyListeners();
    }
  }

  Future<bool> checkOutBooking(String bookingId) async {
    _isCheckingOut = true;
    notifyListeners();
    try {
      final result = await checkInUsecase.checkOut(bookingId);
      if (result) {
        await getBookingList(); // โหลดรายการใหม่หลังเช็คเอาท์สำเร็จ
      }
      _isCheckingOut = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isCheckingOut = false;
      notifyListeners();
      rethrow; // โยน error ต่อให้ widget จัดการแสดงผล
    }
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    final result = await usecase.cancelBooking(bookingId, reason);
    if (result) await getBookingList();
    return result;
  }

  // เพิ่มฟังก์ชันใหม่สำหรับส่งรีวิว
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await historyUsecase.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      rethrow; // โยน error ต่อให้ widget จัดการแสดงผล
    }
  }

  Future<void> getBookingList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<BookingListEntity> entities = await usecase.getListData();
      _bookingList = entities.map((entity) {
        return BookingItem(
            bookingId: entity.bookingId,
            roomId: entity.roomId,
            totalPrice: entity.amount,
            remainingAmount: entity.remainingAmount,
            status: entity.status,
            checkinStatus: entity.checkinStatus,
            textStatus: _mapStatusText(entity.status, entity.checkinStatus),
            statusColor: _mapStatusColor(entity.status, entity.checkinStatus),
            checkInStatus: entity.checkInStatus.toLowerCase() == 'checked_in',
            checkOutStatus:
                entity.checkOutStatus.toLowerCase() == 'checked_out',
            statusConCheck: entity.inspectionStatus == 'PENDING',
            bookingStatus: entity.status,
            roomKey: entity.roomKey,
            customerName: entity.customerName,
            phone: entity.phone,
            email: entity.email,
            checkIn: entity.checkIn,
            checkOut: entity.checkOut,
            roomsCount: entity.roomsCount,
            personCount: entity.personCount,
            slipUrl: entity.slipUrl,
            cancelReason: entity.cancelReason,
            doNotDisturb: entity.doNotDisturb);
      }).toList();
      _isLoading = false;
      notifyListeners();
    } on SocketException {
      _isLoading = false;
      notifyListeners();
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      _isLoading = false;
      notifyListeners();
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  String _mapStatusText(String status, String? checkinStatus) {
    // เช็ค checkinStatus ก่อน เพราะเป็นสถานะที่ล่าสุด/เจาะจงกว่า status ของ booking
    if (checkinStatus == 'pending') {
      return 'รอ admin ตรวจเอกสารเข้าพัก';
    }
    if (checkinStatus == 'rejected') {
      return 'เอกสารเข้าพักถูกปฏิเสธ';
    }
    // checkinStatus == 'checked_in' หรือ null → ใช้ status ของ booking ตามปกติ
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'อนุมัติแล้ว';
      case 'PENDING':
        return 'รอดำเนินการ';
      case 'REJECTED':
        return 'ถูกปฏิเสธ';
      case 'CHECKED_IN':
        return 'เช็คอินแล้ว';
      default:
        return status;
    }
  }

  Color _mapStatusColor(String status, String? checkinStatus) {
    if (checkinStatus == 'pending') {
      return Colors.amber; // สีเหลือง/ส้มอ่อน สื่อถึง "กำลังรอ"
    }
    if (checkinStatus == 'rejected') {
      return Colors.red;
    }
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      case 'CHECKED_IN':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
