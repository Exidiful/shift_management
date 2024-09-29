import 'package:flutter/foundation.dart';

class Employee {
  final String id;
  final String name;
  final String position;
  final String? teamId;
  final String email;
  final String phoneNumber;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    this.teamId,
    required this.email,
    required this.phoneNumber,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      teamId: json['teamId'],
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'teamId': teamId,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? position,
    String? teamId,
    String? email,
    String? phoneNumber,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      teamId: teamId ?? this.teamId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}