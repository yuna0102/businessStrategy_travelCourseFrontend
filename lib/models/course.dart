// lib/models/course.dart
import 'package:flutter/material.dart';

/// UI 전용 코스 모델 (나중에 API 모델로 교체 가능)
class Course {
    final String id;
    final String title;
    final String subtitle;
    final String imageUrl;
    final int walkingMinutes;
    final String categoryEmoji; // 아이콘/이모지
    final Color categoryBgColor;

    final int durationMinutes;

    final String reviewerName;
    final String reviewerMeta;   // (🇬🇧, 28)
    final String reviewAgoText;  // 3 weeks ago

    Course({
        required this.id,
        required this.title,
        required this.subtitle,
        required this.imageUrl,
        required this.walkingMinutes,
        required this.categoryEmoji,
        required this.categoryBgColor,
        required this.reviewerName,
        required this.reviewerMeta,
        required this.reviewAgoText,
        required this.durationMinutes, 
    });

    factory Course.fromJson(Map<String, dynamic> json) {
      // 0) 코스 id 문자열로 먼저 뽑기
        final String idStr = json['id'].toString();

        // 1) 태그 문자열 가져오기 (없으면 빈 문자열)
        final String tag = (json['tags'] ?? '') as String;

        // 2) 태그에 따라 이모지 + 배경색 매핑
        String emoji = '🛍️'; // 기본값: K-Culture 느낌
        Color bgColor = const Color(0xFFFFF7ED); // 기본 부드러운 베이지

        if (tag == 'Food') {
            emoji = '🥘';
            bgColor = const Color(0xFFFFF1E6); // 음식 느낌의 오렌지 톤
        } else if (tag == 'Traditional') {
            emoji = '🏛️';
            bgColor = const Color(0xFFE5F0FF); // 전통/히스토릭 느낌의 블루 톤
        } else if (tag == 'K-Culture') {
            emoji = '🛍️';
            bgColor = const Color(0xFFFCE7F3); // 쇼핑/케이컬쳐 느낌의 핑크 톤
        }

        // 3) 목업 프로필 리스트 (이름 / 메타 / 방문 시점)
        const mockProfiles = [
            {
                'name': 'James',
                'meta': '32',        
                'ago': '2 weeks ago',
            },
            {
                'name': 'Emma',
                'meta': '29',
                'ago': '3 weeks ago',
            },
            {
                'name': 'Satoshi',
                'meta': '35',
                'ago': '5 days ago',
            },
            {
                'name': 'Olivia',
                'meta': '27',
                'ago': '1 week ago',
            },
            ];

        // 4) 코스 id 기반으로 "랜덤처럼" 보이도록 인덱스 결정 (하지만 항상 동일)
        final int profileIndex =
            idStr.hashCode.abs() % mockProfiles.length;
        final selectedProfile = mockProfiles[profileIndex];

        // 5) Course 인스턴스 생성
        return Course(
            id: idStr,
            title: json['title'] ?? '',
            subtitle: json['summary'] ?? '',
            durationMinutes: json['duration_minutes'] as int,
            imageUrl: json['thumbnail_url'] ?? '',
            walkingMinutes: (json['duration_minutes'] ?? 0) is int
                ? json['duration_minutes'] as int
                : 0,
            categoryEmoji: emoji,
            categoryBgColor: bgColor,
            // 백엔드 필드 대신 위에서 선택한 목업 프로필 적용
            reviewerName: selectedProfile['name'] as String,
            reviewerMeta: selectedProfile['meta'] as String,
            reviewAgoText: selectedProfile['ago'] as String,
        );
        }
}