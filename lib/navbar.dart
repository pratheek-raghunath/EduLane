import 'package:edulane/bottomNavBar.dart';
import 'package:edulane/createClass.dart';
import 'package:edulane/main.dart';
import 'package:edulane/subject.dart';
import 'package:edulane/teacher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Dashboard()))
            },
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
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Create Class',
                    home: Scaffold(
                      appBar: AppBar(
                        title: const Text('Create Class'),
                      ),
                      body: const CreateClassForm(),
                    ),
                  );
                }));
              }),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Notifications'),
            onTap: () => {
              print('Notification')
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => Home()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp(title: 'Welcome to EduLane')))
            },
          ),
        ],
      ),
    );
  }
}
