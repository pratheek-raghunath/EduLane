import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:edulane/navbar.dart';
import 'package:open_file/open_file.dart';

class Subject extends StatelessWidget {
  const Subject({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text('Subject'),
            backgroundColor: Colors.blue,
          ),
          body: Container(
            child: Column(
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
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                              child: Text(
                                'Sub Details',
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
                Container(
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
                                leading: Icon(Icons.arrow_drop_down_circle),
                                title: const Text('Faculty Name'),
                                subtitle: Text(
                                  'Subject Name',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
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
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
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
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Announcement 1',
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
              ],
            ),
          ),
        ));
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}
