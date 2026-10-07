import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

import '../../../../util/model/model.dart';

enum RoomType {
  rooms,
  house,
}

Widget createBoxShowData(
  RoomType type,
  List<HomeEntitise> rooms, {
  int len = 10,
  int crossAxisCount = 2,
  Future<void> Function(HomeEntitise room)? onRoomTap,
}) {
  final filteredRooms = rooms
      .where((room) {
        final selectedType = type == RoomType.rooms ? 'rooms' : 'house';
        return room.roomType.toLowerCase() == selectedType;
      })
      .take(len)
      .toList();

  if (filteredRooms.isEmpty) {
    return const Center(child: Text('ไม่มีข้อมูล'));
  }

  return GridView.builder(
    padding: const EdgeInsets.only(bottom: 12),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.74,
    ),
    itemCount: filteredRooms.length,
    itemBuilder: (context, index) {
      final room = filteredRooms[index];
      final imagePath = room.imageUrls.isNotEmpty
          ? room.imageUrls.first
          : 'assets/images/rooms/room1.jpg';

      return InkWell(
        onTap: () async {
          if (onRoomTap != null) {
            await onRoomTap(room);
            return;
          }
          Navigator.pushNamed(
            context,
            '/room_detail',
            arguments: RoomDetailArguments(
              roomId: room.roomId,
              roomType: room.roomType,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            );
                          },
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.name.isNotEmpty
                                ? room.name
                                : (room.roomType.toLowerCase() == 'house'
                                    ? 'บ้านพัก'
                                    : 'ห้องพัก'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (room.building.isNotEmpty && room.building != '0')
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'ตึก ${room.building}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      bedType: room.bedType,
                      capacity: room.capacity,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '฿${room.pricePerNight.toStringAsFixed(room.pricePerNight.truncateToDouble() == room.pricePerNight ? 0 : 2)}',
                      style: const TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow({
  required String bedType,
  required int capacity,
}) {
  return Row(
    children: [
      Icon(Icons.king_bed_outlined, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          bedType.isNotEmpty ? bedType : 'เตียงเดี่ยว',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 8),
      Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Text(
        '$capacity คน',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    ],
  );
}
