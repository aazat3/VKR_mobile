import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Pages/UserPage.dart';
import '/Providers/NavigationProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    final _pageOptions = [const Users()];

    return Scaffold(
      body: IndexedStack(
        index: navigation.selectedPage,
        children: _pageOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigation.selectedPage,
        onTap: (index) => navigation.setPage(index),
        elevation: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'USERS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office), label: 'POSTS'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'IMAGES'),
        ],
      ),
    );
  }
}
