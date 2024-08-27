import '../../supabase.dart';

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

  static Future<Topic?> fetchById(int id) async {
    final data = await supabase
        .from('topics')
        .select()
        .eq('id', id)
        .limit(1)
        .maybeSingle();

    return data != null ? Topic.fromJson(data) : null;
  }

  static Future<List<Topic>?> fetchBySubject(int subjectId) async {
    final data = await supabase
        .from('topics')
        .select()
        .eq('subject_id', subjectId);

    return data.map(Topic.fromJson).toList();
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      subjectId: json['subject_id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}