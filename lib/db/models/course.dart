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

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}