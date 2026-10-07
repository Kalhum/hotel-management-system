import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/announcement_entitise.dart';
import 'package:hotel_management_system/domain/use_case/announcement_usecase.dart';

class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementUseCase useCase;

  AnnouncementProvider(this.useCase);

  List<AnnouncementEntitise> _announcements = [];
  List<AnnouncementEntitise> get announcements => _announcements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchActiveAnnouncements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _announcements = await useCase.getActiveAnnouncements();
    } catch (error) {
      _announcements = [];
      _error = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
