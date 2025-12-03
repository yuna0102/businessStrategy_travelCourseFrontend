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
    });
}