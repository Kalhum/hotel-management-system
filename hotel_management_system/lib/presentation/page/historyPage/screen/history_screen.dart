// history_screen.dart
import 'package:flutter/material.dart';
import 'historyPage_desktopBody.dart';
import 'historyPage_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: HistoryScreenMobileBody(),
      desktopBody: HistoryScreenDesktopBody(),
    );
  }
}
