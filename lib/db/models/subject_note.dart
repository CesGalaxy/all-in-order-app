import 'package:all_in_order/supabase.dart';

class SubjectNote {
  int id;
  int subjectId;
  int authorId;
  String? title;
  String? content;
  List<String>? tags;

  SubjectNote({
    required this.id,
    required this.subjectId,
    required this.authorId,
    this.title,
    this.content,
    required this.tags,
  });

  static Future<List<SubjectNote>?> fetchBySubject(int subjectId) => supabase
      .from('subject_notes')
      .select()
      .eq('subject_id', subjectId)
      .then((raw) => raw.map((e) => SubjectNote.fromJson(e)).toList());

  factory SubjectNote.fromJson(Map<String, dynamic> data) => SubjectNote(
      id: data['id'],
      subjectId: data['subject_id'],
      authorId: data['author_id'],
      title: data['title'],
      content: data['content'],
      tags: data['tags']?.cast<String>());
}
