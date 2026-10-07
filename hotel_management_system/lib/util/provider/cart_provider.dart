import 'package:flutter/material.dart';

import '../../domain/entitise/cart_item_entitise.dart';
import '../../domain/use_case/cart_usecase.dart';
import '../widget/core/constants.dart';

/// เก็บรายการห้องพักที่ผู้ใช้เลือกไว้ในตะกร้า ให้เข้าถึงได้ทุกหน้า (global provider)
class CartProvider extends ChangeNotifier {
  final CartUseCase useCase;

  CartProvider(this.useCase);

  final List<CartItemEntitise> _items = [];
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

  Future<void> addItem(CartItemEntitise item) async {
    final sessionVersion = _userSessionVersion;
    final addedItem = await useCase.addItem(item);
    if (sessionVersion != _userSessionVersion) return;
    _cartRevision++;
    _items.add(addedItem);
    notifyListeners();
  }

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
