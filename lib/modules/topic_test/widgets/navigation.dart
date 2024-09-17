import 'package:all_in_order/db/models/topic_test.dart';
import 'package:all_in_order/modules/topic_test/widgets/views/questions.dart';
import 'package:flutter/material.dart';

class TopicTestNavigation extends StatelessWidget {
  const TopicTestNavigation({super.key, required this.test});

  final TopicTestWithQuestions test;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text(test.name),
              bottom: const TabBar(tabs: [
                Tab(text: 'Questions', icon: Icon(Icons.list)),
                Tab(text: 'Attempts', icon: Icon(Icons.history)),
                Tab(text: 'AI', icon: Icon(Icons.auto_awesome)),
              ]),
            ),
            body: TabBarView(children: [
              TestQuestions(test: test),
              const Center(child: Text('Attempts')),
              const Center(child: Text('AI')),
            ]),
          ),
        ),
      );
}
