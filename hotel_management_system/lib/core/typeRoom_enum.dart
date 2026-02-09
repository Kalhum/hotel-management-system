import 'package:flutter/material.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/roomDetailPage/room_detail_screen.dart';

enum RoomType {
  rooms,
  house,
}

Widget createBoxShowData(RoomType type, int len) {
  final String folder = type == RoomType.rooms ? 'rooms' : 'houses';
  final String fileName = type == RoomType.rooms ? 'room' : 'house';
  final String label = type == RoomType.rooms ? '(Room)' : '(House)';

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: len,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            List<String> images = [
              'assets/images/$folder/$fileName${index + 1}.jpg',
              'assets/images/$folder/$fileName${(index % 3) + 1}.jpg', // รูปสำรอง
            ];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomDetailScreen(
                          roomId: index + 1,
                          roomType: type,
                          imageUrls: images,
                        )));
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
                    child: Image.asset(
                      'assets/images/$folder/$fileName${index + 1}.jpg', //
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายการที่ ${index + 1} $label',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(),
                      const SizedBox(height: 8),
                      Text(
                        '฿${(index + 1) * 500}',
                        style: const TextStyle(
                            color: Constants.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildInfoRow() {
  return Row(
    children: [
      Icon(Icons.king_bed_outlined, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Text('1 เตียง', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      const SizedBox(width: 10),
      Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Text('2 คน', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
  );
}
