import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/supabase.dart';

class Course {
  int id;
  String name;
  String? description;
  DateTime createdAt;

  Course({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  static Future<List<Course>?> fetchAll() => supabase
      .from('courses')
      .select('*')
      .then((raw) => raw.map(Course.fromJson).toList());

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

class CourseWithSubjects extends Course {
  List<Subject> subjects;

  CourseWithSubjects({
    required super.id,
    required super.name,
    required super.createdAt,
    required this.subjects,
  });

  static Future<List<CourseWithSubjects>?> fetchAll() => supabase
      .from('courses')
      .select('*, subjects(*)')
      .then((raw) => raw.map(CourseWithSubjects.fromJson).toList());

  factory CourseWithSubjects.fromJson(Map<String, dynamic> json) =>
      CourseWithSubjects(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['created_at']),
        subjects: json['subjects']
            .map<Subject>((e) => Subject.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
