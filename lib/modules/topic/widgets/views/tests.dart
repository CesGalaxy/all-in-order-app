import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/topic_test.dart';
import 'package:all_in_order/modules/topic_test/questions/question.dart';
import 'package:all_in_order/widgets/cache_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicTestsPage extends StatefulWidget {
  const TopicTestsPage({super.key});

  @override
  State<TopicTestsPage> createState() => _TopicTestsPageState();
}

class _TopicTestsPageState extends State<TopicTestsPage> {
  int _selectedIndex = 0;

  int _lastVisitedTestIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CacheHandler(
          collection:
              Provider.of<CachedCollection<TopicTestWithQuestions>>(context),
          errorAction: (_) {},
          errorDetails: (error) => error.toString(),
          emptyActionLabel: "Create Test",
          emptyAction: () {},
          builder: (context, tests, _) {
            return Row(
              children: [
                NavigationRail(
                  leading: FloatingActionButton(
                    elevation: 0,
                    onPressed: () {},
                    shape: const CircleBorder(),
                    child: const Icon(Icons.auto_awesome),
                  ),
                  destinations: [
                    const NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text('All'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.check_box_outline_blank),
                      label: Text('Not done'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.sentiment_very_dissatisfied),
                      label: Text('Worst\nscore'),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.article),
                      label: Text(tests[_lastVisitedTestIndex].name),
                    ),
                  ],
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: FloatingActionButton(
                      elevation: 0,
                      onPressed: () {},
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.add),
                    ),
                  ),
                  groupAlignment: 1,
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                DefaultTabController(
                  length: 2,
                  child: Expanded(
                    child: Scaffold(
                      appBar: const TabBar(tabs: [
                        Tab(text: 'Tests'),
                        Tab(text: 'Attempts'),
                      ]),
                      body: TabBarView(
                        children: <Widget>[
                          _selectedIndex == 0
                              ? ListView.builder(
                                  itemCount: tests.length,
                                  itemBuilder: (context, index) {
                                    final test = tests[index];
                                    return ListTile(
                                      title: Text(test.name),
                                      subtitle: Text(test.description ?? ""),
                                      onTap: () {},
                                    );
                                  },
                                )
                              : _testScreen(tests[_lastVisitedTestIndex]),
                          const Center(child: Text('Attempts')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _testScreen(TopicTestWithQuestions test) => ListView.builder(
        itemCount: test.questions.length,
        itemBuilder: (context, index) {
          final question = test.questions[index];

          return ListTile(
            title: Text(question.data.title),
            subtitle: question.data.description != null
                ? Text(question.data.description!)
                : null,
            leading: Icon(question.data.type.icon),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => question.data.preview(context),
              );
            },
          );
        },
      );
}
