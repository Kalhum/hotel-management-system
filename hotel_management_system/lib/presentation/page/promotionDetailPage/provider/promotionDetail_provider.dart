import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import 'package:hotel_management_system/domain/use_case/promotion_usecase.dart';

class PromotiondetailProvide extends ChangeNotifier {
  final PromotionUsecase promotionUsecase;

  PromotiondetailProvide(this.promotionUsecase);

  PromotionEntitise? promotion;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPromotionDetail(String id) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      promotion = await promotionUsecase.getPromotionById(id);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'ไม่สามารถโหลดข้อมูลโปรโมชั่นได้: $e';
      notifyListeners();
    }
  }
}