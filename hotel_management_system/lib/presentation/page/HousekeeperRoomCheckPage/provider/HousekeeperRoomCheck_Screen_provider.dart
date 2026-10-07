// housekeeper_room_check_screen_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/use_case/houseKeeper_usecase.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entitise/housekeeper_room_entity.dart';

/// เก็บ status/note/photo แยกต่อชิ้นได้จริง
class HousekeeperFurnitureItem {
  final int? id;
  final String title;
  final dynamic image;

  String status;
  String note;
  String priority;
  bool isCustom;

  File? photo;

  final String? lastDamageImageUrl;

  bool damageReported;
  String damageDescription;

  File? damagePhoto;
  File? replacementPhoto;

  HousekeeperFurnitureItem({
    this.id,
    required this.title,
    this.image,
    this.status = "ปกติ",
    this.note = "",
    this.priority = "medium",
    this.isCustom = false,
    this.photo,
    this.lastDamageImageUrl,
    this.damageReported = false,
    this.damageDescription = "",
    this.damagePhoto,
    this.replacementPhoto,
  });
}

class HousekeeperRoomCheckScreenProvider extends ChangeNotifier {
  // --- Dependency ---
  HousekeeperRoomUseCase housekeeperRoomUseCase;

  HousekeeperRoomCheckScreenProvider(this.housekeeperRoomUseCase);

  // --- State: ห้องทั้งหมด ---
  List<HousekeeperRoomEntity> _allRooms = [];
  List<HousekeeperRoomEntity> _filteredRooms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<HousekeeperRoomEntity> get filteredRooms => _filteredRooms;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // --- State: เฟอร์นิเจอร์ในห้องที่กำลังตรวจ ---
  List<HousekeeperFurnitureItem> _roomFurniture = [];
  bool _isFurnitureLoading = false;
  List<HousekeeperFurnitureItem> get roomFurniture => _roomFurniture;
  bool get isFurnitureLoading => _isFurnitureLoading;

  // --- ล้าง error message ให้อ่านง่าย (กัน "UseCase error: Exception:
  // Repository error: Exception: ..." ซ้อนกันหลายชั้น จากการ catch/rethrow
  // เป็น Exception ใหม่ในแต่ละ layer) ---
  String _cleanError(dynamic e) {
    return e.toString().replaceAll('Exception: ', '').trim();
  }

