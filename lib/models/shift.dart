import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  String? id;
  DateTime date;
  String title;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String employeeId;
  String shiftPeriodId;

  Shift({
    this.id,
    required this.date,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.employeeId,
    required this.shiftPeriodId,
  });

  factory Shift.fromMap(Map<String, dynamic> map, String id) {
    return Shift(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      title: map['title'] ?? '',
      startTime: TimeOfDay.fromDateTime((map['startTime'] as Timestamp).toDate()),
      endTime: TimeOfDay.fromDateTime((map['endTime'] as Timestamp).toDate()),
      employeeId: map['employeeId'] ?? '',
      shiftPeriodId: map['shiftPeriodId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'title': title,
      'startTime': Timestamp.fromDate(DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute)),
      'endTime': Timestamp.fromDate(DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute)),
      'employeeId': employeeId,
      'shiftPeriodId': shiftPeriodId,
    };
  }

  Shift copyWith({
    String? id,
    DateTime? date,
    String? title,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? employeeId,
    String? shiftPeriodId,
  }) {
    return Shift(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      employeeId: employeeId ?? this.employeeId,
      shiftPeriodId: shiftPeriodId ?? this.shiftPeriodId,
    );
  }
}