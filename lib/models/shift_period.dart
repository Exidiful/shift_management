import 'package:flutter/material.dart';

class ShiftPeriod {
  String? id;
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Color color;
  String teamId;

  ShiftPeriod({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.teamId,
  });

  factory ShiftPeriod.fromMap(Map<String, dynamic> map, String id) {
    return ShiftPeriod(
      id: id,
      name: map['name'] ?? '',
      startTime: TimeOfDay(
        hour: map['startHour'] ?? 0,
        minute: map['startMinute'] ?? 0,
      ),
      endTime: TimeOfDay(
        hour: map['endHour'] ?? 0,
        minute: map['endMinute'] ?? 0,
      ),
      color: Color(map['color'] ?? 0xFF000000),
      teamId: map['teamId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
      'color': color.value,
      'teamId': teamId,
    };
  }

  ShiftPeriod copyWith({
    String? id,
    String? name,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Color? color,
    String? teamId,
  }) {
    return ShiftPeriod(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      teamId: teamId ?? this.teamId,
    );
  }
}