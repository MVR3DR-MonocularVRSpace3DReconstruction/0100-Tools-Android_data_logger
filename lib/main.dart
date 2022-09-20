
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
  late List<double>? accelerometerValues = [0, 0, 0];
  late List<double>? userAccelerometerValues = [0, 0, 0];
  late List<double>? gyroscopeValues = [0, 0, 0];
  late List<double>? magnetometerValues = [0, 0, 0];
  late List<double>? orientationValues = [0, 0, 0];
  late List<double>? absoluteOrientationValues = [0, 0, 0];
  late List<double>? absoluteOrientation2Values = [0, 0, 0];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  static late String timestamp;
  static late String strAccelerometer;
  static late String strUserAccelerometer;
  static late String strGyroscope;
  static late String strMagnetometer;

  int _selectedIndex = 0;
  // final pages = const [VideoRecorderExample(), IMUData(), Track(), Settings()];
  Color _buttonColor = const Color.fromRGBO(255, 255, 255, 1);

  @override
  Widget build(BuildContext context) {

    setState(() {
      timestamp = DateTime.now().toString();
      strAccelerometer = accelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strUserAccelerometer = userAccelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strGyroscope = gyroscopeValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strMagnetometer = magnetometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
    });

    // print('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
    setUpdateInterval(1, Duration.microsecondsPerSecond ~/ 60);
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: IndexedStack(
          alignment: Alignment.center,
          // 设置当前索引
          index: _selectedIndex,
          children: [
            VideoRecorderExample(timestamp: timestamp,
              strUserAccelerometer: strUserAccelerometer,
              strGyroscope: strGyroscope,
              strMagnetometer: strMagnetometer,
              strAccelerometer: strAccelerometer,),
            IMUData(
              timestamp: timestamp,
              strUserAccelerometer: strUserAccelerometer,
              strGyroscope: strGyroscope,
              strMagnetometer: strMagnetometer,
              strAccelerometer: strAccelerometer,),
            Track(),
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


  static void setUpdateInterval(int? groupValue, int interval) {
    motionSensors.accelerometerUpdateInterval = interval;
    motionSensors.userAccelerometerUpdateInterval = interval;
    motionSensors.gyroscopeUpdateInterval = interval;
    motionSensors.magnetometerUpdateInterval = interval;
    motionSensors.orientationUpdateInterval = interval;
    motionSensors.absoluteOrientationUpdateInterval = interval;
  }


  @override
  void initState() {
    super.initState();
    //
    // _streamSubscriptions.add(
    //     motionSensors.gyroscope.listen((GyroscopeEvent event) {
    //       setState(() {
    //         gyroscopeValues = <double>[event.x, event.y, event.z];
    //       });
    //     })
    // );
    // _streamSubscriptions.add(
    //     motionSensors.accelerometer.listen((AccelerometerEvent event) {
    //       setState(() {
    //         accelerometerValues = <double>[event.x, event.y, event.z];
    //       });
    //     })
    // );
    // _streamSubscriptions.add(
    //     motionSensors.userAccelerometer.listen((UserAccelerometerEvent event) {
    //       setState(() {
    //         userAccelerometerValues = <double>[event.x, event.y, event.z];
    //       });
    //     })
    // );
    // _streamSubscriptions.add(
    //     motionSensors.absoluteOrientation.listen((AbsoluteOrientationEvent event) {
    //       setState(() {
    //         absoluteOrientationValues = <double>[event.yaw, event.pitch, event.roll];
    //       });
    //     })
    // );
    //
    // motionSensors.isOrientationAvailable().then((available) {
    //   if (available) {
    //     _streamSubscriptions.add(
    //         motionSensors.orientation.listen((OrientationEvent event) {
    //           setState(() {
    //             orientationValues = <double>[event.yaw, event.pitch, event.roll];
    //           });
    //         })
    //     );
    //   }
    // });


    motionSensors.gyroscope.listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    });
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

    timestamp = DateTime.now().toString();
    strAccelerometer = accelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
    strUserAccelerometer = userAccelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
    strGyroscope = gyroscopeValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
    strMagnetometer = magnetometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');

  }

  void _onItemTapped(int index) {
    setState(() {
      _buttonColor = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

}
