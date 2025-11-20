// lib/models/storage_location.dart

import 'package:flutter/foundation.dart';

/// ----------------------
///  보관소 타입(enum)
/// ----------------------
enum StorageType {
    stationLocker,
    privateStorage,
    localStorage, // Cafe → Local 로 변경
    }

    extension StorageTypeX on StorageType {
    /// UI에 보여줄 라벨
    String get label {
        switch (this) {
        case StorageType.stationLocker:
            return 'Station Locker';
        case StorageType.privateStorage:
            return 'Private Storage';
        case StorageType.localStorage:
            return 'Local Storage';
        }
    }

    /// 백엔드(Django)에서 쓰는 문자열 값
    String get backendValue {
        switch (this) {
        case StorageType.stationLocker:
            return 'STATION_LOCKER';
        case StorageType.privateStorage:
            return 'PRIVATE_STORAGE';
        case StorageType.localStorage:
            return 'LOCAL_STORAGE';
        }
    }

    /// 역으로, 문자열을 enum 으로 바꾸는 헬퍼
    static StorageType fromBackend(String raw) {
        switch (raw) {
        case 'STATION_LOCKER':
            return StorageType.stationLocker;
        case 'PRIVATE_STORAGE':
            return StorageType.privateStorage;
        case 'LOCAL_STORAGE':
            return StorageType.localStorage;
        default:
            return StorageType.stationLocker;
        }
    }
    }

    /// ----------------------
    ///  지역 필터(enum)
    /// ----------------------
    enum DistrictFilter {
    yongsan,
    jongno,
    mapo,
    }

    extension DistrictFilterX on DistrictFilter {
    /// 상단 필터 버튼에 표시할 한글 라벨
    String get labelKo {
        switch (this) {
        case DistrictFilter.yongsan:
            return 'Yongsan';
        case DistrictFilter.jongno:
            return 'Jongno';
        case DistrictFilter.mapo:
            return 'Mapo';
        }
    }

    /// 백엔드 쿼리 파라미터 값
    String get backendValue {
        switch (this) {
        case DistrictFilter.yongsan:
            return 'YONGSAN';
        case DistrictFilter.jongno:
            return 'JONGNO';
        case DistrictFilter.mapo:
            return 'MAPO';
        }
    }
    }

    /// ----------------------
    ///  StorageLocation 모델
    /// ----------------------
    class StorageLocation {
    final int id;
    final String name;
    final StorageType type;
    final String address;
    final String district; // ex) 'YONGSAN'
    final double? latitude;
    final double? longitude;
    final double rating;
    final int reviewCount;
    final double priceSmallPerHour;
    final double priceMediumPerHour;
    final double priceLargePerHour;
    final String openTimeText;
    final int? distanceFromCenterM;

    StorageLocation({
        required this.id,
        required this.name,
        required this.type,
        required this.address,
        required this.district,
        this.latitude,
        this.longitude,
        required this.rating,
        required this.reviewCount,
        required this.priceSmallPerHour,
        required this.priceMediumPerHour,
        required this.priceLargePerHour,
        required this.openTimeText,
        this.distanceFromCenterM,
    });

    factory StorageLocation.fromJson(Map<String, dynamic> json) {
        double? _toDouble(dynamic v) {
        if (v == null) return null;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString());
        }

        return StorageLocation(
        id: json['id'] as int,
        name: json['name'] as String,
        type: StorageTypeX.fromBackend(json['type'] as String),
        address: json['address'] as String,
        district: json['district'] as String? ?? '',
        latitude: _toDouble(json['latitude']),
        longitude: _toDouble(json['longitude']),
        rating: _toDouble(json['rating']) ?? 0.0,
        reviewCount: json['review_count'] as int? ?? 0,
        priceSmallPerHour: _toDouble(json['price_small_per_hour']) ?? 0.0,
        priceMediumPerHour: _toDouble(json['price_medium_per_hour']) ?? 0.0,
        priceLargePerHour: _toDouble(json['price_large_per_hour']) ?? 0.0,
        openTimeText: json['open_time_text'] as String? ?? '',
        distanceFromCenterM: json['distance_from_center_m'] as int?,
        );
    }

    Map<String, dynamic> toJson() {
        return {
        'id': id,
        'name': name,
        'type': type.backendValue,
        'address': address,
        'district': district,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
        'review_count': reviewCount,
        'price_small_per_hour': priceSmallPerHour,
        'price_medium_per_hour': priceMediumPerHour,
        'price_large_per_hour': priceLargePerHour,
        'open_time_text': openTimeText,
        'distance_from_center_m': distanceFromCenterM,
        };
    }
}