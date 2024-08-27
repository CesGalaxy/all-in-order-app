import '../../supabase.dart';

class SubjectTask {
  int id;
  int projectId;
  String title;
  String? description;
  DateTime? dueDate;
  int? createdBy;
  DateTime createdAt;
  DateTime? updatedAt;

  SubjectTask({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.dueDate,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  static Future<List<SubjectTask>?> fetchByProject(int subjectId) async {
    final data = await supabase
        .from('subject_tasks')
        .select()
        .eq('subject_id', subjectId);

    return data.map((e) => SubjectTask.fromJson(e)).toList();
  }

  factory SubjectTask.fromJson(Map<String, dynamic> json) {
    return SubjectTask(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['pending_date'] != null
          ? DateTime.parse(json['pending_date'])
          : null,
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
