import 'package:dio/dio.dart';

import '../../model/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<dynamic>> getCart();
  Future<int> addItem(CartItemModel item);
  Future<void> removeItem(int id);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<List<dynamic>> getCart() async {
    final response = await _dio.get('cart');
    final data = response.data['data'];
    if (data is! List) {
      throw Exception('รูปแบบข้อมูลตะกร้าจาก server ไม่ถูกต้อง');
    }
    return data;
  }

  @override
  Future<int> addItem(CartItemModel item) async {
    final response = await _dio.post('cart', data: item.toCartRequestJson());
    final id = int.tryParse('${response.data['data']?['id']}');
    if (id == null) {
      throw Exception('server ไม่ได้ส่งรหัสรายการตะกร้ากลับมา');
    }
    return id;
  }

  @override
  Future<void> removeItem(int id) async {
    await _dio.delete('cart/$id');
  }

  @override
  Future<void> clearCart() async {
    await _dio.delete('cart');
  }
}
