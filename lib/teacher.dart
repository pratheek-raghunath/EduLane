import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:edulane/createClass.dart';

import 'createCard.dart';

class Sample extends StatelessWidget {
  const Sample({super.key});

  static const appTitle = 'Edulane';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('EduLane'),
      ),
      body: Column(
        children: const <Widget>[
          // ignore: prefer_const_constructors
          CreateCard(),
          // ignore: prefer_const_constructors
          CreateCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CreateClass();
          }));
        },
        child: const Icon(Icons.add),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

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
            onTap: () => {},
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
              title: const Text('Create Class'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CreateClass();
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
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
