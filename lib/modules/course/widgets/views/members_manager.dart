import 'package:all_in_order/db/models/course_member.dart';
import 'package:all_in_order/utils/cached_collection.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseMembersManager extends StatefulWidget {
  const CourseMembersManager({super.key, required this.courseId});

  final int courseId;

  @override
  State<CourseMembersManager> createState() => _CourseMembersManagerState();
}

class _CourseMembersManagerState extends State<CourseMembersManager> {
  late final CachedCollection<CourseMemberWithProfile> _members =
      CachedCollection<CourseMemberWithProfile>(
    cacheDuration: const Duration(minutes: 5),
    fetch: () => CourseMemberWithProfile.getCourseMembers(widget.courseId),
  );

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _members,
      builder: (context, _) => CacheHandler(
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
                onPressed: _refreshIndicatorKey.currentState?.show,
              ),
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => _members.refresh(force: true),
            child: ListView.builder(
              itemCount: _members.items.length,
              itemBuilder: (context, index) {
                final member = _members.items[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: member.profile.avatarUrl != null
                        ? NetworkImage(member.profile.avatarUrl!)
                        : null,
                    child: member.profile.avatarUrl != null
                        ? null
                        : Text(member.profile.name[0]),
                  ),
                  title: Text(member.profile.name),
                  subtitle: Text(
                      "Joined at: ${DateFormat.yMEd().format(member.joinedAt)}"),
                  trailing: member.isAdmin
                      ? const Icon(Icons.star)
                      : const Icon(Icons.person),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Remove member"),
                        content: Text(
                            "Are you sure you want to remove ${member.profile.name} from the course?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Remove member
                              _members.refresh(force: true);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Remove"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
