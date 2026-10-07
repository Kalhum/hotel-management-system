import 'package:hotel_management_system/data/data_source/remote_data_source/extra_bed_remote.dart';
import 'package:hotel_management_system/data/model/extra_bed_model.dart';

abstract class ExtraBedRepository {
  Future<List<ExtraBedTypeModel>> getExtraBedTypes();
}

class ExtraBedRepositoryImpl implements ExtraBedRepository {
  final ExtraBedRemoteDataSource remoteDataSource;

  ExtraBedRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ExtraBedTypeModel>> getExtraBedTypes() async {
    final rawList = await remoteDataSource.getExtraBedTypes();
    return rawList
        .whereType<Map>()
        .map(
          (item) => ExtraBedTypeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
