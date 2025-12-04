// lib/models/course_detail.dart
import 'package:flutter/material.dart';

class CourseStopDetail {
    final int id;
    final int order;
    final String name;
    final String description;
    final String category;
    final String imageUrl;
    final int? walkMinutesFromPrev;
    final int? distanceFromPrevM;
    final int? stayMinutes;
    final double? rating;

    CourseStopDetail({
        required this.id,
        required this.order,
        required this.name,
        required this.description,
        required this.category,
        required this.imageUrl,
        this.walkMinutesFromPrev,
        this.distanceFromPrevM,
        this.stayMinutes,
        this.rating,
    });

    factory CourseStopDetail.fromJson(Map<String, dynamic> json) {
        return CourseStopDetail(
        id: json['id'] as int,
        order: json['order'] as int,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        category: json['category'] ?? '',
        imageUrl: json['image_url'] ?? '',
        walkMinutesFromPrev: json['walk_minutes_from_prev'] as int?,
        distanceFromPrevM: json['distance_from_prev_m'] as int?,
        stayMinutes: json['stay_minutes'] as int?,
        rating: (json['rating'] as num?)?.toDouble(),
        );
    }
}

class CourseRecommenderMini {
    final int id;
    final String name;
    final String avatarUrl;
    final String countryFlagEmoji;

    CourseRecommenderMini({
        required this.id,
        required this.name,
        required this.avatarUrl,
        required this.countryFlagEmoji,
    });

    factory CourseRecommenderMini.fromJson(Map<String, dynamic> json) {
        return CourseRecommenderMini(
        id: json['id'] as int,
        name: json['name'] ?? '',
        avatarUrl: json['avatar_url'] ?? '',
        countryFlagEmoji: json['country_flag_emoji'] ?? '',
        );
    }
    }

    class CourseRecommenderSummary {
    final int totalCount;
    final CourseRecommenderMini? representative;
    final List<CourseRecommenderMini> similarTravelers;
    final int similarTravelersExtraCount;

    CourseRecommenderSummary({
        required this.totalCount,
        required this.representative,
        required this.similarTravelers,
        required this.similarTravelersExtraCount,
    });

    factory CourseRecommenderSummary.fromJson(Map<String, dynamic> json) {
        final repJson = json['representative'];
        final similarJson = json['similar_travelers'] as List<dynamic>? ?? [];

        return CourseRecommenderSummary(
        totalCount: json['total_count'] as int? ?? 0,
        representative: repJson != null
            ? CourseRecommenderMini.fromJson(repJson as Map<String, dynamic>)
            : null,
        similarTravelers: similarJson
            .map((e) =>
                CourseRecommenderMini.fromJson(e as Map<String, dynamic>))
            .toList(),
        similarTravelersExtraCount:
            json['similar_travelers_extra_count'] as int? ?? 0,
        );
    }
}

class CourseDetail {
    final int id;
    final String title;
    final String summary;
    final int durationMinutes;
    final double rating;
    final int ratingCount;
    final String thumbnailUrl;
    final String createdByName;
    final String createdByAvatarUrl;
    final String tags;
    final int storageId;
    final String storageName;
    final List<CourseStopDetail> stops;
    final CourseRecommenderSummary recommenderSummary;

    CourseDetail({
        required this.id,
        required this.title,
        required this.summary,
        required this.durationMinutes,
        required this.rating,
        required this.ratingCount,
        required this.thumbnailUrl,
        required this.createdByName,
        required this.createdByAvatarUrl,
        required this.tags,
        required this.storageId,
        required this.storageName,
        required this.stops,
        required this.recommenderSummary,
    });

    factory CourseDetail.fromJson(Map<String, dynamic> json) {
        final storageJson = json['storage'] as Map<String, dynamic>? ?? {};
        final stopsJson = json['stops'] as List<dynamic>? ?? [];

        return CourseDetail(
        id: json['id'] as int,
        title: json['title'] ?? '',
        summary: json['summary'] ?? '',
        durationMinutes: json['duration_minutes'] as int? ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        ratingCount: json['rating_count'] as int? ?? 0,
        thumbnailUrl: json['thumbnail_url'] ?? '',
        createdByName: json['created_by_name'] ?? '',
        createdByAvatarUrl: json['created_by_avatar_url'] ?? '',
        tags: json['tags'] ?? '',
        storageId: storageJson['id'] as int? ?? 0,
        storageName: storageJson['name'] ?? '',
        stops: stopsJson
            .map((e) => CourseStopDetail.fromJson(e as Map<String, dynamic>))
            .toList(),
        recommenderSummary: CourseRecommenderSummary.fromJson(
            json['recommender_summary'] as Map<String, dynamic>? ?? {},
        ),
        );
    }
}