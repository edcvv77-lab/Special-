import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final TimeOfDay time;
  final List<int> days; // 1 = Monday, 7 = Sunday
  final int importance; // 1 to 5
  final bool isCompletedToday;

  Habit({
    required this.id,
    required this.name,
    required this.time,
    required this.days,
    required this.importance,
    this.isCompletedToday = false,
  });

  Habit copyWith({
    String? id,
    String? name,
    TimeOfDay? time,
    List<int>? days,
    int? importance,
    bool? isCompletedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      days: days ?? this.days,
      importance: importance ?? this.importance,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time_hour': time.hour,
      'time_minute': time.minute,
      'days': days,
      'importance': importance,
      'isCompletedToday': isCompletedToday,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map, String documentId) {
    return Habit(
      id: documentId,
      name: map['name'] ?? '',
      time: TimeOfDay(hour: map['time_hour'] ?? 0, minute: map['time_minute'] ?? 0),
      days: List<int>.from(map['days'] ?? []),
      importance: map['importance'] ?? 3,
      isCompletedToday: map['isCompletedToday'] ?? false,
    );
  }
}
