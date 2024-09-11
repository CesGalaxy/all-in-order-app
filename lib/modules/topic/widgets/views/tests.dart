import 'package:all_in_order/api/cached_collection.dart';
import 'package:all_in_order/db/models/topic_test.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(tabs: [
          Tab(text: 'Tests'),
          Tab(text: 'Attempts'),
        ]),
        body: CacheHandler(
          collection: Provider.of<CachedCollection<TopicTest>>(context),
          errorAction: (_) {},
          errorDetails: (error) => error.toString(),
          emptyActionLabel: "Create Test",
          emptyAction: () {},
          builder: (context, tests, _) => SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  leading: FloatingActionButton(
                    elevation: 0,
                    onPressed: () {},
                    child: const Icon(Icons.auto_awesome),
                  ),
                  destinations: [
                    const NavigationRailDestination(
                      icon: Icon(Icons.all_inbox),
                      label: Text('All'),
                    ),
                    ...tests.map((test) => NavigationRailDestination(
                          icon: const Icon(Icons.article),
                          label: Text(test.name),
                        )),
                  ],
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                const Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Center(child: Text('Tests')),
                      Center(child: Text('Attempts')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
