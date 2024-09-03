import 'package:all_in_order/db/models/topic.dart';
import 'package:flutter/material.dart';

class TopicResources extends StatefulWidget {
  const TopicResources({super.key, required this.topic});

  final Topic topic;

  @override
  State<TopicResources> createState() => _TopicResourcesState();
}

class _TopicResourcesState extends State<TopicResources> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Documents'),
              Tab(text: 'Mind maps'),
              Tab(text: 'Other'),
            ],
          ),
          body: TabBarView(
              children: [
                Text('Videos'),
                Text('Articles'),
                Text('Books'),
              ]
          ),
        )
    );
  }
}
