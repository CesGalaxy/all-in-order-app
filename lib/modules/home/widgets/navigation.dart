import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/home/widgets/home_page.dart';
import 'package:all_in_order/modules/user/widgets/me.dart';
import 'package:flutter/material.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with SingleTickerProviderStateMixin {
  static const _navbarAnimationDuration = Duration(milliseconds: 200);

  late PageController _pageViewController = PageController(initialPage: 1);

  late AnimationController _navbarAnimationController =
      AnimationController(vsync: this, duration: _navbarAnimationDuration);

  int _activeIndex = 1;

  bool _showNavbar = true;

  @override
  void initState() {
    _pageViewController = PageController(initialPage: 1);
    _navbarAnimationController =
        AnimationController(vsync: this, duration: _navbarAnimationDuration);

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
            body: FilledButton(
                onPressed: _toggleBottomNavbar,
                child: const Text("Coming soon!")),
          ),
          const HomePage(),
          const MePage(),
        ],
        onPageChanged: (index) => setState(() => _activeIndex = index),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _navbarAnimationController,
        builder: (BuildContext context, Widget? child) => AnimatedContainer(
          duration: _navbarAnimationDuration,
          height: _showNavbar ? 80 : 0,
          child: AnimatedOpacity(
            duration: _navbarAnimationDuration,
            opacity: _showNavbar ? 1 : 0,
            child: child,
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) => setState(() {
            _pageViewController.animateToPage(
              index,
              duration: _navbarAnimationDuration,
              curve: Curves.bounceOut,
            );
          }),
          selectedIndex: _activeIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: const Icon(Icons.view_agenda),
              icon: const Icon(Icons.view_agenda_outlined),
              label: S.of(context).agenda,
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.home),
              icon: const Icon(Icons.home_outlined),
              label: S.of(context).home,
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.person),
              icon: const Icon(Icons.person_outline),
              label: S.of(context).me,
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
