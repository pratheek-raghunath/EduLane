import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:edulane/people.dart';
import 'package:edulane/profile.dart';
import 'package:edulane/subject.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<Home> {
  int selectedIndex = 0;
  final _pageOptions = [
    Subject(),
    People(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: const NavDrawer(),
        body: _pageOptions[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(icon: Icons.library_books, title: 'Subject'),
              TabItem(icon: Icons.people_alt_rounded, title: 'People'),
              TabItem(icon: Icons.account_circle_rounded, title: 'Profile'),
            ],
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
            }));
  }
}
