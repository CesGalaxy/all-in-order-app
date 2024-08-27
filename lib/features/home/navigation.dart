import 'package:all_in_order/features/home/home_page.dart';
import 'package:flutter/material.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with SingleTickerProviderStateMixin {
  late PageController _pageViewController = PageController(initialPage: 1);

  late AnimationController _navbarAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  int _activeIndex = 1;
  bool _showNavbar = true;

  @override
  void initState() {
    _pageViewController = PageController(initialPage: 1);
    _navbarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _navbarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          Scaffold(
            body: FilledButton(onPressed: _toggleBottomNavbar, child: const Text("Toggle1")),
          ),
          const HomePage(),
          Scaffold(
            body: FilledButton(onPressed: _toggleBottomNavbar, child: const Text("Toggle1")),
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _navbarAnimationController,
        builder: (BuildContext context, Widget? child) {
          return AnimatedContainer(
            // color: Colors.blueGrey,
            duration: const Duration(milliseconds: 200),
            height: _showNavbar ? 80 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showNavbar ? 1 : 0,
              child: child,
            ),
          );
        },
        child: NavigationBar(
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
              selectedIcon: Icon(Icons.view_agenda),
              icon: Icon(Icons.view_agenda_outlined),
              label: 'Agenda',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBottomNavbar() {
    _showNavbar = !_showNavbar;
    _navbarAnimationController.forward(from: 0);
  }
}
