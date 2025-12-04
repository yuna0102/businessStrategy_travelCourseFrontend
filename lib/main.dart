import 'package:flutter/material.dart';
import 'screens/country_select_page.dart';
import 'theme/app_theme.dart';
import 'models/user_profile.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<UserProfile>(
      create: (_) => const UserProfile(
        country: TravelerCountry.germany,
        firstName: 'User First name',
        lastName: 'User Last name',
        age: 25,),
      child: const TravelLightApp(),
    ),
  );
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