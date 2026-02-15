import 'package:flutter/material.dart';
import 'package:hotel_management_system/Splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Prompt',
        useMaterial3: true,
      ),
    );
  }
}
