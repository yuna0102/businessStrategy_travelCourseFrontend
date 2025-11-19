import 'package:flutter/material.dart';
import 'screens/find_storage_page.dart';

void main() {
  runApp(const TravelLightApp());
}

class TravelLightApp extends StatelessWidget {
  const TravelLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelLight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B34FF),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: FindStoragePage(),
    );
  }
}