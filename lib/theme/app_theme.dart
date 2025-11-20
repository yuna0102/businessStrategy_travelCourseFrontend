import 'package:flutter/material.dart';

class AppColors {
    // Brand
    static const primary = Color(0xFF8400FF); // 메인 컬러
    static const primarySoft = Color(0xFFF3E9FF);
    // 버튼 사용 컬러
    static const filterSelected = Color(0xFF8400FF);

    // Neutrals / background
    static const background = Color(0xFFF8F9FA); // 화면 전체 배경
    static const card = Colors.white;
    static const cardSoft = Color(0xFFF7F3FF);

    // Borders
    static const borderSubtle = Color(0xFFE5E7EB);
    static const borderSoft = Color(0xFFF3F4F6);

    // Text
    static const textMain = Color(0xFF111827);
    static const textSub = Color(0xFF4B5563);
    static const textMuted = Color(0xFF6B7280);

    // Etc
    static const warning = Color(0xFFFFB020);
    static const accentBlue = Color(0xFF007AFF); // 필요하면 iOS 블루
    }

    class AppTextStyles {
    static const pageTitle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
    );

    static const chip = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSub,
    );

    static const body = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSub,
    );

    static const caption = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
    );

    static const price = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
    );

    // 섹션 타이틀 (BottomSheet 상단에 쓰임)
    static const sectionTitle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
    );

  // 굵은 바디 텍스트 (Small / Medium / Large, 가격 텍스트용으로 쓰임)
    static const bodyBold = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
    );
    }

    class AppTheme {
    static ThemeData light = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTextStyles.pageTitle,
        iconTheme: IconThemeData(color: AppColors.textMain),
        ),
    );
}