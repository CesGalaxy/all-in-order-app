class ProjectTask {
  int id;
  int projectId;
  String title;
  String? description;
  DateTime? dueDate;
  int? createdBy;
  DateTime createdAt;
  DateTime? updatedAt;

  ProjectTask({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.dueDate,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}