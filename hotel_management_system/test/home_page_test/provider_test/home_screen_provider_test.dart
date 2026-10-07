// import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
// import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
// import 'package:test/test.dart';

// class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
//   @override
//   Future<List<Map<String, dynamic>>> getRooms() async {
//     return [
//       {
//         'roomId': 1,
//         'roomType': 'rooms',
//         'imageUrls': ['asset1.jpg'],
//         'description': 'ดี',
//         'pricePerNight': 500.0,
//         'status': 'ว่าง',
//       },
//       {
//         'roomId': 2,
//         'roomType': 'house',
//         'imageUrls': ['asset2.jpg'],
//         'description': 'บ้าน',
//         'pricePerNight': 1000.0,
//         'status': 'ไม่ว่าง',
//       },
//     ];
//   }
// }

// void main() {
//   group('HomeRepositoryImpl', () {
//     test('maps remote room data into HomeModel list', () async {
//       final repository = HomeRepositoryImpl(FakeHomeRemoteDataSource());

//       final result = await repository.getRooms();

//       expect(result, hasLength(2));
//       expect(result.first.roomId, 1);
//       expect(result.first.roomType, 'rooms');
//       expect(result.first.pricePerNight, 500);
//     });
//   });
// }
