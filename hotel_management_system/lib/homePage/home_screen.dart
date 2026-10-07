import 'package:flutter/material.dart';
import 'package:hotel_management_system/components/bavbar/bottomNavbar.dart';

import 'package:hotel_management_system/components/bavbar/topNavbar.dart';
import 'package:hotel_management_system/core/constants.dart';
import 'package:hotel_management_system/core/form_enum.dart';
import 'package:hotel_management_system/core/typeRoom_enum.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RoomType selectedRoomType = RoomType.rooms;
  int len = 10;

  Widget _buildTabButton(String label, RoomType type) {
    bool isSelected = selectedRoomType == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Constants.primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        setState(() {
          selectedRoomType = type;

          if (type == RoomType.rooms) {
            len = 10;
          } else {
            len = 15;
          }
        });
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(top: 0, right: 0, left: 0, child: Topnavbar()),
            Positioned(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 83),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: createInputField(InputFieldType.search),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Constants.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search,
                                color: Constants.white, size: 35),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabButton("ห้องพัก", RoomType.rooms),
                        const SizedBox(width: 10),
                        _buildTabButton("บ้านพัก", RoomType.house),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: createBoxShowData(selectedRoomType, len),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(bottom: 0, right: 0, left: 0, child: Bottomnavbar()),
          ],
        ),
      ),
    );
  }
}
