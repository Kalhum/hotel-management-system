// start_work_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'room_detail_form.dart';

class StartWorkScreen extends StatefulWidget {
  final String roomNo;
  final bool isGuestRequest;
  final bool isAlreadyCleaning;

  const StartWorkScreen({
    super.key,
    required this.roomNo,
    this.isGuestRequest = false,
    this.isAlreadyCleaning = false,
  });

  @override
  State<StartWorkScreen> createState() => _StartWorkScreenState();
}

class _StartWorkScreenState extends State<StartWorkScreen> {
  bool _isStarting = false;
  bool _isCompleting = false;
  late bool _hasStarted = widget.isGuestRequest && widget.isAlreadyCleaning;

  Future<void> _startWork() async {
    if (_isStarting) return;

    setState(() => _isStarting = true);

    final provider = context.read<HousekeeperRoomCheckScreenProvider>();

    // reuse endpoint เดิมที่ RoomDetailFormScreen ใช้บันทึกสถานะความสะอาดห้อง
    // (PUT /housekeeper/rooms/:roomNo/cleaning-status) — ไม่ต้องเพิ่ม endpoint
    // ใหม่ เพราะ column/endpoint นี้คือตัวเดียวกับที่กำหนด room.status ที่โชว์
    // อยู่ในหน้ารายการห้องอยู่แล้ว
    final success = await provider.saveRoomDetail(
      roomNo: widget.roomNo,
      cleaningStatus: "กำลังทำความสะอาด",
    );

    if (!mounted) return;

    if (success) {
      if (widget.isGuestRequest) {
        await provider.getRooms();
        if (!mounted) return;
        setState(() {
          _hasStarted = true;
          _isStarting = false;
        });
        return;
      }

      setState(() => _isStarting = false);

      // ใช้ pushReplacement แทน push เพื่อไม่ให้กดย้อนกลับจากหน้ารายละเอียด
      // แล้วเจอหน้า "เริ่มทำงาน" ซ้ำ (กดเริ่มงานได้แค่ครั้งเดียวต่อการเข้าห้อง)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: RoomDetailFormScreen(roomNo: widget.roomNo),
          ),
        ),
      );
    } else {
      setState(() => _isStarting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage.isEmpty
                ? 'ไม่สามารถเริ่มงานได้'
                : provider.errorMessage,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completeGuestCleaning() async {
    if (_isCompleting) return;

    setState(() => _isCompleting = true);
    final provider = context.read<HousekeeperRoomCheckScreenProvider>();
    final success = await provider.saveRoomDetail(
      roomNo: widget.roomNo,
      cleaningStatus: "ทำความสะอาดเสร็จสิ้น",
    );

    if (!mounted) return;

    if (success) {
      await provider.getRooms();
      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text("ทำความสะอาดห้อง ${widget.roomNo} เสร็จแล้ว"),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    setState(() => _isCompleting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage.isEmpty
              ? 'ไม่สามารถบันทึกสถานะได้'
              : provider.errorMessage,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      appBar: AppBar(
        title: Text(
          "ห้อง ${widget.roomNo}",
          style: const TextStyle(
            fontSize: Constants.fontSizeTitle,
            fontWeight: Constants.fontWeightBold,
          ),
        ),
        backgroundColor: Constants.white,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cleaning_services_rounded,
                size: 72,
                color: Constants.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                widget.isGuestRequest
                    ? _hasStarted
                        ? "ทำความสะอาดห้อง ${widget.roomNo} เสร็จแล้วหรือยัง?"
                        : "แขกขอให้ทำความสะอาดห้อง ${widget.roomNo}"
                    : "พร้อมเริ่มทำความสะอาดห้อง ${widget.roomNo} หรือยัง?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: Constants.fontSizeTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: widget.isGuestRequest && _hasStarted
                      ? _isCompleting
                          ? "กำลังบันทึก..."
                          : "ทำความสะอาดเสร็จแล้ว"
                      : _isStarting
                          ? "กำลังเริ่มงาน..."
                          : "เริ่มทำความสะอาด",
                  onTap: _isStarting || _isCompleting
                      ? () {}
                      : widget.isGuestRequest && _hasStarted
                          ? _completeGuestCleaning
                          : _startWork,
                  color: widget.isGuestRequest && _hasStarted
                      ? Colors.green
                      : Constants.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
