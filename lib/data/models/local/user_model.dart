import 'package:superhorn/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.email,
    required super.city,
    required super.country,
  });

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'city': city, 'country': country};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      city: json['city'],
      country: json['country'],
    );
  }
}
