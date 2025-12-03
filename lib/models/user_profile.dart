// 회원가입 시 유저 인풋 데이터 관련 모델

import 'package:flutter/material.dart';

/// 온보딩에서 선택하는 국가
enum TravelerCountry {
    us,
    uk,
    germany,
    canada,
}

extension TravelerCountryX on TravelerCountry {
    String get name {
        switch (this) {
        case TravelerCountry.us:
            return 'United States';
        case TravelerCountry.uk:
            return 'United Kingdom';
        case TravelerCountry.germany:
            return 'Germany';
        case TravelerCountry.canada:
            return 'Canada';
        }
    }

    String get flagEmoji {
        switch (this) {
        case TravelerCountry.us:
            return '🇺🇸';
        case TravelerCountry.uk:
            return '🇬🇧';
        case TravelerCountry.germany:
            return '🇩🇪';
        case TravelerCountry.canada:
            return '🇨🇦';
        }
    }

    /// CoursesPage 상단 Reddit 카드에서 쓸 문자열 (예: "🇬🇧 UK")
    String get redditCountryLabel => '$flagEmoji $shortName';

    String get shortName {
        switch (this) {
        case TravelerCountry.us:
            return 'US';
        case TravelerCountry.uk:
            return 'UK';
        case TravelerCountry.germany:
            return 'Germany';
        case TravelerCountry.canada:
            return 'Canada';
        }
    }
}

/// 온보딩에서 수집하는 사용자 정보
class UserProfile {
    final TravelerCountry country;
    final String firstName;
    final String lastName;
    final int age;

    /// Convenience getter so downstream widgets can access the Reddit label directly
    String get redditCountryLabel => country.redditCountryLabel;

    const UserProfile({
        required this.country,
        required this.firstName,
        required this.lastName,
        required this.age,
    });
}
