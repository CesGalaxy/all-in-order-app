import 'package:all_in_order/db/models/course_member.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';

class CourseMembersManager extends StatefulWidget {
  const CourseMembersManager({super.key, required this.courseId});

  final int courseId;

  @override
  State<CourseMembersManager> createState() => _CourseMembersManagerState();
}

class _CourseMembersManagerState extends State<CourseMembersManager> {
  late final CachedCollection<CourseMember> _members =
      CachedCollection<CourseMember>(
    cacheDuration: const Duration(minutes: 5),
    fetch: () => CourseMember.getCourseMembers(widget.courseId),
  );

  @override
  Widget build(BuildContext context) {
    return CacheHandler(
      collection: _members,
      errorAction: (_) {},
      emptyActionLabel: "No members",
      emptyAction: () => Navigator.of(context).pop(),
      builder: (context, members, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Members"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _members.refresh(force: true),
            ),
          ],
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            itemCount: _members.items.length,
            itemBuilder: (context, index) {
              final member = _members.items[index];

              return ListTile(
                title: Text("Profile ID: ${member.profileId}"),
                subtitle: Text("Joined at: ${member.joinedAt}"),
                trailing: member.isAdmin
                    ? const Icon(Icons.star)
                    : const Icon(Icons.person),
              );
            },
          ),
          onRefresh: () => _members.refresh(force: true),
        ),
      ),
    );
  }
}
