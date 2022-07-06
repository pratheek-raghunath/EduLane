import 'package:flutter/material.dart';
import 'package:edulane/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateClassForm extends StatefulWidget {
  const CreateClassForm({Key? key}) : super(key: key);

  @override
  State<CreateClassForm> createState() => _CreateClassFormState();
}

// class CreateClass extends StatelessWidget {
//   const CreateClass({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const appTitle = 'Create Class';

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: appTitle,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(appTitle),
//         ),
//         body: const ClassField(),
//       ),
//     );
//   }
// }

class _CreateClassFormState extends State<CreateClassForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

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
        subject: subject);

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
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 174, 255),
              ),
              onPressed: () {
                createClass(
                    name: nameController.text,
                    section: sectionController.text,
                    room: roomController.text,
                    subject: subjectController.text);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Scaffold(body: Sample());
                }));
              },
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
