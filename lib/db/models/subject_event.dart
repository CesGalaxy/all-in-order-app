import 'package:all_in_order/supabase.dart';
import 'package:all_in_order/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SubjectEvent {
  int id;
  int subjectId;
  String title;
  String? details;
  SubjectEventType type;
  DateTime startsAt;
  DateTime? endsAt;
  DateTime? updatedAt;
  DateTime createdAt;

  SubjectEvent({
    required this.id,
    required this.subjectId,
    required this.title,
    this.details,
    required this.type,
    required this.startsAt,
    this.endsAt,
    this.updatedAt,
    required this.createdAt,
  });

  static Future<SubjectEvent?> fetchById(int id) => supabase
      .from('subject_events')
      .select()
      .eq('id', id)
      .limit(1)
      .maybeSingle()
      .then((raw) => tryToParse(raw, SubjectEvent.fromJson));

  static Future<List<SubjectEvent>?> fetchBySubject(int subjectId) => supabase
      .from('subject_events')
      .select()
      .eq('subject_id', subjectId)
      .then((raw) => raw.map(SubjectEvent.fromJson).toList());

  factory SubjectEvent.fromJson(Map<String, dynamic> json) => SubjectEvent(
        id: json['id'],
        subjectId: json['subject_id'],
        title: json['title'],
        details: json['details'],
        type: SubjectEventTypeExtension.fromName(json['type']),
        startsAt: DateTime.parse(json['starts_at']),
        endsAt: tryToParse(json['ends_at'] as String, DateTime.parse),
        updatedAt: tryToParse(json['updated_at'] as String, DateTime.parse),
        createdAt: DateTime.parse(json['created_at']),
      );

  bool isInDay(DateTime day) => (type == SubjectEventType.task)
      ? isSameDay(endsAt, day)
      : isSameDay(startsAt, day);
}

enum SubjectEventType {
  event,
  task,
  reminder,
  other,
}

extension SubjectEventTypeExtension on SubjectEventType {
  static SubjectEventType fromName(String name) {
    switch (name) {
      case 'EVENT':
        return SubjectEventType.event;
      case 'TASK':
        return SubjectEventType.task;
      case 'REMINDER':
        return SubjectEventType.reminder;
      case 'OTHER':
        return SubjectEventType.other;
      default:
        throw Exception('Invalid name');
    }
  }

  IconData get icon {
    switch (this) {
      case SubjectEventType.event:
        return Icons.event;
      case SubjectEventType.task:
        return Icons.assignment;
      case SubjectEventType.reminder:
        return Icons.alarm;
      case SubjectEventType.other:
        return Icons.info;
    }
  }
}
