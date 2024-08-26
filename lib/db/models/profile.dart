import 'package:all_in_order/supabase.dart';

class Profile {
  int id;
  String userId;
  String name;
  String username;
  String? avatarUrl;
  String? bio;

  // Constructor
  Profile({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    this.avatarUrl,
    this.bio,
  });

  static Future<Profile?> fetchByUserId(String userId) async {
    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();

      if (data == null) {
        return null;
      } else {
        return Profile.fromJson(data);
      }
    } catch (e) {
      print(e);
      supabase.auth.signOut();
      return null;
    }
  }

  static Future<Profile?> fetchById(int id) async {
    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .limit(1)
          .maybeSingle();

      if (data == null) {
        return null;
      } else {
        return Profile.fromJson(data);
      }
    } catch (e) {
      print(e);
      supabase.auth.signOut();
      return null;
    }
  }

  // From JSON
  static Profile? fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
    );
  }
}