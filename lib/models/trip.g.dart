// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: json['_id'] as String,
      startLocation:
          PlaceModel.fromJson(json['startLocation'] as Map<String, dynamic>),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      guests: (json['guests'] as num).toInt(),
      budget: json['budget'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      '_id': instance.id,
      'startLocation': instance.startLocation,
      'locations': instance.locations,
      'startDate': instance.startDate.toIso8601String(),
      'guests': instance.guests,
      'budget': instance.budget,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
