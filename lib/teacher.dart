import 'package:edulane/main.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
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

class Sample extends StatelessWidget {
  const Sample({super.key});

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

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/edulanesplash1.png'))),
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('Dashboard'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Calendar'),
            onTap: () async {
              var openAppResult = await LaunchApp.openApp(
                androidPackageName: 'com.samsung.android.calendar',
                // iosUrlScheme: 'pulsesecure://',
                // appStoreLink:
                // 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                // openStore: false
              );
              if (kDebugMode) {
                print(
                    'openAppResult => $openAppResult ${openAppResult.runtimeType}');
              }
              // Enter thr package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
              // The second arguments decide wether the app redirects PlayStore or AppStore.
              // For testing purpose you can enter com.instagram.android
            },
          ),
          ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Create Class'),
              onTap: () {
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
              }),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Notifications'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp(title: 'Welcome to EduLane')))
            },
          ),
        ],
      ),
    );
  }
}
