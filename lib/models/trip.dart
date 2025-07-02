import 'package:json_annotation/json_annotation.dart';
import 'package:travel_app/models/place_model.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final String id;
  final PlaceModel startLocation;
  final List<PlaceModel> locations;
  final DateTime startDate;
  final int guests;
  final String? budget;
  final DateTime createdAt;
  final DateTime updatedAt;



  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  Trip({required this.id, required this.startLocation, required this.locations, required this.startDate, required this.guests, required this.budget, required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toJson() => _$TripToJson(this);
}