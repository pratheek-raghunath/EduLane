import 'package:edulane/navbar.dart';
import 'package:flutter/material.dart';
import 'package:edulane/createClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'createCard.dart';

class Class {
  String id;
  final String teacher_id;
  final String name;
  final String section;
  final String room;
  final String subject;

  Class(
      {this.id = '',
      required this.teacher_id,
      required this.name,
      required this.section,
      required this.room,
      required this.subject});

  static Class fromJSON(Map<String, dynamic> json) => Class(
      id: json['id'],
      teacher_id: json['teacher_id'],
      name: json['name'],
      section: json['section'],
      room: json['room'],
      subject: json['subject']);

  Map<String, dynamic> toJSON() => {
        'id': id,
        'teacher_id': teacher_id,
        'name': name,
        'section': section,
        'room': room,
        'subject': subject
      };

  static Widget buildClass(Class c) => CreateCard(text: c.subject);

  static Stream<List<Class>> readClasses() => FirebaseFirestore.instance
      .collection('classes')
      .where("teacher_id",
          isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Class.fromJSON(doc.data())).toList());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static const appTitle = 'Edulane';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('EduLane'),
      ),
      body: StreamBuilder<List<Class>>(
          stream: Class.readClasses(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! $snapshot.error');
            } else if (snapshot.hasData) {
              final classes = snapshot.data!;

              return ListView(
                children: classes.map(Class.buildClass).toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Create Class',
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Create Class'),
                ),
                body: const CreateClassForm(),
              ),
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
