import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:edulane/people.dart';
import 'package:edulane/profile.dart';
import 'package:edulane/subject.dart';
import 'package:flutter/material.dart';
import 'teacher.dart';

class Home extends StatefulWidget {
  final Class c;

  Home({required this.c});

  @override
  _BottomNavBarState createState() => _BottomNavBarState(c: c);
}

class _BottomNavBarState extends State<Home> {
  int selectedIndex = 0;
  final Class c;

  late List<Widget> _pageOptions;

  _BottomNavBarState({required this.c});

  void initState() {
    _pageOptions = [
      Subject(c: c),
      People(),
      Profile(),
    ];
  }

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
