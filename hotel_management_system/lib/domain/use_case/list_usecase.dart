import 'dart:io';
import 'package:hotel_management_system/data/repositorise/list_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/list_entitise.dart';

class ListUsecase {
  final ListRepositoriseImpl repository;
  ListUsecase(this.repository);

  Future<bool> cancelBooking(String bookingId, String reason) {
    if (reason.trim().isEmpty) throw Exception("กรุณาระบุเหตุผลการยกเลิก");
    return repository.cancelBooking(bookingId, reason.trim());
  }

  Future<bool> setDoNotDisturb(String bookingId, bool enabled) {
    if (bookingId.trim().isEmpty) throw Exception("ไม่พบรายการจอง");
    return repository.setDoNotDisturb(bookingId, enabled);
  }

  Future<List<BookingListEntity>> getListData() async {
    try {
      final listDataModel = await repository.getListData();
      return listDataModel
          .map((item) => BookingListEntity(
                bookingId: item.id ?? "",
                userId: item.userId ?? "",
                customerName: item.customerName ?? "",
                roomId: item.roomId ?? "",
                checkIn: item.checkIn,
                checkOut: item.checkOut,
                roomsCount: item.roomsCount ?? 0,
                personCount: item.personCount ?? 0,
                amount: double.tryParse(item.amount ?? '') ?? 0.0,
                remainingAmount:
                    double.tryParse(item.remainingAmount ?? '') ?? 0.0,
                phone: item.phone ?? "",
                email: item.email ?? "",
                bankAccount: item.bankAccount?.toString(),
                address: item.address ?? "",
                status: item.status ?? "",
                paymentStatus: item.paymentStatus ?? "",
                slipUrl: item.slipUrl,
                checkInStatus: item.checkInStatus ?? "",
                checkOutStatus: item.checkOutStatus ?? "",
                inspectionStatus: item.inspectionStatus ?? "",
                checkinStatus:
                    item.checkinStatus, // เพิ่ม: ปล่อยเป็น null ได้ตามธรรมชาติ
                roomKey: item.roomKey?.toString(),
                createdAt: item.createdAt,
                cancelReason: item.cancelReason,
                cancelledBy: item.cancelledBy,
                cancelledAt: item.cancelledAt,
                doNotDisturb: item.doNotDisturb,
              ))
          .toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } on FormatException {
      throw Exception("รูปแบบข้อมูลไม่ถูกต้อง");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
