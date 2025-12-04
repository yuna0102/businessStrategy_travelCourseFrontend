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

    /// Django /api/storages/{id}/courses/ 응답을 Course로 변환
    factory Course.fromJson(Map<String, dynamic> json) {
        return Course(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        subtitle: json['summary'] ?? '',
        durationMinutes: json['duration_minutes'] as int,
        imageUrl: json['thumbnail_url'] ?? '',
        // 아래 값들은 아직 백엔드에 없어서 임시값(목업)으로 세팅
        walkingMinutes: (json['duration_minutes'] ?? 0) is int
            ? json['duration_minutes'] as int
            : 0,
        categoryEmoji: '🍵',
        categoryBgColor: const Color(0xFFFFFBEB),
        reviewerName: json['created_by_name'] ?? '',
        reviewerMeta: '',          
        reviewAgoText: '',        
        );
    }
}