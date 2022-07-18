import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatelessWidget {
  Widget getText() {
    FirebaseStorage.instance
        .ref()
        .child('7WYjathkkhVJv8cZ2VpY')
        .listAll()
        .then((ListResult) {
      print("works");
      for (var item in ListResult.items) {
        print(item.fullPath);
        print(item.name);
      }
    });
    return Text('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: getText(),
      ),
    );
  }
}
