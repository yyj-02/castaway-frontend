import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'CreatePage.dart';
import 'ExplorePage.dart';
import 'ProfilePage.dart';
import 'live.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const ExplorePage(),
    const CreatePage(),
    const LiveStream(),
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
              color: Color(0xffb257a84),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
              color: Color(0xffb257a84),
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.live_tv_rounded,
              color: Color(0xffb257a84),
            ),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.headphones,
              color: Color(0xffb257a84),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.man,
              color: Color(0xffb257a84),
            ),
            label: 'Profile',
          ),
        ],
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
