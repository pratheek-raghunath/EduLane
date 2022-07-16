import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edulane/login.dart';
import 'package:edulane/studentLogin.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp(
    title: 'Welcome to EduLane',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduLane',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EduLane'),
        ),
        body: Column(
          children: const <Widget>[
            Spacer(),
            TeacherCard(),
            StudentCard(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ), // Rounded RectangleBorder
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
            // const NavDrawer();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Scaffold(body: LoginForm());
            }));
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/teaching.jpg"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: const SizedBox(
              width: 300,
              height: 200,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                    child: Text(
                      'Teacher Login',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ), // Rounded RectangleBorder
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Scaffold(body: StudentLoginForm());
            }));
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/stu1.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: const SizedBox(
              width: 300,
              height: 200,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                    child: Text(
                      'Student Login',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 51, 163, 255)),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
