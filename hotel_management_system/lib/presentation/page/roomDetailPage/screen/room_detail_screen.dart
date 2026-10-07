// room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/model/model.dart';
import '../../homePage/companents/typeRoom_enum.dart';
import 'roomDetailScreen_desktopBody.dart';
import 'roomDetailScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';
import '../provider/room_detail_screen_provider.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late final String roomId;
  late final RoomType roomType;
  bool _isArgsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isArgsLoaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as RoomDetailArguments;
      roomId = args.roomId;
      roomType = args.roomType.toLowerCase() == 'house'
          ? RoomType.house
          : RoomType.rooms;
      _isArgsLoaded = true;
      final checkIn = args.checkIn;
      final checkOut = args.checkOut;
      final initialDateRange = checkIn != null && checkOut != null
          ? DateTimeRange(start: checkIn, end: checkOut)
          : null;

      // เรียก getRoomDetail ตรงนี้แทน initState เพราะตอนนี้มี roomId/roomType แล้ว
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RoomDetailScreenProvider>().getRoomDetail(
              roomId,
              roomType,
              initialDateRange: initialDateRange,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: RoomDetailScreenMobileBody(
        roomId: roomId,
        roomType: roomType,
      ),
      desktopBody: RoomDetailScreenDesktopBody(
        roomId: roomId,
        roomType: roomType,
      ),
    );
  }
}
