class CafeDto {
  final String? id;
  final String? displayName;
  final double? rating;
  final int? userRatingCount;
  final String? formattedAddress;
  final List<dynamic>? photos;
  final double? latitude;
  final double? longitude;

  const CafeDto({
    this.id,
    this.displayName,
    this.rating,
    this.userRatingCount,
    this.formattedAddress,
    this.photos,
    this.latitude,
    this.longitude,
  });

  factory CafeDto.fromJson(Map<String, dynamic> json) {
    final location = json['location'];

    return CafeDto(
      id: json['id']?.toString(),

      displayName: json['displayName']?['text']?.toString(),

      rating: (json['rating'] as num?)?.toDouble(),

      userRatingCount: (json['userRatingCount'] as num?)?.toInt(),

      formattedAddress: json['formattedAddress']?.toString(),

      photos: json['photos'] is List
          ? List<dynamic>.from(json['photos'])
          : null,

      latitude: location is Map<String, dynamic>
          ? (location['latitude'] as num?)?.toDouble()
          : null,

      longitude: location is Map<String, dynamic>
          ? (location['longitude'] as num?)?.toDouble()
          : null,
    );
  }

  String? get firstPhotoName {
    if (photos == null || photos!.isEmpty) {
      return null;
    }

    final firstPhoto = photos!.first;

    if (firstPhoto is Map<String, dynamic>) {
      return firstPhoto['name']?.toString();
    }

    return null;
  }

  bool get hasLocation {
    return latitude != null && longitude != null;
  }
}
