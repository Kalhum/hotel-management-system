import 'package:hotel_management_system/data/model/promotion_model.dart';
import 'package:hotel_management_system/data/repositorise/promotion_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import '../../util/function/image_url.dart'; // เพิ่ม: import ImageUrlHelper

class PromotionUsecase {
  final PromotionRepositoriseImpl repository;
  PromotionUsecase(this.repository);

  PromotionEntitise _toEntity(PromotionModel model) {
    return PromotionEntitise(
      id: model.id ?? 0,
      code: model.code ?? '',
      title: model.title ?? '',
      description: model.description,
      imageUrl: ImageUrlHelper.toFullImageUrl(model.imageUrl),
      discountType: model.discountType ?? 'fixed',
      discountValue: model.discountValue ?? 0,
      minBookingAmount: model.minBookingAmount ?? 0,
      maxDiscountAmount: model.maxDiscountAmount,
      usageLimit: model.usageLimit,
      usedCount: model.usedCount ?? 0,
      claimedCount: model.claimedCount ?? 0,
      startDate: model.startDate,
      endDate: model.endDate,
      isActive: model.isActive ?? false,
    );
  }

  UserCouponEntitise _toCouponEntity(UserCouponModel model) {
    return UserCouponEntitise(
      userPromotionId: model.userPromotionId ?? 0,
      status: model.status ?? 'available',
      receivedAt: model.receivedAt,
      usedAt: model.usedAt,
      bookingId: model.bookingId,
      promotionId: model.promotionId ?? 0,
      code: model.code ?? '',
      title: model.title ?? '',
      description: model.description,
      discountType: model.discountType ?? 'fixed',
      discountValue: model.discountValue ?? 0,
      minBookingAmount: model.minBookingAmount ?? 0,
      maxDiscountAmount: model.maxDiscountAmount,
      endDate: model.endDate,
    );
  }

  Future<List<PromotionEntitise>> getActivePromotions() async {
    try {
      final models = await repository.getActivePromotions();
      return models.map(_toEntity).toList();
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  Future<PromotionEntitise> getPromotionById(String id) async {
    try {
      final model = await repository.getPromotionById(id);
      return _toEntity(model);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  Future<int> claimPromotion(String promotionId) async {
    try {
      return await repository.claimPromotion(promotionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserCouponEntitise>> getMyCoupons(
      {String status = "available"}) async {
    try {
      final models = await repository.getMyCoupons(status: status);
      return models.map(_toCouponEntity).toList(); // แก้: แปลงตรงนี้
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
