import 'package:all_in_order/db/models/profile.dart';
import 'package:all_in_order/supabase.dart';

class CourseMember {
  int profileId;
  int courseId;
  bool isAdmin;
  DateTime joinedAt;

  CourseMember({
    required this.profileId,
    required this.courseId,
    required this.isAdmin,
    required this.joinedAt,
  });

  static Future<List<CourseMember>?> getCourseMembers(int courseId) => supabase
      .from('course_members')
      .select()
      .eq('course_id', courseId)
      .then((raw) => raw.map(CourseMember.fromJson).toList());

  factory CourseMember.fromJson(Map<String, dynamic> json) => CourseMember(
        profileId: json['profile_id'],
        courseId: json['course_id'],
        isAdmin: json['is_admin'],
        joinedAt: DateTime.parse(json['joined_at']),
      );
}

class CourseMemberWithProfile extends CourseMember {
  final Profile profile;

  CourseMemberWithProfile({
    required super.profileId,
    required super.courseId,
    required super.isAdmin,
    required super.joinedAt,
    required this.profile,
  });

  static Future<List<CourseMemberWithProfile>?> getCourseMembers(
          int courseId) =>
      supabase
          .from('course_members')
          .select("*, profile:profiles(*)")
          .eq('course_id', courseId)
          .then((raw) => raw.map(CourseMemberWithProfile.fromJson).toList());

  factory CourseMemberWithProfile.fromJson(Map<String, dynamic> json) =>
      CourseMemberWithProfile(
        profileId: json['profile_id'],
        courseId: json['course_id'],
        isAdmin: json['is_admin'],
        joinedAt: DateTime.parse(json['joined_at']),
        profile: Profile.fromJson(json['profile']),
      );
}
