// api/storages/ JSON을 객체로 받을 것임

class StorageLocation {
    final int id;
    final String name;
    final String type;
    final String address;
    final double rating;
    final int reviewCount;
    final double priceSmallPerHour;
    final double priceMediumPerHour;
    final double priceLargePerHour;
    final String openTimeText;

    StorageLocation({
        required this.id,
        required this.name,
        required this.type,
        required this.address,
        required this.rating,
        required this.reviewCount,
        required this.priceSmallPerHour,
        required this.priceMediumPerHour,
        required this.priceLargePerHour,
        required this.openTimeText,
    });

    factory StorageLocation.fromJson(Map<String, dynamic> json) {
        double _toDouble(dynamic v) {
        if (v == null) return 0.0;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0.0;
        }

        return StorageLocation(
        id: json['id'] as int,
        name: json['name'] as String,
        type: json['type'] as String,
        address: json['address'] as String? ?? '',
        rating: _toDouble(json['rating']),
        reviewCount: (json['review_count'] ?? 0) as int,
        priceSmallPerHour: _toDouble(json['price_small_per_hour']),
        priceMediumPerHour: _toDouble(json['price_medium_per_hour']),
        priceLargePerHour: _toDouble(json['price_large_per_hour']),
        openTimeText: json['open_time_text'] as String? ?? '',
        );
    }
}