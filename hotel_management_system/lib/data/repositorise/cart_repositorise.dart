import '../../domain/entitise/cart_item_entitise.dart';
import '../data_source/remote_data_source/cart_remote.dart';
import '../model/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemEntitise>> getCart();
  Future<CartItemEntitise> addItem(CartItemEntitise item);
  Future<void> removeItem(int id);
  Future<void> clearCart();
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CartItemEntitise>> getCart() async {
    final rows = await remoteDataSource.getCart();
    return rows
        .whereType<Map>()
        .map((row) => CartItemModel.fromJson(
              Map<String, dynamic>.from(row),
            ).toEntity())
        .toList();
  }

  @override
  Future<CartItemEntitise> addItem(CartItemEntitise item) async {
    final model = CartItemModel.fromEntity(item);
    final id = await remoteDataSource.addItem(model);
    return model.toEntity(id: id);
  }

  @override
  Future<void> removeItem(int id) => remoteDataSource.removeItem(id);

  @override
  Future<void> clearCart() => remoteDataSource.clearCart();
}
