class PlaceModel {
  final String placeId;
  final String placeName;
  final int day;
  final double? latitude;
  final double? longitude;
  final List<AttractionModel>? attractions;
  final List<HotelModel>? hotels; 
  
  PlaceModel({
    required this.placeId, 
    required this.placeName, 
    required this.day,
    this.latitude,
    this.longitude,
    this.attractions,
    this.hotels,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['placeId'] as String,
      placeName: json['placeName'] as String,
      day: json['day'] as int,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      attractions: json['attractions'] != null 
        ? (json['attractions'] as List).map((e) => AttractionModel.fromJson(e)).toList()
        : null,
      hotels: json['hotels'] != null 
        ? (json['hotels'] as List).map((e) => HotelModel.fromJson(e)).toList()
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'placeName': placeName,
      'day': day,
      'latitude': latitude,
      'longitude': longitude,
      'attractions': attractions?.map((e) => e.toJson()).toList(),
      //'hotels': hotels?.map((e) => e.toJson()).toList(),
    };
  }
}

class AttractionModel {
  final String placeId;
  final String name;
  final String image;
  final double rating;
  final String type;
  
  AttractionModel({
    required this.placeId,
    required this.name,
    required this.image,
    required this.rating,
    required this.type,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      placeId: json['placeId'],
      name: json['name'],
      image: json['image'],
      rating: json['rating'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'name': name,
      'image': image,
      'rating': rating,
      'type': type,
    };
  }
} 

class HotelModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String description;

  HotelModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.description,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      rating: json['rating'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'description': description,
    };
  }
}