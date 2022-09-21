
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:math';

import 'camera.dart';
import 'imu_data.dart';
import 'track.dart';
import 'settings.dart';

import 'package:motion_sensors/motion_sensors.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
const int decimalPoints = 7;

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

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late String timestamp;
  late List<double>? accelerometerValues;
  late List<double>? userAccelerometerValues;
  late List<double>? gyroscopeValues;
  late List<double>? magnetometerValues;
  late List<double>? orientationValues;
  late List<double>? absoluteOrientationValues;

  late List<double>? absoluteOrientationValues2;
  Vector3 absoluteOrientationValues2V3 = Vector3.zero();

  static late List<double>? integratedOrientationValues=[0, 0, 0];

  static late int duration;
  int _selectedIndex = 0;
  Color _buttonColor = const Color.fromRGBO(255, 255, 255, 1);


  @override
  void initState() {
    super.initState();

    motionSensors.accelerometer.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
    motionSensors.userAccelerometer.listen((UserAccelerometerEvent event) {
      setState(() {
        userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
    motionSensors.gyroscope.listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = <double>[event.x, event.y, event.z];
        integratedOrientationValues = <double>[
          integratedOrientationValues![0]+event.x*duration/10e6,
          integratedOrientationValues![1]+event.y*duration/10e6,
          integratedOrientationValues![2]+event.z*duration/10e6];
      });
    });
    motionSensors.magnetometer.listen((MagnetometerEvent event) {
      setState(() {
        magnetometerValues = <double>[event.x, event.y, event.z];
      });
    });
    motionSensors.isOrientationAvailable().then((available) {
      if (available) {
        motionSensors.orientation.listen((OrientationEvent event) {
          setState(() {
            orientationValues = <double>[event.yaw, event.pitch, event.roll];
          });
        });
      }
    });
    motionSensors.absoluteOrientation.listen((AbsoluteOrientationEvent event) {
      setState(() {
        absoluteOrientationValues = <double>[event.yaw, event.pitch, event.roll];
      });
    });

    duration = Duration.microsecondsPerSecond ~/ 1;
    setUpdateInterval(Duration.microsecondsPerSecond ~/ 60);
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      timestamp = DateTime.now().toString();
      integratedOrientationValues = <double>[
        integratedOrientationValues![0]+gyroscopeValues![0],
        integratedOrientationValues![1]+gyroscopeValues![1],
        integratedOrientationValues![2]+gyroscopeValues![2]];


      absoluteOrientationValues2V3.setFrom(motionSensors.getOrientation(motionSensors.getRotationMatrix(Vector3(accelerometerValues![0], accelerometerValues![1], accelerometerValues![2]), Vector3(magnetometerValues![0], magnetometerValues![1], magnetometerValues![2]))));
      absoluteOrientationValues2 = [absoluteOrientationValues2V3.x, absoluteOrientationValues2V3.y, absoluteOrientationValues2V3.z];
    });

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: IndexedStack(
          alignment: Alignment.center,
          // 设置当前索引
          index: _selectedIndex,
          children: [
            VideoRecorderExample(
              timestamp: timestamp,
              imuData: [
                accelerometerValues,
                userAccelerometerValues,
                gyroscopeValues,
                magnetometerValues,
                orientationValues,
                absoluteOrientationValues,
                integratedOrientationValues,
                absoluteOrientationValues2,
              ],
            ),
            IMUData(
              timestamp: timestamp,
              imuData: [
                accelerometerValues,
                userAccelerometerValues,
                gyroscopeValues,
                magnetometerValues,
                orientationValues,
                absoluteOrientationValues,
                integratedOrientationValues,
              ],
            ),
            Track(
              orientationValues: orientationValues,
              absoluteOrientationValues: absoluteOrientationValues,
            ),
            Settings(),
          ],
        ),
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
          selectedItemColor: _buttonColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }


  static void setUpdateInterval(int interval) {
    motionSensors.accelerometerUpdateInterval = interval;
    motionSensors.userAccelerometerUpdateInterval = interval;
    motionSensors.gyroscopeUpdateInterval = interval;
    motionSensors.magnetometerUpdateInterval = interval;
    motionSensors.orientationUpdateInterval = interval;
    motionSensors.absoluteOrientationUpdateInterval = interval;

    MyAppState.duration = interval;
  }


  void _onItemTapped(int index) {
    setState(() {
      _buttonColor = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
      _selectedIndex = index;
    });
  }

}
