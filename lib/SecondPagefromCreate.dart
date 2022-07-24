import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'CreatePage.dart';
import 'ExplorePage.dart';
import 'ProfilePage.dart';
import 'Livepage.dart';

class SecondPageC extends StatefulWidget {
  const SecondPageC({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SecondPageC> createState() => _SecondPageCState();
}

class _SecondPageCState extends State<SecondPageC> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[
    const ExplorePage(),
    const CreatePage(),
    const LivePage(),
    const HomePage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,

            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,

            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.live_tv_rounded,

            ),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.headphones,

            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.man,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xffb257a84),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetOptions[_selectedIndex],
        ],
      )),
    );
  }
}
