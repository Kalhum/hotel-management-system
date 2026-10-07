import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/use_case/furniture_usecase.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entitise/furniture_entitise.dart';

class FurnitureItem {
  final int? id;
  final String title;
  final dynamic image;

  String status;
  String note;
  bool isCustom;

  // รูปที่ user ถ่ายความเสียหายในการตรวจครั้งนี้
  File? damageImage;

  // รูปที่แม่บ้านตรวจล่าสุดจาก server
  final String? inspectionImageUrl;

  FurnitureItem({
    this.id,
    required this.title,
    required this.image,
    this.status = "ยังไม่ได้ตรวจสอบ",
    this.note = "",
    this.isCustom = false,
    this.damageImage,
    this.inspectionImageUrl,
  });
}

class RoomConditionCheckScreenProvider extends ChangeNotifier {
  final FurnitureUsecase usecase;

  RoomConditionCheckScreenProvider(this.usecase);

  List<FurnitureItem> _furnitureList = [];

  int _remainingSeconds = 3600;

  Timer? _timer;

  bool _isLoading = false;
  bool _disposed = false;
  bool _autoSubmitTriggered = false;

  String? _errorMessage;
  String? _bookingId;

  // ============================================================
  // GETTERS
  // ============================================================

  List<FurnitureItem> get furnitureList => _furnitureList;

  int get remainingSeconds => _remainingSeconds;

  bool get isTimeUp => _remainingSeconds <= 0;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get normalCount => _furnitureList.where((f) => f.status == "ปกติ").length;

  int get damagedCount =>
      _furnitureList.where((f) => f.status == "ชำรุด").length;

  // ============================================================
  // AUTO SUBMIT
  // ============================================================

