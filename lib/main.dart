import 'package:flutter/material.dart';
import 'screens/country_select_page.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.light,
      home: const CountrySelectPage(), // 첫 화면 명시
    );
  }
}