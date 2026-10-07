// housekeeper_room_check_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/screen/start_work_screen.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entitise/housekeeper_room_entity.dart';
import '../../../../util/widget/components/bavbar/bottomNavbar.dart';
import '../../../../util/widget/components/bavbar/topNavbar.dart';
import '../../../../util/widget/core/constants.dart';

enum _RoomKind {
  closed,
  doNotDisturb,
  guestRequest,
  vacantPending,
  cleaning,
  review,
  done,
  occupied,
  unknown,
}

class _RoomView {
  final _RoomKind kind;
  final String label;
  final Color color;
  final IconData icon;

  const _RoomView(this.kind, this.label, this.color, this.icon);
}

const _legendViews = [
  _RoomView(_RoomKind.vacantPending, "ไม่มีแขก รอทำความสะอาด", Colors.red,
      Icons.person_off),
  _RoomView(_RoomKind.guestRequest, "แขกขอให้ทำความสะอาด", Colors.pink,
      Icons.notifications_active),
  _RoomView(_RoomKind.cleaning, "กำลังทำความสะอาด", Colors.teal,
      Icons.cleaning_services),
  _RoomView(_RoomKind.occupied, "มีแขกพักอยู่", Colors.orange, Icons.person),
  _RoomView(
      _RoomKind.doNotDisturb, "ห้ามรบกวน", Colors.red, Icons.do_not_disturb_on),
  _RoomView(
      _RoomKind.review, "รอตรวจสอบ", Colors.blue, Icons.fact_check_outlined),
  _RoomView(
      _RoomKind.done, "เสร็จสิ้น", Colors.green, Icons.check_circle_outline),
  _RoomView(_RoomKind.closed, "ปิดปรับปรุง", Colors.grey, Icons.block),
];

class HousekeeperRoomCheckScreen extends StatefulWidget {
  const HousekeeperRoomCheckScreen({super.key});

  @override
  State<HousekeeperRoomCheckScreen> createState() =>
      _HousekeeperRoomCheckScreenState();
}

