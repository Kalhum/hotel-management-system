// room_condition_check_screen.dart
import 'package:flutter/material.dart';
import '../../../../util/model/model.dart';
import 'RoomConditionCheckPage_desktopBody.dart';
import 'RoomConditionCheckPage_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';


class RoomConditionCheckScreen extends StatefulWidget {
  const RoomConditionCheckScreen({super.key});
  @override
  State<RoomConditionCheckScreen> createState() =>
      _RoomConditionCheckScreenState();
}

class _RoomConditionCheckScreenState extends State<RoomConditionCheckScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as RoomConditionCheckArguments; 

    return ResponsiveLayout(
      mobileBody: RoomConditionCheckScreenMobileBody(
        roomId: args.roomId,
        bookingId: args.bookingId,
      ),
      desktopBody: RoomConditionCheckScreenDesktopBody(
        roomId: args.roomId,
        bookingId: args.bookingId,
      ),
    );
  }
}