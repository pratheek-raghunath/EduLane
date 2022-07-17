import 'package:edulane/main.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'teacher.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  static const appTitle = 'Edulane';

  Stream<List<Class>> readStudentClasses() => FirebaseFirestore.instance
      .collection('classes')
      .where("students",
          arrayContains: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Class.fromJSON(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StudentNavDrawer(),
      appBar: AppBar(
        title: const Text('EduLane'),
      ),
      body: StreamBuilder<List<Class>>(
          stream: readStudentClasses(),
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
              title: 'Join Class',
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Join Class'),
                ),
                body: const JoinClassForm(),
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

class StudentNavDrawer extends StatelessWidget {
  const StudentNavDrawer({Key? key}) : super(key: key);

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
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentDashboard()))
            },
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
              title: const Text('Join Class'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Join Class',
                    home: Scaffold(
                      appBar: AppBar(
                        title: const Text('Join Class'),
                      ),
                      body: const JoinClassForm(),
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

class JoinClassForm extends StatefulWidget {
  const JoinClassForm({Key? key}) : super(key: key);

  @override
  State<JoinClassForm> createState() => _JoinClassFormState();
}

class _JoinClassFormState extends State<JoinClassForm> {
  TextEditingController classCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            controller: classCodeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter course code';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Class Code',
            ),
          ),
        ),
        SizedBox(
          // height: 40,
          // width: 100,
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Container(
            height: 90,
            width: 500,
            padding: const EdgeInsets.fromLTRB(100, 30, 100, 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)))),
              child: const Text(
                'Join',
                style: TextStyle(fontSize: 22),
              ),
              onPressed: () async {
                if (classCodeController.text == '') {
                  Fluttertoast.showToast(
                      msg: "Enter class code",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  QuerySnapshot qs = await FirebaseFirestore.instance
                      .collection('classes')
                      .where('class_code', isEqualTo: classCodeController.text)
                      .get();

                  if (qs.size == 0) {
                    Fluttertoast.showToast(
                        msg: "Class doesn't exist",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    DocumentSnapshot ds = await FirebaseFirestore.instance
                        .collection('classes')
                        .doc(qs.docs.first.id)
                        .get();

                    final course = ds.data() as Map<String, dynamic>;

                    if (course['students'].contains(
                        FirebaseAuth.instance.currentUser?.uid ?? '')) {
                      Fluttertoast.showToast(
                          msg: "Already enrolled in class",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      FirebaseFirestore.instance
                          .collection("classes")
                          .doc(qs.docs.first.id)
                          .update({
                        "students": FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser?.uid ?? '']),
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Scaffold(body: StudentDashboard());
                      }));
                    }
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
