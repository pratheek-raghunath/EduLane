import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edulane/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'teacher.dart';

class PeopleData {
  final String name;

  PeopleData({required this.name});

  static PeopleData fromJSON(Map<String, dynamic> json) =>
      PeopleData(name: json['name']);

  static Widget buildPeopleData(PeopleData p) {
    return Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 200, 230, 255),
              ),
              child: SizedBox(
                width: 400,
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        p.name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 115, 255)),
                      )),
                ),
              ),
            ),
          ),
        ));
  }

  static Stream<List<PeopleData>> readPeople(List<dynamic> students) {
    if (students.isEmpty) {
      return Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .where("id", whereIn: students)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PeopleData.fromJSON(doc.data()))
            .toList());
  }
}

class People extends StatelessWidget {
  Class c;

  People({required this.c});

  Future<bool> getIsStudent() async {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (docRef.data()?['type'] == 'student') return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            drawer: FutureBuilder<bool>(
                future: getIsStudent(),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) return StudentNavDrawer();
                    return NavDrawer();
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            appBar: AppBar(
              title: Text('People'),
            ),
            body: StreamBuilder<List<PeopleData>>(
                stream: PeopleData.readPeople(c.students),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! $snapshot.error');
                  } else if (snapshot.hasData) {
                    final people = snapshot.data!;

                    return ListView(
                      children: people
                          .map((PeopleData p) => PeopleData.buildPeopleData(p))
                          .toList(),
                    );
                  } else {
                    return Center();
                  }
                })));
  }
}
