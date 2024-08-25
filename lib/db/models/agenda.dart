class Agenda {
  int id;
  String slug;
  String title;
  String resume;
  String description;

  Agenda({
    required this.id,
    required this.slug,
    required this.title,
    required this.resume,
    required this.description,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      resume: json['resume'],
      description: json['description'],
    );
  }
}
