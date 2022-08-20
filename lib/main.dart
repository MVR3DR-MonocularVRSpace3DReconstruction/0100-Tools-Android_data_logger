
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:math';

import 'camera.dart';
import 'imu_data.dart';
import 'track.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //permission
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    print("=> requesting storage permission");
    await Permission.storage.request();
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(context){return const MyApp();},
      'camera':(context){return const VideoRecorderExample();},
      'imu':(context){return const IMUData();},
    },

  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final pages = [VideoRecorderExample(), IMUData(), Track(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: 'IMU',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Track',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),

          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget Home(Color bgcolor, String title) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
      body: Container(
        color: bgcolor,
      ),
    );
  }


}