  bool consumeAutoSubmitTrigger() {
    if (isTimeUp && !_autoSubmitTriggered) {
      _autoSubmitTriggered = true;
      return true;
    }

    return false;
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // ============================================================
  // INIT
  // ============================================================

  void init(
    String roomID,
    String bookingId,
  ) {
    _timer?.cancel();

    _bookingId = bookingId;

    _remainingSeconds = 3600;
    _autoSubmitTriggered = false;

    _loadFurnitureList(
      roomID,
      bookingId,
    );

    _startTimer();
  }

  // ============================================================
  // LOAD FURNITURE
  // ============================================================

  Future<void> _loadFurnitureList(
    String roomID,
    String bookingId,
  ) async {
    _isLoading = true;
    _errorMessage = null;

    _safeNotify();

    try {
      final entities = await usecase.getFurnitureData(
        roomID,
        bookingId,
      );

      _furnitureList = entities.map((entity) {
        return FurnitureItem(
          id: entity.id,
          title: entity.title ?? "",
          image: entity.image ?? "",

          // ให้ user เลือกใหม่เอง
          status: "ยังไม่ได้ตรวจสอบ",

          // ไม่เอา note ของแม่บ้านมาเป็น note ของ user
          note: "",

          isCustom: entity.isCustom ?? false,

          // รูปแม่บ้าน
          inspectionImageUrl: entity.housekeeperInspectionImage,
        );
      }).toList();
    } catch (e) {
      _errorMessage = "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้ กรุณาลองใหม่อีกครั้ง";

      debugPrint(
        "Load furniture error: $e",
      );
    } finally {
      _isLoading = false;

      _safeNotify();
    }
  }

  // ============================================================
  // TIMER
  // ============================================================

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          _safeNotify();
        } else {
          timer.cancel();

          _safeNotify();
        }
      },
    );
  }

  String formatTime(int seconds) {
    final h = seconds ~/ 3600;

    final m = (seconds % 3600) ~/ 60;

    final s = seconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  // ============================================================
  // UPDATE STATUS
  // ============================================================

  void updateStatus(
    int index,
    String status,
  ) {
    _furnitureList[index].status = status;

    // ถ้าเปลี่ยนจากชำรุดกลับเป็นปกติ
    // ล้างรูป damage ที่ถ่ายไว้
    if (status != "ชำรุด") {
      _furnitureList[index].damageImage = null;
    }

    _safeNotify();
  }

  // ============================================================
  // UPDATE NOTE
  // ============================================================

  void updateNote(
    int index,
    String note,
  ) {
    _furnitureList[index].note = note;

    _safeNotify();
  }

  // ============================================================
  // PICK DAMAGE IMAGE
  // ============================================================

  Future<void> pickDamageImage(
    int index,
  ) async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      _furnitureList[index].damageImage = File(image.path);

      _safeNotify();
    }
  }

  // ============================================================
  // ADD EXTRA FURNITURE
  // ============================================================

  Future<void> addExtraFurniture({
    required String title,
    File? damageImage,
  }) async {
    _furnitureList.add(
      FurnitureItem(
        id: null,
        title: title,
        image: null,
        status: "ชำรุด",
        isCustom: true,
        damageImage: damageImage,
      ),
    );

    _safeNotify();
  }

  // ============================================================
  // VALIDATE
  // ============================================================

  void _validateBeforeSubmit() {
    for (var i = 0; i < _furnitureList.length; i++) {
      final item = _furnitureList[i];

      // ยังไม่ได้ตรวจ
      if (item.status == "ยังไม่ได้ตรวจสอบ") {
        throw Exception(
          "กรุณาตรวจสอบ ${item.title} ก่อนบันทึก",
        );
      }

      // ชำรุดแต่ไม่มีรูป
      if (item.status == "ชำรุด" && item.damageImage == null) {
        throw Exception(
          "กรุณาถ่ายรูปความเสียหายของ ${item.title}",
        );
      }
    }
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> submitCheckCondition(
    String roomID,
  ) async {
    _timer?.cancel();

    debugPrint(
      "submitCheckCondition",
    );

    debugPrint(
      "roomID = $roomID",
    );

    debugPrint(
      "bookingId = $_bookingId",
    );

    if (_bookingId == null) {
      throw Exception(
        "ไม่พบ bookingId กรุณาเริ่มการตรวจสอบใหม่",
      );
    }

    _validateBeforeSubmit();

    try {
      // ========================================================
      // 1. เตรียมรูปตาม field
      // ========================================================

      final photosByField = <String, File>{};

      for (var i = 0; i < _furnitureList.length; i++) {
        final item = _furnitureList[i];

        // ------------------------------------------
        // ชำรุด
        // ------------------------------------------

        if (item.status == "ชำรุด") {
          if (item.damageImage != null) {
            photosByField["photo_${i}_damage"] = item.damageImage!;
          }
        }

        // ------------------------------------------
        // ปกติ
        //
        // ตอนนี้หน้า User ไม่มีการถ่ายรูป normal
        // จึงไม่ส่ง photo_i
        // ------------------------------------------
      }

      debugPrint(
        "photosByField = "
        "${photosByField.keys.toList()}",
      );

      // ========================================================
      // 2. เตรียม FurnitureEntitise
      // ========================================================

      final reportData = _furnitureList.map((item) {
        return FurnitureEntitise(
          id: item.id,
          roomID: roomID,
          bookingId: _bookingId,
          title: item.title,

          image: item.image is String ? item.image as String : null,

          status: item.status,

          note: item.note,

          isCustom: item.isCustom,

          // รูป damage ของ user
          // Backend จะเอาไฟล์จาก photo_i_damage
          damageImage: null,
        );
      }).toList();

      debugPrint(
        "furniture = "
        "${reportData.length} รายการ",
      );

      // ========================================================
      // 3. ยิง endpoint เดียว
      // ========================================================

      debugPrint(
        "POST /furniture/report",
      );

      await usecase.submitReport(
        reportData,
        _bookingId!,
        photosByField,
      );

      await usecase.confirmUserCondition(_bookingId!);

      debugPrint(
        "furniture report และยืนยันสภาพห้องสำเร็จ",
      );

      debugPrint(
        "ตรวจห้องสำเร็จทั้งหมด",
      );
    } catch (e) {
      debugPrint(
        "Submit error: $e",
      );

      rethrow;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _disposed = true;

    _timer?.cancel();

    super.dispose();
  }
}



// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hotel_management_system/domain/use_case/furniture_usecase.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../domain/entitise/furniture_entitise.dart';

// class FurnitureItem {
//   final int? id;
//   final String title;
//   final dynamic image;
//   String status; // "ปกติ" | "ชำรุด" | "ยังไม่ได้ตรวจสอบ"
//   String note;
//   bool isCustom;
//   File? damageImage; // รูปใหม่ที่ user เพิ่งถ่าย (ถ้ามี) รอ upload ตอน submit

//   // ✅ รูปที่แม่บ้านตรวจไว้ก่อนหน้า (URL เต็มจาก server) — ใช้โชว์ให้ user
//   // เห็นเป็นหลักฐาน "ของไม่ชำรุด" ก่อนที่ user จะตรวจซ้ำเอง
//   final String? inspectionImageUrl;

//   FurnitureItem({
//     this.id,
//     required this.title,
//     required this.image,
//     this.status = "ปกติ",
//     this.note = "",
//     this.isCustom = false,
//     this.damageImage,
//     this.inspectionImageUrl,
//   });
// }

// class RoomConditionCheckScreenProvider extends ChangeNotifier {
//   final FurnitureUsecase usecase;
//   RoomConditionCheckScreenProvider(this.usecase);

//   // --- State ---
//   List<FurnitureItem> _furnitureList = [];
//   int _remainingSeconds = 3600;
//   Timer? _timer;
//   bool _isLoading = false;
//   bool _disposed = false;
//   bool _autoSubmitTriggered = false;
//   String? _errorMessage;

//   String? _bookingId; // ✅ เก็บไว้ใช้ตอน submit

//   // --- Getter ---
//   List<FurnitureItem> get furnitureList => _furnitureList;
//   int get remainingSeconds => _remainingSeconds;
//   bool get isTimeUp => _remainingSeconds <= 0;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   int get normalCount => _furnitureList.where((f) => f.status == "ปกติ").length;
//   int get damagedCount =>
//       _furnitureList.where((f) => f.status == "ชำรุด").length;

//   bool consumeAutoSubmitTrigger() {
//     if (isTimeUp && !_autoSubmitTriggered) {
//       _autoSubmitTriggered = true;
//       return true;
//     }
//     return false;
//   }

//   void _safeNotify() {
//     if (!_disposed) {
//       notifyListeners();
//     }
//   }

//   // --- Init ---
//   void init(String roomID, String bookingId) {
//     _bookingId = bookingId;
//     _loadFurnitureList(roomID, bookingId);
//     _startTimer();
//   }

//   Future<void> _loadFurnitureList(String roomID, String bookingId) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _safeNotify();

//     try {
//       final entities = await usecase.getFurnitureData(roomID, bookingId);

//       _furnitureList = entities.map((entity) {
//         return FurnitureItem(
//           id: entity.id,
//           title: entity.title ?? "",
//           image: entity.image ?? "",
//           status: entity.status ?? "ปกติ",
//           // ✅ prefill โน้ตจากรอบตรวจของแม่บ้าน (ถ้ามี) แทนเริ่มจากค่าว่างเสมอ
//           note: entity.note ?? "",
//           // ✅ รูปที่แม่บ้านถ่ายไว้ (ของไม่ชำรุด) โชว์เป็นหลักฐานให้ user เห็น
//           inspectionImageUrl: entity.damageImage,
//         );
//       }).toList();
//     } catch (e) {
//       _errorMessage = "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้ กรุณาลองใหม่อีกครั้ง";
//       debugPrint("Load furniture error: $e");
//     } finally {
//       _isLoading = false;
//       _safeNotify();
//     }
//   }

//   // --- Timer ---
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         _remainingSeconds--;
//         _safeNotify();
//       } else {
//         _timer?.cancel();
//         _safeNotify();
//       }
//     });
//   }

//   String formatTime(int seconds) {
//     int h = seconds ~/ 3600;
//     int m = (seconds % 3600) ~/ 60;
//     int s = seconds % 60;
//     return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
//   }

//   // --- Functions ---
//   void updateStatus(int index, String status) {
//     _furnitureList[index].status = status;
//     _safeNotify();
//   }

//   void updateNote(int index, String note) {
//     _furnitureList[index].note = note;
//     _safeNotify();
//   }

//   Future<void> pickDamageImage(int index) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image =
//         await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
//     if (image != null) {
//       _furnitureList[index].damageImage = File(image.path);
//       _safeNotify();
//     }
//   }

//   Future<void> addExtraFurniture({
//     required String title,
//     File? damageImage,
//   }) async {
//     _furnitureList.add(FurnitureItem(
//       id: null, // ✅ item ใหม่ ไม่มี id เดิม backend จะ insert furniture ใหม่ให้เอง
//       title: title,
//       image: null,
//       status: "ชำรุด",
//       isCustom: true,
//       damageImage: damageImage,
//     ));
//     _safeNotify();
//   }

//   // --- ส่งรายงานทั้งหมด: multipart ไปพร้อมกันในคำขอเดียว ---
//   Future<void> submitCheckCondition(String roomID) async {
//     _timer?.cancel();

//     debugPrint("🔥🔥🔥 submitCheckCondition CALLED 🔥🔥🔥");
//     debugPrint("🏨 roomID = $roomID");
//     debugPrint("📌 bookingId = $_bookingId");

//     if (_bookingId == null) {
//       throw Exception("ไม่พบ bookingId กรุณาเริ่มการตรวจสอบใหม่");
//     }

//     try {
//       // =====================================================
//       // 1. เตรียมรูปของแต่ละ furniture
//       // =====================================================

//       final photosByIndex = <int, File>{};

//       for (var i = 0; i < _furnitureList.length; i++) {
//         final item = _furnitureList[i];

//         if (item.damageImage != null) {
//           photosByIndex[i] = item.damageImage!;
//         }
//       }

//       debugPrint(
//         "📸 furniture photos = ${photosByIndex.length}",
//       );

//       // =====================================================
//       // 2. เตรียมข้อมูล furniture inspection
//       // =====================================================

//       final reportData = _furnitureList.map((item) {
//         return FurnitureEntitise(
//           id: item.id,
//           roomID: roomID,
//           bookingId: _bookingId,
//           title: item.title,
//           image: item.image is String ? item.image as String : null,
//           status: item.status,
//           note: item.note,
//           isCustom: item.isCustom,
//           damageImage: null,
//         );
//       }).toList();

//       debugPrint(
//         "📦 furniture ทั้งหมด = ${reportData.length} รายการ",
//       );

//       // =====================================================
//       // 3. บันทึก furniture inspection ก่อน
//       // =====================================================

//       debugPrint("📤 กำลังส่ง furniture inspection...");

//       await usecase.submitReport(
//         reportData,
//         _bookingId!,
//         photosByIndex,
//       );

//       debugPrint("✅ furniture inspection บันทึกสำเร็จ");

//       // =====================================================
//       // 4. หาเฉพาะรายการที่ชำรุด
//       // =====================================================

//       final damagedItems =
//           _furnitureList.where((item) => item.status == "ชำรุด").toList();

//       debugPrint(
//         "🔧 จำนวนรายการชำรุด = ${damagedItems.length}",
//       );

//       // =====================================================
//       // 5. สร้าง maintenance_reports
//       // =====================================================

//       for (final item in damagedItems) {
//         final description = item.note.trim().isEmpty
//             ? 'ผู้ใช้พบความเสียหายระหว่างตรวจห้อง'
//             : item.note.trim();

//         debugPrint("========================================");
//         debugPrint("🔧 [REPAIR] กำลังส่งแจ้งซ่อม");
//         debugPrint("roomNo      = $roomID");
//         debugPrint("issueType   = ${item.title}");
//         debugPrint("description = $description");
//         debugPrint("hasImage    = ${item.damageImage != null}");
//         debugPrint("========================================");

//         final success = await usecase.createRepairReport(
//           roomNo: roomID,
//           issueType: item.title,
//           description: description,
//           imageFiles: item.damageImage == null ? [] : [item.damageImage!],
//         );

//         if (!success) {
//           throw Exception(
//             "สร้างรายการแจ้งซ่อมไม่สำเร็จ: ${item.title}",
//           );
//         }

//         debugPrint(
//           "✅ [REPAIR] ส่งแจ้งซ่อมสำเร็จ: ${item.title}",
//         );
//       }

//       debugPrint("🎉🎉🎉 บันทึกการตรวจห้องสำเร็จทั้งหมด 🎉🎉🎉");
//     } catch (e) {
//       debugPrint("❌❌❌ Submit error: $e");
//       rethrow;
//     }
//   }

//   @override
//   void dispose() {
//     _disposed = true;
//     _timer?.cancel();
//     super.dispose();
//   }
// }
