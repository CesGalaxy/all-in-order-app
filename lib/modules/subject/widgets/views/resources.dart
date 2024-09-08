import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/subject.dart';
import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/subject/widgets/views/topics.dart';
import 'package:all_in_order/modules/topic/widgets/create_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectResourcesPage extends StatefulWidget {
  const SubjectResourcesPage({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectResourcesPage> createState() => _SubjectResourcesPageState();
}

class _SubjectResourcesPageState extends State<SubjectResourcesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: S.of(context).topics),
          Tab(text: S.of(context).saved),
          Tab(text: S.of(context).notes),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          SubjectTopicsPage(subject: widget.subject),
          const Text("No data"),
          const Text("No data"),
        ],
      ),
    );
  }

  void _openTopicCreationPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => TopicCreationPage(subjectId: widget.subject.id),
    ))
        .then((value) {
      if (value != null && mounted) {
        Provider.of<CachedCollection<Topic>>(context, listen: false)
            .refresh(force: true);
      }
    });
  }
}
