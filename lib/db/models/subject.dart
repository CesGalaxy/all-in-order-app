import 'package:flutter/material.dart';

class Subject {
  int id;
  int courseId;
  String name;
  String? description;
  Color color;
  DateTime createdAt;

  Subject({
    required this.id,
    required this.courseId,
    required this.name,
    this.description,
    required this.color,
    required this.createdAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      description: json['description'],
      color: Color(json['color'] ?? Colors.blue),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
