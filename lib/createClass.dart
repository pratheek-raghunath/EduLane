import 'package:flutter/material.dart';

class CreateClass extends StatelessWidget {
  const CreateClass({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Create Class';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const ClassField(),
      ),
    );
  }
}

class ClassField extends StatelessWidget {
  const ClassField({super.key});

  static const appTitle = 'Create Class';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
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
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Section',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Room',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: TextFormField(
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
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                // if (_formKey.currentState!.validate()) {
                //   // Process data.
                // }
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
