import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/announcement_remote.dart';
import 'package:hotel_management_system/data/model/announcement_model.dart';

abstract class AnnouncementRepositorise {
  Future<List<AnnouncementModel>> getActiveAnnouncements();
}

class AnnouncementRepositoriseImpl implements AnnouncementRepositorise {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<AnnouncementModel>> getActiveAnnouncements() async {
    try {
      return await remoteDataSource.getActiveAnnouncements();
    } on SocketException {
      throw Exception('ไม่มีการเชื่อมต่ออินเทอร์เน็ต');
    } catch (error) {
      throw Exception('โหลดข่าวสารไม่สำเร็จ: $error');
    }
  }
}
