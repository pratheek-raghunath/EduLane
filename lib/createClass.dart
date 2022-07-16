import 'package:flutter/material.dart';
import 'package:edulane/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class CreateClassForm extends StatefulWidget {
  const CreateClassForm({Key? key}) : super(key: key);

  @override
  State<CreateClassForm> createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  Future<String> generateClassCode() async {
    String classCode = randomAlphaNumeric(5);

    while (true) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('classes')
          .where('class_code', isEqualTo: classCode)
          .get();

      if (qs.size > 0)
        classCode = randomAlphaNumeric(5);
      else
        break;
    }

    return classCode;
  }

  Future createClass(
      {required String name,
      required String section,
      required String room,
      required String subject}) async {
    final docClass = FirebaseFirestore.instance.collection('classes').doc();

    final c = Class(
        id: docClass.id,
        teacher_id: FirebaseAuth.instance.currentUser?.uid ?? '',
        name: name,
        section: section,
        room: room,
        subject: subject,
        class_code: await generateClassCode(),
        students: []);

    final json = c.toJSON();

    await docClass.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Class name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            controller: sectionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Section',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            controller: roomController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Room',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            controller: subjectController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Subject',
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
                'Create',
                style: TextStyle(fontSize: 22),
              ),
              onPressed: () {
                createClass(
                    name: nameController.text,
                    section: sectionController.text,
                    room: roomController.text,
                    subject: subjectController.text);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Scaffold(body: Dashboard());
                }));
              },
            ),
          ),
        ),
      ],
    );
  }
}
