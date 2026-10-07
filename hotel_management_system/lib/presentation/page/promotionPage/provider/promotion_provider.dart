import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';

import '../../../../domain/use_case/promotion_usecase.dart';

class PromotionProvider extends ChangeNotifier {
  final PromotionUsecase usecase;
  PromotionProvider(this.usecase);

  // ---------- Active Promotions ----------
  List<PromotionEntitise> _promotions = [];
  List<PromotionEntitise> get promotions => _promotions;

  bool _isLoadingPromotions = false;
  bool get isLoadingPromotions => _isLoadingPromotions;

  String? _promotionsError;
  String? get promotionsError => _promotionsError;

  Future<void> fetchActivePromotions() async {
    _isLoadingPromotions = true;
    _promotionsError = null;
    notifyListeners();

    try {
      _promotions = await usecase.getActivePromotions();
    } catch (e) {
      _promotionsError = e.toString().replaceFirst('Exception: ', '');
      _promotions = [];
    } finally {
      _isLoadingPromotions = false;
      notifyListeners();
    }
  }

  // ---------- Promotion Detail ----------
  PromotionEntitise? _selectedPromotion;
  PromotionEntitise? get selectedPromotion => _selectedPromotion;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  String? _detailError;
  String? get detailError => _detailError;

  Future<void> fetchPromotionById(String id) async {
    _isLoadingDetail = true;
    _detailError = null;
    _selectedPromotion = null;
    notifyListeners();

    try {
      _selectedPromotion = await usecase.getPromotionById(id);
    } catch (e) {
      _detailError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  // ---------- Claim Promotion ----------
  bool _isClaiming = false;
  bool get isClaiming => _isClaiming;

  String? _claimError;
  String? get claimError => _claimError;

  /// คืน true ถ้าเก็บคูปองสำเร็จ, false ถ้าไม่สำเร็จ (เช็ค claimError เพื่อดู message)
  Future<bool> claimPromotion(String promotionId) async {
    _isClaiming = true;
    _claimError = null;
    notifyListeners();

    try {
      await usecase.claimPromotion(promotionId);
      _isClaiming = false;
      notifyListeners();
      await fetchActivePromotions();
      await fetchMyCoupons(status: _couponStatus);
      return true;
    } catch (e) {
      _claimError = e.toString().replaceFirst('Exception: ', '');
      _isClaiming = false;
      notifyListeners();
      return false;
    }
  }

  // ---------- My Coupons ----------
  List<UserCouponEntitise> _myCoupons = [];
  List<UserCouponEntitise> get myCoupons => _myCoupons;

  bool _isLoadingCoupons = false;
  bool get isLoadingCoupons => _isLoadingCoupons;

  String? _couponsError;
  String? get couponsError => _couponsError;

  String _couponStatus = "available";
  String get couponStatus => _couponStatus;

  Future<void> fetchMyCoupons({String status = "available"}) async {
    _couponStatus = status;
    _isLoadingCoupons = true;
    _couponsError = null;
    notifyListeners();

    try {
      _myCoupons = await usecase.getMyCoupons(status: status);
    } catch (e) {
      _couponsError = e.toString().replaceFirst('Exception: ', '');
      _myCoupons = [];
    } finally {
      _isLoadingCoupons = false;
      notifyListeners();
    }
  }

  // ---------- Utility ----------
  void clearClaimError() {
    _claimError = null;
    notifyListeners();
  }

  void clearSelectedPromotion() {
    _selectedPromotion = null;
    _detailError = null;
    notifyListeners();
  }
}
