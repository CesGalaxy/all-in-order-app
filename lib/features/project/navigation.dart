import 'package:all_in_order/db/models/project.dart';
import 'package:all_in_order/features/project/home.dart';
import 'package:flutter/material.dart';

import '../task/create_page.dart';

class ProjectNavigation extends StatefulWidget {
  const ProjectNavigation({super.key, required this.project});

  final Project project;

  @override
  State<ProjectNavigation> createState() => _ProjectNavigationState();
}

class _ProjectNavigationState extends State<ProjectNavigation>
    with SingleTickerProviderStateMixin {
  late PageController _pageViewController = PageController();
  late AnimationController _titleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  int _activeIndex = 0;

  bool _showTitle = false;

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
          opacity: _activeIndex != 0 || _showTitle ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Text(widget.project.name),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.add),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.note_add),
                  title: Text("Add Note"),
                ),
              ),
              PopupMenuItem(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateTaskPage(project: widget.project))),
                child: const ListTile(
                  leading: Icon(Icons.task),
                  title: Text("Add Task"),
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Add Event"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          ProjectHome(
              project: widget.project, setTitleVisibility: _setTitleVisibility),
          const Text("Hello world!"),
          const Text("Hello world!"),
          const Text("Hello world!"),
          const Text("Hello world!"),
        ],
        onPageChanged: (index) {
          setState(() {
            _activeIndex = index;
            _titleController.forward(from: 0);
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceOut,
            );
          });
        },
        selectedIndex: _activeIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.view_agenda),
            icon: Icon(Icons.view_agenda_outlined),
            label: "Resources",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task_alt),
            icon: Icon(Icons.task_alt_outlined),
            label: "Tasks",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendar",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people_alt),
            icon: Icon(Icons.people_alt_outlined),
            label: "Team",
          ),
        ],
      ),
    );
  }

  void _setTitleVisibility(bool visible) {
    _titleController.animateTo(visible ? 1 : 0);
  }
}
