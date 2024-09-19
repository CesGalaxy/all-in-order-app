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

  factory CourseMember.fromJson(Map<String, dynamic> json) {
    return CourseMember(
      profileId: json['profileId'],
      courseId: json['courseId'],
      isAdmin: json['isAdmin'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
