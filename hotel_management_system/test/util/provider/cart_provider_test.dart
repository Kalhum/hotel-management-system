import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_management_system/data/repositorise/cart_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/cart_item_entitise.dart';
import 'package:hotel_management_system/domain/use_case/cart_usecase.dart';
import 'package:hotel_management_system/presentation/page/homePage/companents/typeRoom_enum.dart';
import 'package:hotel_management_system/util/provider/cart_provider.dart';

void main() {
  group('CartProvider.addItem', () {
    test('does not add an identical selection twice', () async {
      final repository = _FakeCartRepository();
      final provider = CartProvider(CartUseCase(repository));

      expect(await provider.addItem(_selection()), isTrue);
      expect(await provider.addItem(_selection()), isFalse);

      expect(repository.addCalls, 1);
      expect(provider.itemCount, 1);
      provider.dispose();
    });

    test('blocks identical selections while the first add is pending',
        () async {
      final repository = _FakeCartRepository()..addGate = Completer<void>();
      final provider = CartProvider(CartUseCase(repository));

      final firstAdd = provider.addItem(_selection());
      expect(await provider.addItem(_selection()), isFalse);
      expect(repository.addCalls, 1);

      repository.addGate!.complete();
      expect(await firstAdd, isTrue);
      expect(provider.itemCount, 1);
      provider.dispose();
    });

    test('finds a room in the cart for matching stay dates only', () async {
      final provider = CartProvider(CartUseCase(_FakeCartRepository()));
      final selection = _selection();

      await provider.addItem(selection);

      expect(
        provider.hasRoomForStay(
          selection.roomId,
          DateTime(2026, 11, 1),
          DateTime(2026, 11, 3),
        ),
        isTrue,
      );
      expect(
        provider.hasRoomForStay(
          selection.roomId,
          DateTime(2026, 11, 2),
          DateTime(2026, 11, 3),
        ),
        isFalse,
      );
      provider.dispose();
    });
  });
}

CartItemEntitise _selection() => CartItemEntitise(
      roomId: 'room-1',
      roomType: RoomType.rooms,
      checkIn: DateTime(2026, 11, 1),
      checkOut: DateTime(2026, 11, 3),
      adultCount: 2,
      childCount: 0,
      extraBedType: null,
      extraBedQuantity: 0,
      pricePerNight: 1000,
    );

class _FakeCartRepository implements CartRepository {
  final List<CartItemEntitise> _items = [];
  int addCalls = 0;
  int _nextId = 1;
  Completer<void>? addGate;

  @override
  Future<List<CartItemEntitise>> getCart() async => List.of(_items);

  @override
  Future<CartItemEntitise> addItem(CartItemEntitise item) async {
    addCalls++;
    await addGate?.future;
    final addedItem = CartItemEntitise(
      id: _nextId++,
      roomId: item.roomId,
      roomType: item.roomType,
      imageUrl: item.imageUrl,
      checkIn: item.checkIn,
      checkOut: item.checkOut,
      adultCount: item.adultCount,
      childCount: item.childCount,
      extraBedType: item.extraBedType,
      extraBedQuantity: item.extraBedQuantity,
      pricePerNight: item.pricePerNight,
    );
    _items.add(addedItem);
    return addedItem;
  }

  @override
  Future<void> removeItem(int id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
  }
}
