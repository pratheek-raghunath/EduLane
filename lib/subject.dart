import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:edulane/navbar.dart';
import 'package:flutter/material.dart';

class Subject extends StatelessWidget {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('EduLane'),
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.dashboard_rounded, title: 'Dashboard'),
            TabItem(icon: Icons.people_alt_rounded, title: 'People'),
            TabItem(icon: Icons.account_circle_rounded, title: 'Profile'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) => print('click index=$i'),
        ));
  }
}
