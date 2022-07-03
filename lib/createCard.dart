// ignore: file_names
import 'package:flutter/material.dart';

//create card
class CreateCard extends StatelessWidget {
  const CreateCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        margin: const EdgeInsets.all(10),
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
              // image: DecorationImage(
              //   image: AssetImage("assets/images/teaching.jpg"),
              //   fit: BoxFit.fitWidth,
              //   alignment: Alignment.topCenter,
              // ),
              color: Color.fromARGB(255, 200, 230, 255),
            ),
            child: const SizedBox(
              width: 400,
              height: 200,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 1),
                    child: Text(
                      'My class',
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
