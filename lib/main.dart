// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// void main() {
//
//   runApp(const MyApp());
// }
const PATH = '/';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  _cameras = await availableCameras();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'Log',
    routes: {
      'Log':(context){return MyApp();},

    },
  ));

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Data Logger'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Camera
  late CameraController controller;

  bool recording = false;
  //data
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //navi
  int _selectedIndex = 0;
  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer = _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();




    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              'Data Logger',

            ),
          ),
          body: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: CameraPreview(
              controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Accelerometer: $accelerometer',style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('UserAccelerometer: $userAccelerometer',style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Gyroscope: $gyroscope',style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Magnetometer: $magnetometer',style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Center(
                    child: FloatingActionButton(
                      onPressed: () async {
                          recording = !recording;
                          // print(recording);

                          while(recording) {
                            var time = DateTime.now();
                            var path = join('img_',(await getApplicationSupportDirectory()).path, '$time.png');
                            var data = join('imu_',(await getApplicationSupportDirectory()).path, '$time.txt');
                            print('$path  =  $data');
                            try {

                              File file = File(data);
                              IOSink imu = file.openWrite(mode: FileMode.append);
                              imu.write('$accelerometer\n$userAccelerometer\n$gyroscope');
                              imu.close();

                              print('logging imu success');

                              XFile pic = await controller.takePicture();
                              pic.saveTo(path);

                              print('capture success');
                              print('====================');
                            } catch (e) {
                              // If an error occurs, log the error to the console.
                              print(e);
                            }


                            sleep(const Duration( microseconds: 84));
                          }

                          // recording = !recording;
                        },
                      backgroundColor: recording? Colors.red : Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 200,
                  )

                ],
              ),
            ),
          )
      ),




    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
            (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
            (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );


    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }


}