// list_screen.dart
import 'package:flutter/material.dart';
import 'list_screen_desktopBody.dart';
import 'list_screen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: const ListScreenMobileBody(),
      desktopBody: const ListScreenDesktopBody(),
    );
  }
}
