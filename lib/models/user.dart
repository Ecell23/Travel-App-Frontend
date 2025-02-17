import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? phone;
  final List<String> emergencyContacts;

  User(
      {required this.id,
      required this.name,
      required this.email,
      this.imageUrl,
      this.phone,
      required this.emergencyContacts,
      });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
