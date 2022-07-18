import 'package:edulane/navbar.dart';
import 'package:flutter/material.dart';
import 'package:edulane/createClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottomNavBar.dart';

class Class {
  String id;
  final String teacher_id;
  final String name;
  final String section;
  final String room;
  final String subject;
  final String class_code;
  final List<dynamic> students;

  Class(
      {this.id = '',
      required this.teacher_id,
      required this.name,
      required this.section,
      required this.room,
      required this.subject,
      required this.class_code,
      required this.students});

  static Class fromJSON(Map<String, dynamic> json) => Class(
      id: json['id'],
      teacher_id: json['teacher_id'],
      name: json['name'],
      section: json['section'],
      room: json['room'],
      subject: json['subject'],
      class_code: json['class_code'],
      students: json['students']);

  Map<String, dynamic> toJSON() => {
        'id': id,
        'teacher_id': teacher_id,
        'name': name,
        'section': section,
        'room': room,
        'subject': subject,
        'class_code': class_code,
        'students': students
      };

  static Widget buildClass(Class c, BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ), // Rounded RectangleBorder
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home(c: c)));
            },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg3.jpg"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
                // color: Color.fromARGB(255, 200, 230, 255),
              ),
              child: SizedBox(
                width: 400,
                height: 130,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                      child: Text(
                        c.subject,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )),
                ),
              ),
            ),
          ),
        ),
      );

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

  Future<bool?> showWarning(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Do you want to logout?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
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
                  children: classes
                      .map((Class c) => Class.buildClass(c, context))
                      .toList(),
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
      ),
    );
  }
}
