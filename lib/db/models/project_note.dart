import '../../supabase.dart';

class ProjectNote {
  int id;
  int project;
  int author;
  String title;
  String? content;
  List<String>? tags;

  ProjectNote({
    required this.id,
    required this.project,
    required this.author,
    required this.title,
    required this.content,
    required this.tags,
  });

  static Future<List<ProjectNote>?> fetchByProject(int projectId) async {
    try {
      final data = await supabase
          .from('project_notes')
          .select()
          .eq('project_id', projectId);
          // .order('id', ascending: false);

      print(data);

      return data.map((e) => ProjectNote.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  factory ProjectNote.fromJson(Map<String, dynamic> data) {
    return ProjectNote(
        id: data['id'],
        project: data['project_id'],
        author: data['author'],
        title: data['title'],
        content: data['content'],
        tags: data['tags']?.cast<String>()
    );
  }
}