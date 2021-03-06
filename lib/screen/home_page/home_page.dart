import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/screen/home_page/book_list_page/book_list_page.dart';
import 'package:tipitaka_myanmar/screen/home_page/bookmark_page/bookmark_page.dart';
import 'package:tipitaka_myanmar/screen/home_page/recent_page/recent_page.dart';
import 'package:tipitaka_myanmar/screen/home_page/search_page/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const BookListPage(),
    const RecentPage(),
    const BookmarkPage(),
    const SerachPage(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 56,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Recent'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_border_outlined),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmark'),
          NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search'),
        ],
      ),
    );
  }
}
