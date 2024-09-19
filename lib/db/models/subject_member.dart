import 'package:all_in_order/supabase.dart';

class SubjectMember {
  int profileId;
  int subjectId;
  bool isAdmin;
  DateTime joinedAt;

  SubjectMember({
    required this.profileId,
    required this.subjectId,
    required this.isAdmin,
    required this.joinedAt,
  });

  static Future<List<SubjectMember>?> getCourseMembers(int courseId) => supabase
      .from('subject_members')
      .select()
      .eq('profile_id', courseId)
      .then((raw) => raw.map(SubjectMember.fromJson).toList());

  factory SubjectMember.fromJson(Map<String, dynamic> json) {
    return SubjectMember(
      profileId: json['profile_id'],
      subjectId: json['subject_id'],
      isAdmin: json['is_admin'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }
}
