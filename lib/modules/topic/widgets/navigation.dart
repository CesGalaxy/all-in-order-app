import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/modules/topic/widgets/views/home.dart';
import 'package:all_in_order/modules/topic/widgets/views/resources.dart';
import 'package:all_in_order/modules/topic/widgets/views/tests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicNavigation extends StatefulWidget {
  const TopicNavigation({super.key});

  @override
  State<TopicNavigation> createState() => _TopicNavigationState();
}

class _TopicNavigationState extends State<TopicNavigation>
    with SingleTickerProviderStateMixin {
  late PageController _pageViewController = PageController();
  late AnimationController _titleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  int _activeIndex = 0;

  late double width;
  late double height;

  @override
  void initState() {
    _pageViewController = PageController();
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    final topic = Provider.of<Topic>(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _activeIndex == 0 ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: Text(topic.title),
        ),
        actions: <Widget>[
          AnimatedOpacity(
            opacity: _activeIndex == 0 ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ),
          AnimatedOpacity(
            opacity: _activeIndex == 0 ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: IconButton(icon: const Icon(Icons.chat), onPressed: () {}),
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          setState(() {
            _activeIndex = index;
          });
        },
        children: [
          TopicHome(topic: topic),
          TopicResources(topic: topic),
          const TopicTestsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _activeIndex,
        onDestinationSelected: (index) {
          _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Tests',
          ),
        ],
      ),
      floatingActionButton: <Widget?>[
        FloatingActionButton(
          heroTag: 'home',
          onPressed: () {},
          child: const Icon(Icons.chat),
        ),
        FloatingActionButton(
          heroTag: 'resources',
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        // FloatingActionButton(
        //   heroTag: 'tests',
        //   onPressed: () {},
        //   child: const Icon(Icons.bar_chart),
        // ),
        null,
      ][_activeIndex],
    );
  }
}
