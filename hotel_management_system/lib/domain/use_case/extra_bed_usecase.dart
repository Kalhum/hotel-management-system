import 'package:hotel_management_system/data/model/extra_bed_model.dart';
import 'package:hotel_management_system/data/repositorise/extra_bed_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/extra_bed_entitise.dart';

class ExtraBedUsecase {
  final ExtraBedRepository repository;

  ExtraBedUsecase(this.repository);

  ExtraBedTypeEntitise _toEntity(ExtraBedTypeModel model) {
    return ExtraBedTypeEntitise(
      id: model.id ?? 0,
      name: model.name ?? '',
      description: model.description ?? '',
      price: double.tryParse(model.price ?? '') ?? 0.0,
      maxChildAge: model.maxChildAge ?? 0,
    );
  }

  Future<List<ExtraBedTypeEntitise>> getExtraBedTypes() async {
    final models = await repository.getExtraBedTypes();
    return models.map(_toEntity).toList();
  }
}
