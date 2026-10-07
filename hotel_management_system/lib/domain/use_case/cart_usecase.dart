import '../entitise/cart_item_entitise.dart';
import '../../data/repositorise/cart_repositorise.dart';

class CartUseCase {
  final CartRepository repository;

  CartUseCase(this.repository);

  Future<List<CartItemEntitise>> getCart() => repository.getCart();

  Future<CartItemEntitise> addItem(CartItemEntitise item) =>
      repository.addItem(item);

  Future<void> removeItem(int id) => repository.removeItem(id);

  Future<void> clearCart() => repository.clearCart();
}
