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
          child: Column(
        children: [
          // top navbar
          const Topnavbar(),
          // content body
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: createInputField(InputFieldType.search),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Perform search action
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Constants.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Constants.white,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              _buildTabButton("ห้องพัก", RoomType.rooms),
              const SizedBox(width: 10),
              _buildTabButton("บ้านพัก", RoomType.house),
            ],
          ),
          Expanded(child: createBoxShowData(selectedRoomType, len)),
          const Bottomnavbar(),
        ],
      )),
    );
  }
}
