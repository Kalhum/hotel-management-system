import 'package:flutter/material.dart';

import '../../domain/entitise/cart_item_entitise.dart';
import '../../domain/use_case/cart_usecase.dart';
import '../widget/core/constants.dart';

/// เก็บรายการห้องพักที่ผู้ใช้เลือกไว้ในตะกร้า ให้เข้าถึงได้ทุกหน้า (global provider)
class CartProvider extends ChangeNotifier {
  final CartUseCase useCase;

  CartProvider(this.useCase);

  final List<CartItemEntitise> _items = [];
  final List<({CartItemEntitise item, int sessionVersion})> _pendingAdds = [];
  String? _userId;
  // ป้องกัน response จาก session ของผู้ใช้ก่อนหน้ามาแก้ state ปัจจุบัน
  int _userSessionVersion = 0;
  // ป้องกันผล load เก่าทับตะกร้าหลังมีการเปลี่ยนแปลง
  int _cartRevision = 0;

  List<CartItemEntitise> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get depositAmount => totalPrice * Constants.depositPercent;

  double get remainingAmount => totalPrice - depositAmount;

  bool hasRoomForStay(String roomId, DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) return false;
    return _items.any(
      (item) =>
          item.roomId == roomId &&
          _sameDate(item.checkIn, checkIn) &&
          _sameDate(item.checkOut, checkOut),
    );
  }

  void syncForUser(String? userId) {
    if (_userId == userId) return;

    _userId = userId;
    final sessionVersion = ++_userSessionVersion;
    _cartRevision++;
    _items.clear();

    Future.microtask(() async {
      if (sessionVersion != _userSessionVersion) return;
      notifyListeners();
      if (userId == null) return;

      try {
        await load();
      } catch (_) {
        // Cart contents will be retried when the cart screen is opened.
      }
    });
  }

  Future<void> load() async {
    final sessionVersion = _userSessionVersion;
    final cartRevision = _cartRevision;
    final userId = _userId;
    final items = await useCase.getCart();
    if (sessionVersion != _userSessionVersion ||
        cartRevision != _cartRevision ||
        userId != _userId) {
      return;
    }
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  Future<bool> addItem(CartItemEntitise item) async {
    final sessionVersion = _userSessionVersion;
    final alreadyInCart =
        _items.any((existing) => _sameSelection(existing, item));
    final isBeingAdded = _pendingAdds.any(
      (pending) =>
          pending.sessionVersion == sessionVersion &&
          _sameSelection(pending.item, item),
    );
    if (alreadyInCart || isBeingAdded) return false;

    final pending = (item: item, sessionVersion: sessionVersion);
    _pendingAdds.add(pending);
    try {
      final addedItem = await useCase.addItem(item);
      if (sessionVersion != _userSessionVersion) return false;
      _cartRevision++;
      _items.add(addedItem);
      notifyListeners();
      return true;
    } finally {
      _pendingAdds.remove(pending);
    }
  }

  bool _sameSelection(CartItemEntitise first, CartItemEntitise second) =>
      first.roomId == second.roomId &&
      _sameDate(first.checkIn, second.checkIn) &&
      _sameDate(first.checkOut, second.checkOut) &&
      first.adultCount == second.adultCount &&
      first.childCount == second.childCount &&
      first.extraBedType?.id == second.extraBedType?.id &&
      first.extraBedQuantity == second.extraBedQuantity;

  bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  Future<void> removeItem(int id) async {
    final sessionVersion = _userSessionVersion;
    await useCase.removeItem(id);
    if (sessionVersion != _userSessionVersion) return;
    _cartRevision++;
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> clear() async {
    final sessionVersion = _userSessionVersion;
    await useCase.clearCart();
    if (sessionVersion != _userSessionVersion) return;
    _cartRevision++;
    _items.clear();
    notifyListeners();
  }
}
