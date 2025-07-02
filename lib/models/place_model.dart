class PlaceModel {
  final String placeId;
  final String placeName;
  final int day;
  
  PlaceModel({required this.placeId, required this.placeName, required this.day});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['placeId'] as String,
      placeName: json['placeName'] as String,
      day: json['day'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'day': day,
    };
  }
}