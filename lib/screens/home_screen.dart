import 'package:flutter/material.dart';
import 'package:phonebook/screens/contacts_screen.dart';
import 'package:phonebook/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _currentIndexTab = 1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndexTab,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        iconSize: 30.0,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndexTab = index;
            _pageController.animateToPage(
              index,
              duration: Duration(
                milliseconds: 600,
              ),
              curve: Curves.easeIn,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            title: Text('Phone'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text('Contacts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favorites'),
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (index) => setState(() {
          _currentIndexTab = index;
        }),

        controller: _pageController,
        children: <Widget>[
          FavoritesScreen(),
          ContactsScreen(),
          FavoritesScreen(),
        ],
      ),
    );
  }
}
