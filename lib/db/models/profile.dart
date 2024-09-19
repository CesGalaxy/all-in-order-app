import 'package:all_in_order/supabase.dart';
import 'package:all_in_order/utils/db.dart';

class Profile {
  int id;
  String userId;
  String name;
  String username;
  String? avatarUrl;
  String? bio;

  Profile({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    this.avatarUrl,
    this.bio,
  });

  static Future<Profile?> fetchById(int id) => supabase
      .from('profiles')
      .select()
      .eq('id', id)
      .limit(1)
      .maybeSingle()
      .then((raw) => tryToParse(raw, Profile.fromJson));

  static Future<Profile?> fetchByUserId(String userId) => supabase
      .from('profiles')
      .select()
      .eq('user_id', userId)
      .limit(1)
      .maybeSingle()
      .then((raw) => tryToParse(raw, Profile.fromJson));

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        username: json['username'],
        avatarUrl: json['avatar_url'],
        bio: json['bio'],
      );
}
