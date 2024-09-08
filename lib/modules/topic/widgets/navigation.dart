import 'package:all_in_order/db/models/topic.dart';
import 'package:all_in_order/modules/topic/widgets/home.dart';
import 'package:all_in_order/modules/topic/widgets/resources.dart';
import 'package:flutter/material.dart';

class TopicNavigation extends StatefulWidget {
  const TopicNavigation({super.key, required this.topic});

  final Topic topic;

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

    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _activeIndex == 0 ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: Text(widget.topic.title),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(icon: const Icon(Icons.chat), onPressed: () {}),
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
          TopicHome(topic: widget.topic),
          TopicResources(topic: widget.topic),
          // TopicTests(topic: widget.topic),
          const Text("data"),
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
    );
  }
}
