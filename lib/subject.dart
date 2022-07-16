import 'package:edulane/bottomNavBar.dart';
import 'package:flutter/material.dart';

class Subject extends StatelessWidget {
  const Subject({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Subject'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Container(
            child: Text('Subject'),
          ),
        ),
      ),
    );
  }
}
