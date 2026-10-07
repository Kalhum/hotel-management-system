// room_detail_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/domain/use_case/extra_bed_usecase.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';

import '../../../../domain/entitise/cart_item_entitise.dart';
import '../../../../domain/entitise/extra_bed_entitise.dart';
import '../../homePage/companents/typeRoom_enum.dart';

class RoomDetail {
  final String roomId;
  final RoomType roomType;
  final String name;
  final String building;
  final String bedType;
  final int capacity;
  final List<String> imageUrls;
  final String description;
  final double pricePerNight;

  RoomDetail({
    required this.roomId,
    required this.roomType,
    this.name = '',
    this.building = '1',
    this.bedType = 'เตียงเดี่ยว',
    this.capacity = 2,
    required this.imageUrls,
    required this.description,
    required this.pricePerNight,
  });
}

class RoomDetailScreenProvider extends ChangeNotifier {
  final HomeUsecase homeUsecase;
  final ExtraBedUsecase extraBedUsecase;
  late List<HomeEntitise> roomData;

  RoomDetailScreenProvider(this.homeUsecase, this.extraBedUsecase);

  // จำกัดจำนวนผู้เข้าพักต่อการเลือกหนึ่งครั้ง (ปรับตามความจุห้องจริงได้)
  static const int maxAdults = 10;
  static const int maxChildren = 10;

  // --- Room State ---
  RoomDetail? _roomDetail;
  bool _isLoading = false;
  String _errorMessage = '';

  // --- Selection State ---
  DateTimeRange? _dateRange;
  int _adultCount = 1;
  int _childCount = 0;
  List<ExtraBedTypeEntitise> _extraBedTypes = [];
  bool _wantExtraBed = false;
  ExtraBedTypeEntitise? _selectedExtraBedType;
  int _extraBedQuantity = 1;

  // --- Getter: Room ---
  RoomDetail? get roomDetail => _roomDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // --- Getter: Selection ---
  DateTime? get checkIn => _dateRange?.start;
  DateTime? get checkOut => _dateRange?.end;
  DateTimeRange? get dateRange => _dateRange;
  int get adultCount => _adultCount;
  int get childCount => _childCount;
  List<ExtraBedTypeEntitise> get extraBedTypes => _extraBedTypes;
  bool get wantExtraBed => _wantExtraBed;
  ExtraBedTypeEntitise? get selectedExtraBedType => _selectedExtraBedType;
  int get extraBedQuantity => _extraBedQuantity;

  int get nights {
    final range = _dateRange;
    if (range == null) return 0;
    final diff = range.end.difference(range.start).inDays;
    return diff > 0 ? diff : 0;
  }

  /// มีเตียงเสริมจริงหรือไม่ (ต้องมีเด็ก + เปิดสวิตช์ + เลือกประเภทแล้ว)
  bool get hasExtraBed =>
      _childCount > 0 && _wantExtraBed && _selectedExtraBedType != null;

  double get roomPrice => (_roomDetail?.pricePerNight ?? 0) * nights;

  double get extraBedPrice => hasExtraBed
      ? _selectedExtraBedType!.price * _extraBedQuantity * nights
      : 0;

  double get totalPrice => roomPrice + extraBedPrice;

  bool get canProceed => _roomDetail != null && nights > 0 && _adultCount >= 1;

