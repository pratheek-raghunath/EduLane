// ignore: file_names
import 'package:flutter/material.dart';

//create card
class CreateCard extends StatelessWidget {
  final String text;

  const CreateCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
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
            debugPrint('Card tapped.');
            // const NavDrawer();
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const Sample();
            // }
            // )
            // );
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              //color: Color.fromARGB(255, 200, 230, 255),
            ),
            child: SizedBox(
              width: 400,
              height: 130,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                    child: Text(
                      text,
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
    );
  }
}
