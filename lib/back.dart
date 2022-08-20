

import 'dart:async';
import 'dart:io';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:permission_handler/permission_handler.dart';

import 'package:floatingpanel/floatingpanel.dart';

const int decimalPoints = 7;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late CameraController controller;
  late List<CameraDescription> _cameras;
  int selectedCameraIdx = 0;
  bool recording = false;

  //data
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //log
  String log = '';

  @override
  void dispose() {
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




  }


  @override
  Widget build(BuildContext context) {

    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final magnetometer = _magnetometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();


    var imuPath = join('/storage/emulated/0/Download/', 'TotalImu.txt');
    File imuFile = File(imuPath);
    if (!imuFile.existsSync()) {imuFile = File(imuPath);}
    if (recording) {

      String timestamp = DateTime.now().toString();
      String strAccelerometer = accelerometer!.join(' ');
      String strUserAccelerometer = userAccelerometer!.join(' ');
      String strGyroscope = gyroscope!.join(' ');
      String strMagnetometer = magnetometer!.join(' ');

      IOSink imuSink = imuFile.openWrite(mode: FileMode.append);
      imuSink.write('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
      imuSink.close();
    }


    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.red,
            title:  Text(
              '-',
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            // color: Colors.black,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CameraPreview(
                      controller!,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('Accelerometer: $accelerometer',
                              style: const TextStyle(color: Colors.white)),
                          Text('UserAccelerometer: $userAccelerometer',
                              style: const TextStyle(color: Colors.white)),
                          Text('Gyroscope: $gyroscope',
                              style: const TextStyle(color: Colors.white)),
                          Text('Magnetometer: $magnetometer',
                              style: const TextStyle(color: Colors.white)),

                          //capture
                          Center(
                            child: FloatingActionButton(
                              child: Icon(
                                recording ? Icons.circle : Icons.camera,
                                color: recording ? Colors.white : Colors.red,
                              ),
                              onPressed: () async {

                                if (!recording) {
                                  print('=> Start recording!!');
                                  _deleteFile('/storage/emulated/0/Download/');
                                  controller!.prepareForVideoRecording();
                                  controller!.startVideoRecording();
                                } else {
                                  print('==> Stop recording!!');
                                  var time = DateTime.now();

                                  // var file = XFile(join('/storage/emulated/0/Download/', '$time.mp4'));
                                  var file = await controller!.stopVideoRecording();
                                  await file.saveTo(join('/storage/emulated/0/Download/', '$time.mp4'));
                                }
                                recording = !recording;
                              },
                              backgroundColor:
                              recording ? Colors.red : Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 200,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              //
              // FloatBoxPanel(
              //   //Customize properties
              //   // backgroundColor: Color(0xFF222222),
              //   panelShape: PanelShape.rounded,
              //   borderRadius: BorderRadius.circular(8.0),
              //
              //   size: 50,
              //   onPressed: (index) {
              //     print("Clicked on item: $index");
              //
              //     switch (index) {
              //       case 0:
              //         setState(() {
              //           currentResolutionPreset = ResolutionPreset.low;
              //         });
              //         _onNewCameraSelected(
              //             controller.description, currentResolutionPreset);
              //         break;
              //       case 1:
              //         setState(() {
              //           currentResolutionPreset = ResolutionPreset.medium;
              //         });
              //         _onNewCameraSelected(
              //             controller.description, currentResolutionPreset);
              //         break;
              //       case 2:
              //         setState(() {
              //           currentResolutionPreset = ResolutionPreset.max;
              //         });
              //         _onNewCameraSelected(
              //             controller.description, currentResolutionPreset);
              //         break;
              //
              //       case 3:
              //         _deleteFile('/storage/emulated/0/Download/');
              //         print('cleared !!');
              //         break;
              //     }
              //   },
              //
              //   buttons: const [
              //     Icons.looks_one,
              //     Icons.looks_two,
              //     Icons.looks_3,
              //     Icons.delete, // delete imu file
              //
              //   ],
              // ),
            ],
          )),
    );
  }

  void _deleteFile(String path) {
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      if (files.isNotEmpty) {
        for (var file in files) {
          file.deleteSync();
        }
      }
      directory.deleteSync();
    }

  }

  // void _onNewCameraSelected(CameraDescription cameraDescription,
  //     ResolutionPreset currentResolutionPreset) async {
  //   final previousCameraController = controller;
  //   // Instantiating the camera controller
  //   final CameraController cameraController = CameraController(
  //     cameraDescription,
  //     currentResolutionPreset,
  //     imageFormatGroup: ImageFormatGroup.jpeg,
  //   );
  //
  //   // Dispose the previous controller
  //   await previousCameraController!.dispose();
  //
  //   // Replace with the new controller
  //   if (mounted) {
  //     setState(() {
  //       controller = cameraController;
  //     });
  //   }
  //
  //   // Update UI if controller updated
  //   cameraController.addListener(() {
  //     if (mounted) setState(() {});
  //   });
  //
  //   // Initialize controller
  //   try {
  //     await cameraController.initialize();
  //   } on CameraException catch (e) {
  //     print('Error initializing camera: $e');
  //   }
  //
  //   // Update the Boolean
  //   if (mounted) {
  //     setState(() {
  //       _isCameraInitialized = controller.value.isInitialized;
  //     });
  //   }
  // }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }


}
