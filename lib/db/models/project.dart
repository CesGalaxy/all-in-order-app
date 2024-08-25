import '../../supabase.dart';

class Project {
  int id;
  int space;
  String slug;
  String name;
  String resume;
  String description;
  String? route;
  String? headingUrl;
  String? avatarUrl;
  int owner;

  Project({
    required this.id,
    required this.space,
    required this.slug,
    required this.name,
    required this.resume,
    required this.description,
    required this.route,
    required this.headingUrl,
    required this.avatarUrl,
    required this.owner,
  });

  static Future<Project?> fetchBySlug(String slug) async {
    try {
      final data = await supabase
          .from('projects')
          .select()
          .eq('slug', slug)
          .limit(1)
          .maybeSingle();

      if (data == null) {
        return null;
      } else {
        return Project.fromJson(data);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Project>?> fetchBySpace(int spaceId) async {
    try {
      final data = await supabase
          .from('projects')
          .select()
          .eq('space_id', spaceId)
          .order('id', ascending: false);

      print(data);

      return data.map((e) => Project.fromJson(e)!).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Project? fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      space: json['space_id'],
      slug: json['slug'],
      name: json['name'],
      resume: json['resume'],
      description: json['description'],
      route: json['route'],
      headingUrl: json['heading_url'],
      avatarUrl: json['avatar_url'],
      owner: json['owner'],
    );
  }
}