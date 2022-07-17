import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edulane/student.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edulane/navbar.dart';
import 'package:open_file/open_file.dart';
import 'teacher.dart';

class Announcement {
  String id;
  final String class_id;
  final String text;
  final Timestamp created_at;

  Announcement(
      {this.id = '',
      required this.class_id,
      required this.text,
      required this.created_at});

  static Announcement fromJSON(Map<String, dynamic> json) => Announcement(
      id: json['id'],
      class_id: json['class_id'],
      text: json['text'],
      created_at: json['created_at']);

  Map<String, dynamic> toJSON() => {
        'id': id,
        'class_id': class_id,
        'text': text,
        'created_at': created_at,
      };

  static Future createAnnouncement({
    required String class_id,
    required String text,
  }) async {
    final docClass =
        FirebaseFirestore.instance.collection('announcements').doc();

    final c = Announcement(
        id: docClass.id,
        class_id: class_id,
        text: text,
        created_at: Timestamp.now());

    final json = c.toJSON();

    await docClass.set(json);
  }

  static Widget buildAnnouncement(Announcement a) => Align(
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
              height: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      a.text,
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

  static Stream<List<Announcement>> readAnnouncements(String class_id) =>
      FirebaseFirestore.instance
          .collection('announcements')
          .where("class_id", isEqualTo: class_id)
          .orderBy("created_at", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Announcement.fromJSON(doc.data()))
              .toList());
}

class Subject extends StatefulWidget {
  final Class c;

  Subject({required this.c});

  @override
  State<Subject> createState() => _SubjectState(c: c);
}

class _SubjectState extends State<Subject> {
  TextEditingController announcementController = TextEditingController();

  final Class c;

  _SubjectState({required this.c});

  Future<String> getTeacherName() async {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(c.teacher_id)
        .get();

    return docRef.data()!['name'];
  }

  Widget buildTeacherName(context) {
    return FutureBuilder<String>(
        future: getTeacherName(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data ?? '');
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<bool> getIsStudent() async {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (docRef.data()?['type'] == 'student') return true;

    return false;
  }

  Widget buildCreateAnnouncement(context) {
    return FutureBuilder<bool>(
        future: getIsStudent(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false) {
              return Container(
                width: 400,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 175, 219, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                size: 50,
                              ),
                              title: buildTeacherName(context),
                              subtitle: Text(
                                c.subject,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: announcementController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  // prefixIcon: Icon(Icons.lock),
                                  // border: OutlineInputBorder(),
                                  hintText: 'Announcement',
                                ),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.end,
                              buttonPadding:
                                  const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Perform some action
                                    final result =
                                        await FilePicker.platform.pickFiles();
                                    if (result == null) return;
                                    final file = result.files.first;
                                    openFile(file);
                                  },
                                  icon: Icon(Icons.attachment),
                                  // child: const Text('ADD'),
                                  label: Text('ADD'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Perform some action
                                    Announcement.createAnnouncement(
                                        class_id: c.id,
                                        text: announcementController.text);
                                    announcementController.text = '';
                                  },
                                  child: const Text('POST'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(color: Colors.white // This is optional
                  );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
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
            title: Text(c.subject),
            backgroundColor: Colors.blue,
          ),
          body: Container(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ), // Rounded RectangleBorder
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage("assets/images/teaching.jpg"),
                        //   fit: BoxFit.fitWidth,
                        //   alignment: Alignment.topCenter,
                        // ),

                        color: Color.fromARGB(255, 200, 230, 255),
                      ),
                      child: SizedBox(
                        width: 400,
                        height: 150,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                              child: Text(
                                'Name: ' +
                                    c.name +
                                    '\nRoom: ' +
                                    c.room +
                                    '\nSection: ' +
                                    c.section +
                                    '\nClass Code: ' +
                                    c.class_code,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 8, 115, 255)),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                buildCreateAnnouncement(context),
                StreamBuilder<List<Announcement>>(
                    stream: Announcement.readAnnouncements(c.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong! $snapshot.error');
                      } else if (snapshot.hasData) {
                        final announcements = snapshot.data!;

                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: announcements
                              .map(Announcement.buildAnnouncement)
                              .toList(),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })
              ],
            ),
          ),
        ));
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}