class _HousekeeperRoomCheckScreenState
    extends State<HousekeeperRoomCheckScreen> {
  final TextEditingController _searchController = TextEditingController();
  _RoomKind? _selectedKind;

  void _toggleKind(_RoomKind kind) {
    setState(() => _selectedKind = _selectedKind == kind ? null : kind);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HousekeeperRoomCheckScreenProvider>().getRooms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _RoomView _describe(HousekeeperRoomEntity room) {
    final status = room.status.trim();
    final pending = status.contains("รอทำความสะอาด") ||
        status.contains("ยังไม่ได้ทำความสะอาด");

    if (status.contains("ปิดปรับปรุง")) {
      return const _RoomView(
          _RoomKind.closed, "ปิดปรับปรุง", Colors.grey, Icons.block);
    }
    if (status.contains("ห้ามรบกวน")) {
      return const _RoomView(_RoomKind.doNotDisturb, "แขกพัก ห้ามรบกวน",
          Colors.deepPurple, Icons.do_not_disturb_on);
    }
    if (pending && room.hasGuest) {
      return const _RoomView(_RoomKind.guestRequest, "แขกขอให้ทำความสะอาด",
          Colors.pink, Icons.notifications_active);
    }
    if (pending) {
      return const _RoomView(_RoomKind.vacantPending, "ไม่มีแขก รอทำความสะอาด",
          Colors.red, Icons.person_off);
    }
    if (status.contains("กำลังทำความสะอาด")) {
      return const _RoomView(_RoomKind.cleaning, "กำลังทำความสะอาด",
          Colors.teal, Icons.cleaning_services);
    }
    if (status.contains("รอตรวจสอบ")) {
      return const _RoomView(_RoomKind.review, "รอตรวจสอบ", Colors.blue,
          Icons.fact_check_outlined);
    }
    if (status.contains("เสร็จสิ้น")) {
      return const _RoomView(_RoomKind.done, "เสร็จสิ้น", Colors.green,
          Icons.check_circle_outline);
    }
    if (status.contains("ลูกค้าพัก")) {
      return const _RoomView(
          _RoomKind.occupied, "มีแขกพักอยู่", Colors.orange, Icons.person);
    }
    return _RoomView(
        _RoomKind.unknown, status, Colors.grey, Icons.help_outline);
  }

  // ใช้ field "building" จริงจาก backend (rooms.building) ไม่ใช่เดาจาก roomNo
  String _getBuildingLabel(String building) {
    if (building.isEmpty || building == '0') return "ไม่ระบุตึก";
    return "ตึก $building";
  }

  Map<String, List<HousekeeperRoomEntity>> _groupByBuilding(
      List<HousekeeperRoomEntity> rooms) {
    final Map<String, List<HousekeeperRoomEntity>> grouped = {};
    for (final room in rooms) {
      final building = _getBuildingLabel(room.building);
      grouped.putIfAbsent(building, () => []).add(room);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.roomNo.compareTo(b.roomNo));
    }
    return grouped;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: _legendViews.map(_legendItem).toList(),
    );
  }

  Widget _legendItem(_RoomView view) {
    final selected = _selectedKind == view.kind;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _toggleKind(view.kind),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? view.color.withOpacity(0.15) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? view.color : Colors.grey.shade300,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(view.icon, size: 14, color: view.color),
            const SizedBox(width: 4),
            Text(view.label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(List<HousekeeperRoomEntity> rooms) {
    final kinds = rooms.map((room) => _describe(room).kind).toList();
    final guestRequests =
        kinds.where((kind) => kind == _RoomKind.guestRequest).length;
    final vacantPending =
        kinds.where((kind) => kind == _RoomKind.vacantPending).length;

    return Row(
      children: [
        Expanded(
          child: _summaryCard(_RoomKind.guestRequest, "แขกขอให้ทำความสะอาด",
              guestRequests, Colors.pink, Icons.notifications_active),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(_RoomKind.vacantPending, "ไม่มีแขก รอทำความสะอาด",
              vacantPending, Colors.red, Icons.person_off),
        ),
      ],
    );
  }

  Widget _summaryCard(
      _RoomKind kind, String label, int count, Color color, IconData icon) {
    final selected = _selectedKind == kind;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _toggleKind(kind),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(selected ? 0.25 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.6),
            width: selected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[800])),
            ),
            Text("$count",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomTile(HousekeeperRoomEntity room) {
    final view = _describe(room);
    final cannotEnter =
        view.kind == _RoomKind.closed || view.kind == _RoomKind.doNotDisturb;

    return GestureDetector(
      onTap: cannotEnter
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: context.read<HousekeeperRoomCheckScreenProvider>(),
                    child: StartWorkScreen(
                      roomNo: room.roomNo,
                      isGuestRequest: room.hasGuest &&
                          (view.kind == _RoomKind.guestRequest ||
                              view.kind == _RoomKind.cleaning),
                      isAlreadyCleaning: view.kind == _RoomKind.cleaning,
                    ),
                  ),
                ),
              );
            },
      child: Tooltip(
        message: view.label,
        child: Container(
          decoration: BoxDecoration(
            color: view.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: view.color, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(view.icon, size: 16, color: view.color),
              const SizedBox(height: 2),
              Text(
                room.roomNo,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: view.color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingSection(
      String buildingLabel, List<HousekeeperRoomEntity> rooms) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          title: Row(
            children: [
              Text(buildingLabel,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${rooms.length} ห้อง",
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: rooms.length,
              itemBuilder: (context, index) => _buildRoomTile(rooms[index]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 100, bottom: 120, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "แผนผังห้องพัก",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _searchController,
                    onChanged: (query) => context
                        .read<HousekeeperRoomCheckScreenProvider>()
                        .filterRooms(query),
                    decoration: InputDecoration(
                      hintText: "ค้นหาหมายเลขห้อง (เช่น 101...)",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Constants.inputFieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Consumer<HousekeeperRoomCheckScreenProvider>(
                    builder: (context, provider, _) => provider.isLoading
                        ? const SizedBox.shrink()
                        : _buildSummary(provider.filteredRooms),
                  ),
                  const SizedBox(height: 15),
                  _buildLegend(),
                  const SizedBox(height: 15),
                  Consumer<HousekeeperRoomCheckScreenProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (provider.errorMessage.isNotEmpty) {
                        return Center(child: Text(provider.errorMessage));
                      }
                      final rooms = _selectedKind == null
                          ? provider.filteredRooms
                          : provider.filteredRooms
                              .where((room) =>
                                  _describe(room).kind == _selectedKind)
                              .toList();
                      if (rooms.isEmpty) {
                        return Center(
                          child: _selectedKind == null
                              ? const Text("ไม่พบหมายเลขห้องที่ค้นหา")
                              : TextButton(
                                  onPressed: () =>
                                      setState(() => _selectedKind = null),
                                  child: const Text(
                                      "ไม่มีห้องในสถานะนี้ กดเพื่อแสดงทั้งหมด"),
                                ),
                        );
                      }
                      final grouped = _groupByBuilding(rooms);
                      final buildingKeys = grouped.keys.toList()..sort();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildingKeys
                            .map((building) => _buildBuildingSection(
                                building, grouped[building]!))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Positioned(
                top: 0, left: 0, right: 0, child: Topnavbar(widthFactor: 0.2)),
            const Positioned(
                bottom: 0, left: 0, right: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}
