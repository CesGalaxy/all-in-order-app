import '../../supabase.dart';

class SubjectEvent {
  int id;
  int subjectId;
  String title;
  String? details;
  String type;
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

  static Future<SubjectEvent?> fetchById(int id) async {
    final data = await supabase
        .from('subject_events')
        .select()
        .eq('id', id)
        .limit(1)
        .maybeSingle();

    return data != null ? SubjectEvent.fromJson(data) : null;
  }

  static Future<List<SubjectEvent>?> fetchBySubject(int subjectId) async {
    final data = await supabase
        .from('subject_events')
        .select()
        .eq('subject_id', subjectId);

    return data.map(SubjectEvent.fromJson).toList();
  }

  factory SubjectEvent.fromJson(Map<String, dynamic> json) {
    return SubjectEvent(
      id: json['id'],
      subjectId: json['subject_id'],
      title: json['title'],
      details: json['details'],
      type: json['type'],
      startsAt: DateTime.parse(json['starts_at']),
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at']) : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