  // --- Load ---
  Future<void> getRoomDetail(
    String roomId,
    RoomType roomType, {
    DateTimeRange? initialDateRange,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    _resetSelection();
    _dateRange = initialDateRange;
    notifyListeners();

    try {
      roomData = await homeUsecase.getRooms();
      final room = roomData.firstWhere(
        (item) => item.roomId == roomId && item.roomType == roomType.name,
      );

      _roomDetail = RoomDetail(
        roomId: room.roomId,
        roomType: roomType,
        name: room.name,
        building: room.building,
        bedType: room.bedType,
        capacity: room.capacity,
        imageUrls: room.imageUrls,
        description: room.description,
        pricePerNight: room.pricePerNight,
      );
    } catch (e) {
      _roomDetail = null;
      _errorMessage = 'ไม่สามารถโหลดข้อมูลห้องได้';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // โหลดประเภทเตียงเสริมแยกต่างหาก ถ้าพังก็แค่ไม่มีตัวเลือกเตียงเสริม
    // ไม่ควรทำให้ทั้งหน้าใช้ไม่ได้
    try {
      _extraBedTypes = await extraBedUsecase.getExtraBedTypes();
    } catch (e) {
      _extraBedTypes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void _resetSelection() {
    _dateRange = null;
    _adultCount = 1;
    _childCount = 0;
    _extraBedTypes = [];
    _wantExtraBed = false;
    _selectedExtraBedType = null;
    _extraBedQuantity = 1;
  }

  // --- Dates ---
  void setDateRange(DateTimeRange range) {
    final start =
        DateTime(range.start.year, range.start.month, range.start.day);
    var end = DateTime(range.end.year, range.end.month, range.end.day);
    // เลือกวันเดียวกัน = พักอย่างน้อย 1 คืน
    if (!end.isAfter(start)) {
      end = start.add(const Duration(days: 1));
    }
    _dateRange = DateTimeRange(start: start, end: end);
    notifyListeners();
  }

  // --- Guests ---
  void incrementAdult() {
    if (_adultCount < maxAdults) {
      _adultCount++;
      notifyListeners();
    }
  }

  void decrementAdult() {
    if (_adultCount > 1) {
      _adultCount--;
      notifyListeners();
    }
  }

  void incrementChild() {
    if (_childCount < maxChildren) {
      _childCount++;
      notifyListeners();
    }
  }

  void decrementChild() {
    if (_childCount <= 0) return;
    _childCount--;

    if (_childCount == 0) {
      // ไม่มีเด็กแล้ว ล้างตัวเลือกเตียงเสริมทั้งหมด
      _wantExtraBed = false;
      _selectedExtraBedType = null;
      _extraBedQuantity = 1;
    } else if (_extraBedQuantity > _childCount) {
      // จำนวนเตียงเสริมต้องไม่เกินจำนวนเด็ก
      _extraBedQuantity = _childCount;
    }
    notifyListeners();
  }

  // --- Extra bed ---
  void toggleExtraBed(bool value) {
    if (value && _extraBedTypes.isEmpty) return;
    _wantExtraBed = value;
    if (value) {
      _selectedExtraBedType ??= _extraBedTypes.first;
      _extraBedQuantity = 1;
    } else {
      _selectedExtraBedType = null;
      _extraBedQuantity = 1;
    }
    notifyListeners();
  }

  void selectExtraBedType(ExtraBedTypeEntitise type) {
    _selectedExtraBedType = type;
    notifyListeners();
  }

  void incrementExtraBed() {
    if (_extraBedQuantity < _childCount) {
      _extraBedQuantity++;
      notifyListeners();
    }
  }

  void decrementExtraBed() {
    if (_extraBedQuantity > 1) {
      _extraBedQuantity--;
      notifyListeners();
    }
  }

  // --- Output ---
  /// สร้างรายการตะกร้าจากสิ่งที่เลือกไว้ (คืน null ถ้ายังเลือกไม่ครบ)
  CartItemEntitise? buildSelection() {
    final room = _roomDetail;
    final range = _dateRange;
    if (room == null || range == null || !canProceed) return null;

    return CartItemEntitise(
      roomId: room.roomId,
      roomType: room.roomType,
      imageUrl: room.imageUrls.isNotEmpty ? room.imageUrls.first : null,
      checkIn: range.start,
      checkOut: range.end,
      adultCount: _adultCount,
      childCount: _childCount,
      extraBedType: hasExtraBed ? _selectedExtraBedType : null,
      extraBedQuantity: hasExtraBed ? _extraBedQuantity : 0,
      pricePerNight: room.pricePerNight,
    );
  }
}
