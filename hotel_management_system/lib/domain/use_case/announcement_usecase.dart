import 'package:hotel_management_system/data/repositorise/announcement_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/announcement_entitise.dart';

class AnnouncementUseCase {
  final AnnouncementRepositorise repository;

  AnnouncementUseCase(this.repository);

  Future<List<AnnouncementEntitise>> getActiveAnnouncements() async {
    final models = await repository.getActiveAnnouncements();
    return models.map((model) => model.toEntity()).toList();
  }
}
