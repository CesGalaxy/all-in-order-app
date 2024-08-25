import '../../supabase.dart';

class Space {
  int id;
  String slug;
  String name;
  String description;
  String? avatarUrl;
  int owner;

  Space({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.owner,
  });

  static Future<Space?> fetchBySlug(String slug) async {
    try {
      final data = await supabase
          .from('spaces')
          .select()
          .eq('slug', slug)
          .limit(1)
          .maybeSingle();

      if (data == null) {
        return null;
      } else {
        return Space.fromJson(data);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Space>?> fetchAll() async {
    // Wait 5s
    // await Future.delayed(const Duration(seconds: 500));

    try {
      final data = await supabase.from('spaces').select();

      // TODO: Fix this
      return data.map((e) => Space.fromJson(e)!).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Space? fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      avatarUrl: json['avatar_url'],
      owner: json['owner'],
    );
  }
}
