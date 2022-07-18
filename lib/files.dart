import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edulane/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'navbar.dart';
import 'teacher.dart';

class FileData {
  final String fullPath;
  final String name;

  FileData({required this.fullPath, required this.name});

  static Widget buildFileData(FileData f) {
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
            onTap: () async {
              Fluttertoast.showToast(
                  msg: "Downloading File",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
              // print(f.fullPath);
              // final storageRef =
              //     FirebaseStorage.instance.ref().child(f.fullPath);
              // final appDocDir = await getApplicationDocumentsDirectory();
              // final filePath = "${appDocDir.absolute}/${f.name}";
              // final file = File(filePath);
              // final downloadTask = storageRef.writeToFile(file);
              // downloadTask.snapshotEvents.listen((taskSnapshot) {
              //   switch (taskSnapshot.state) {
              //     case TaskState.running:
              //       break;
              //     case TaskState.paused:
              //       break;
              //     case TaskState.success:
              //       Fluttertoast.showToast(
              //           msg: "File Downloaded",
              //           toastLength: Toast.LENGTH_SHORT,
              //           gravity: ToastGravity.BOTTOM,
              //           timeInSecForIosWeb: 1,
              //           backgroundColor: Colors.blue,
              //           textColor: Colors.white,
              //           fontSize: 16.0);
              //       break;
              //     case TaskState.canceled:
              //       break;
              //     case TaskState.error:
              //       break;
              //   }
              // });

              Directory appDocDir =
                  await getExternalStorageDirectory() ?? new Directory("");
              //Here you'll specify the file it should be saved as
              File downloadToFile = File('${appDocDir.path}/${f.name}');
              //Here you'll specify the file it should download from Cloud Storage
              String fileToDownload = f.fullPath;
              print(downloadToFile.absolute);

              //Now you can try to download the specified file, and write it to the downloadToFile.
              try {
                await FirebaseStorage.instance
                    .ref(fileToDownload)
                    .writeToFile(downloadToFile);
              } on FirebaseException catch (e) {
                // e.g, e.code == 'canceled'
                print('Download error: $e');
              }
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
                        f.name,
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

  static Future<Iterable<FileData>> readFiles(String class_id) async {
    final listItems =
        await FirebaseStorage.instance.ref().child(class_id).listAll();

    return listItems.items
        .map((li) => FileData(fullPath: li.fullPath, name: li.name));
  }
}

class Files extends StatelessWidget {
  Class c;

  Files({required this.c});

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
              title: Text('Files'),
            ),
            body: FutureBuilder<Iterable<FileData>>(
                future: FileData.readFiles(c.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! $snapshot.error');
                  } else if (snapshot.hasData) {
                    final files = snapshot.data!;

                    return ListView(
                      children: files
                          .map((FileData f) => FileData.buildFileData(f))
                          .toList(),
                    );
                  } else {
                    return Center();
                  }
                })));
  }
}
