import 'package:all_in_order/supabase.dart';
import 'package:all_in_order/utils/db.dart';

class Topic {
  int id;
  int subjectId;
  String title;
  String description;
  DateTime createdAt;

  Topic({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  static Future<Topic?> fetchById(int id) => supabase
      .from('topics')
      .select()
      .eq('id', id)
      .limit(1)
      .maybeSingle()
      .then((raw) => tryToParse(raw, Topic.fromJson));

  static Future<List<Topic>?> fetchBySubject(int subjectId) => supabase
      .from('topics')
      .select()
      .eq('subject_id', subjectId)
      .then((raw) => raw.map(Topic.fromJson).toList());

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'],
        subjectId: json['subject_id'],
        title: json['title'],
        description: json['description'],
        createdAt: DateTime.parse(json['created_at']),
      );
}