  // --- โหลดห้องทั้งหมด ---
  Future<void> getRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allRooms = await housekeeperRoomUseCase.getRooms();
      _filteredRooms = _allRooms;
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลห้องได้';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterRooms(String query) {
    _filteredRooms = query.isEmpty
        ? _allRooms
        : _allRooms.where((room) => room.roomNo.contains(query)).toList();
    notifyListeners();
  }

  // --- โหลดเฟอร์นิเจอร์ของห้อง ---
  Future<void> getRoomFurniture(String roomNo) async {
    _isFurnitureLoading = true;
    notifyListeners();

    try {
      final raw = await housekeeperRoomUseCase.getRoomFurniture(roomNo);
      _roomFurniture = raw.map((item) {
        return HousekeeperFurnitureItem(
          id: item['id'] as int?,
          title: (item['title'] ?? 'รายการเฟอร์นิเจอร์').toString(),
          image: item['image'],
          isCustom: item['isCustom'] == true,
          // prefill สถานะ/โน้ตจากผลตรวจครั้งก่อน แทนเริ่มที่ "ปกติ" เสมอ
          status: (item['lastStatus'] as String?) ?? "ปกติ",
          note: (item['lastNote'] as String?) ?? "",
          // รูปจากรอบก่อน (URL เต็ม) เก็บไว้ใช้ fallback ตอน submit ถ้า
          // รอบนี้ยังไม่ได้ถ่ายรูปใหม่
          lastDamageImageUrl: item['lastDamageImage'] as String?,
        );
      }).toList();
    } catch (e) {
      _roomFurniture = [];
      _errorMessage = 'ไม่สามารถโหลดรายการของในห้องได้';
    } finally {
      _isFurnitureLoading = false;
      notifyListeners();
    }
  }

  // --- แก้ไขสถานะ/โน้ต/รูปต่อชิ้น ---
  void updateFurnitureStatus(int index, String status) {
    final item = _roomFurniture[index];

    // กันกรณีกดสลับกลับ "ปกติ" มั่วตอนที่แจ้งซ่อมไปแล้วและกำลังรอเปลี่ยนของใหม่
    // (ถ้าจะกลับเป็นปกติ ต้องผ่าน confirmReplacement เท่านั้น เพื่อไม่ให้
    // damageReported ค้างเป็น true แบบไม่มี UI ให้จัดการต่อ)
    if (item.damageReported && status == "ปกติ") {
      return;
    }

    item.status = status;
    notifyListeners();
  }

  void updateFurnitureNote(int index, String note) {
    _roomFurniture[index].note = note;
    notifyListeners();
  }

  void updateFurniturePriority(int index, String priority) {
    _roomFurniture[index].priority = priority;
    notifyListeners();
  }

  // --- เพิ่มของนอกรายการเข้า "list เดียวกัน" กับของเดิม ---
  void addExtraFurniture(String title, {String note = ''}) {
    _roomFurniture.add(HousekeeperFurnitureItem(
      id: null,
      title: title,
      isCustom: true,
      status: "ชำรุด",
      note: note,
    ));
    notifyListeners();
  }

  void removeFurnitureAt(int index) {
    if (_roomFurniture[index].isCustom) {
      _roomFurniture.removeAt(index);
      notifyListeners();
    }
  }

  // --- ส่งรายงานเฟอร์นิเจอร์: multipart (roomNo, items, photosByIndex) ---
  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  ) async {
    try {
      return await housekeeperRoomUseCase.submitFurnitureReport(
        roomNo,
        items,
        photosByIndex,
      );
    } catch (e) {
      _errorMessage = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  // --- เรียกจากปุ่ม "แจ้งซ่อม" บนการ์ดแต่ละชิ้น ยิง createIssue ทันที
  // ไม่ต้องรอ Save รวมท้าย form ---
  Future<bool> reportIssueNow(int index, String roomNo) async {
    final item = _roomFurniture[index];
    if (item.status != 'ชำรุด') return false;

    if (item.damagePhoto == null) {
      _errorMessage = 'กรุณาถ่ายรูปความเสียหายก่อนแจ้งซ่อม';
      notifyListeners();
      return false;
    }

    final success = await createIssue(
      roomNo: roomNo,
      issueType: item.title,
      description: item.note.trim().isEmpty
          ? 'แม่บ้านพบความเสียหายระหว่างตรวจห้อง'
          : item.note.trim(),
      imageFiles: [item.damagePhoto!],
      priority: item.priority,
    );

    if (success) {
      item.damageReported = true; // เปิดสถานะ "รอเปลี่ยนของใหม่"
      notifyListeners();
    }
    return success;
  }

  // --- เรียกเมื่อแม่บ้านถ่ายรูปของใหม่แล้วยืนยันว่าเปลี่ยนเสร็จ ---
  void confirmReplacement(int index) {
    final item = _roomFurniture[index];
    if (item.replacementPhoto == null) return;

    item.photo = item.replacementPhoto; // ใช้เป็นรูปหลักฐานตัวใหม่
    item.status = "ปกติ"; // กลับสถานะเป็นปกติ
    item.damageReported = false;

    // เคลียร์ข้อมูลความเสียหายรอบก่อนทิ้ง กันรูป/โน้ตเก่าค้างมาโผล่
    // ถ้าของชิ้นนี้เสียอีกรอบในอนาคต
    item.damagePhoto = null;
    item.damageDescription = "";
    item.note = "";
    item.replacementPhoto = null;

    notifyListeners();
  }

  // --- แจ้งซ่อม: ส่งไฟล์ตรง (multipart) ---
  Future<bool> createIssue({
    required String roomNo,
    required String issueType,
    required String description,
    required List<File> imageFiles,
    String priority = 'medium',
  }) async {
    try {
      return await housekeeperRoomUseCase.createIssue(
        roomNo: roomNo,
        issueType: issueType,
        description: description,
        imageFiles: imageFiles,
        priority: priority,
      );
    } catch (e) {
      _errorMessage = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await housekeeperRoomUseCase.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      _errorMessage = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  // --- จุดรวม logic การ submit ทั้งหมด ---
  Future<bool> submitRoomInspection({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      // 1) เตรียม items (ไม่มีรูปฝังใน JSON) + map รูปใหม่แยกตาม index
      final reportItems = <Map<String, dynamic>>[];
      final photosByIndex = <int, File>{};

      for (var i = 0; i < _roomFurniture.length; i++) {
        final item = _roomFurniture[i];

        String? lastDamageImageForPayload;

        if (item.status == 'ชำรุด' && item.damagePhoto == null) {
          lastDamageImageForPayload = item.lastDamageImageUrl;
        }

        reportItems.add({
          'id': item.id,
          'roomId': roomNo,
          'bookingId': null,
          'title': item.title,
          'image': item.image,
          'isCustom': item.isCustom,
          'inspections': [
            {
              'status': item.status,
              'note': item.note,
              'lastDamageImage': lastDamageImageForPayload,
            },
          ],
        });

        // ============================================================
        // เลือกรูปที่จะ upload
        // ============================================================

        File? uploadPhoto;

        if (item.status == 'ชำรุด') {
          // ชำรุด → ใช้รูปความเสียหาย
          uploadPhoto = item.damagePhoto;
        } else {
          // ปกติ → ใช้รูปหลักฐานของเฟอร์นิเจอร์ (รวมถึงรูปของใหม่ที่เพิ่ง
          // เปลี่ยน เพราะ confirmReplacement เซ็ต item.photo ไว้แล้ว)
          uploadPhoto = item.photo;
        }

        if (uploadPhoto != null) {
          photosByIndex[i] = uploadPhoto;
        }
      }

      if (reportItems.isNotEmpty) {
        final reportSuccess =
            await submitFurnitureReport(roomNo, reportItems, photosByIndex);
        if (!reportSuccess) return false;
      }

      // 2) แจ้งซ่อม: สร้าง maintenance_reports สำหรับรายการที่ชำรุด
      // และยังไม่ได้แจ้งซ่อมผ่านปุ่มแยกมาก่อน
      for (var i = 0; i < _roomFurniture.length; i++) {
        final item = _roomFurniture[i];

        if (item.status != 'ชำรุด') continue;
        if (item.damageReported) continue; // แจ้งซ่อมไปแล้วจากปุ่มแยก ข้าม

        final File? repairPhoto = item.damagePhoto;

        final issueSuccess = await createIssue(
          roomNo: roomNo,
          issueType: item.title,
          description: item.note.trim().isEmpty
              ? 'แม่บ้านพบความเสียหายระหว่างตรวจห้อง'
              : item.note.trim(),
          imageFiles: repairPhoto == null ? [] : [repairPhoto],
          priority: item.priority,
        );

        if (!issueSuccess) return false;
      }

      // 3) บันทึกสถานะความสะอาดห้อง
      return await saveRoomDetail(
          roomNo: roomNo, cleaningStatus: cleaningStatus);
    } catch (e) {
      _errorMessage = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  // --- บันทึก "เหตุการณ์แจ้งชำรุด" แยกต่างหาก ---
  void reportDamage(int index, {required String description, File? photo}) {
    _roomFurniture[index].damageReported = true;
    _roomFurniture[index].damageDescription = description;
    if (photo != null) {
      _roomFurniture[index].damagePhoto = photo;
    }
    _roomFurniture[index].status = "ชำรุด";
    notifyListeners();
  }

  void cancelDamageReport(int index) {
    _roomFurniture[index].damageReported = false;
    _roomFurniture[index].damageDescription = "";
    _roomFurniture[index].damagePhoto = null;
    notifyListeners();
  }

  Future<File?> _pickImageFromSourceDialog(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('ถ่ายรูป'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('เลือกจากคลังรูปภาพ'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return null;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 60);
    return image != null ? File(image.path) : null;
  }

  Future<void> pickFurniturePhoto(BuildContext context, int index) async {
    final file = await _pickImageFromSourceDialog(context);
    if (file != null) {
      _roomFurniture[index].photo = file;
      notifyListeners();
    }
  }

  Future<void> pickDamagePhoto(BuildContext context, int index) async {
    final file = await _pickImageFromSourceDialog(context);
    if (file != null) {
      _roomFurniture[index].damagePhoto = file;
      notifyListeners();
    }
  }

  Future<void> pickReplacementPhoto(
    BuildContext context,
    int index,
  ) async {
    final file = await _pickImageFromSourceDialog(context);

    if (file != null) {
      _roomFurniture[index].replacementPhoto = file;
      notifyListeners();
    }
  }
}
