import 'dart:async';
import 'dart:io';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:permission_handler/permission_handler.dart';

import 'package:floatingpanel/floatingpanel.dart';

late List<CameraDescription> _cameras;
int decimalPoints = 7;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  _cameras = await availableCameras();

  //permission
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'Log',
    routes: {
      'Log': (context) {
        return MyApp();
      },
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
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.low;
  bool _isCameraInitialized = false;

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
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(decimalPoints))
        .toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();

    // check file exist
    var dirImg = Directory('/storage/emulated/0/Download/img/');
    var dirImu = Directory('/storage/emulated/0/Download/imu/');
    var existImg = dirImg.existsSync();
    var existImu = dirImu.existsSync();
    if (!existImg) {dirImg.create();}
    if (!existImu) {dirImu.create();}

    //imu data
    var totalDataPath = join('/storage/emulated/0/Download/imu/', 'TotalImu.txt');
    File totalFile = File(totalDataPath);


    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.red,
            title: const Text(
              'Data Logger',
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
                      controller,
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
                          Center(
                            child: FloatingActionButton(
                              child: Icon(
                                recording ? Icons.circle : Icons.camera,
                                color: recording ? Colors.white : Colors.red,
                              ),
                              onPressed: () async {
                                recording = !recording;

                                while (recording) {
                                  var time = DateTime.now();
                                  // ,(await getApplicationSupportDirectory()).path
                                  var path = join(
                                      '/storage/emulated/0/Download/img/',
                                      'img_$time.png');
                                  var data = join(
                                      '/storage/emulated/0/Download/imu/',
                                      'imu_$time.txt');
                                  print('$path  =  $data');

                                  setState(() {
                                    log =
                                        'image path: $path\nimu data path: $data';
                                  });

                                  try {
                                    File file = File(data);
                                    IOSink imu =
                                        file.openWrite(mode: FileMode.append);
                                    String strAccelerometer = accelerometer!.join(' ');
                                    String strUserAccelerometer = userAccelerometer!.join(' ');
                                    String strGyroscope = gyroscope!.join(' ');

                                    IOSink totalImuSink = totalFile.openWrite(mode: FileMode.append);

                                    totalImuSink.write(
                                        '$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n\n');
                                    imu.write(
                                        '$strAccelerometer\n$strUserAccelerometer\n$strGyroscope');

                                    imu.close();
                                    totalImuSink.close();


                                    // print('logging imu success');

                                    XFile pic = await controller.takePicture();
                                    pic.saveTo(path);

                                    // print('capture success');
                                    // print('====================');
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }

                                  sleep(const Duration(microseconds: 84));
                                }

                                // recording = !recording;
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
              FloatBoxPanel(
                //Customize properties
                // backgroundColor: Color(0xFF222222),
                panelShape: PanelShape.rounded,
                borderRadius: BorderRadius.circular(8.0),

                size: 50,
                onPressed: (index) {
                  print("Clicked on item: $index");

                  switch (index) {
                    case 0:
                      setState(() {
                        currentResolutionPreset = ResolutionPreset.low;
                      });
                      onNewCameraSelected(
                          controller.description, currentResolutionPreset);
                      break;
                    case 1:
                      setState(() {
                        currentResolutionPreset = ResolutionPreset.medium;
                      });
                      onNewCameraSelected(
                          controller.description, currentResolutionPreset);
                      break;
                    case 2:
                      setState(() {
                        currentResolutionPreset = ResolutionPreset.max;
                      });
                      onNewCameraSelected(
                          controller.description, currentResolutionPreset);
                      break;

                    case 3:
                      deleteFile('/storage/emulated/0/Download/img/');
                      deleteFile('/storage/emulated/0/Download/imu/');
                      print('cleared !!');
                      break;
                  }
                },

                buttons: [
                  Icons.looks_one,
                  Icons.looks_two,
                  Icons.looks_3,
                  Icons.delete, // delete imu file

                ],
              ),
            ],
          )),
    );
  }

  void deleteFile(String path) {
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

  void onNewCameraSelected(CameraDescription cameraDescription,
      ResolutionPreset currentResolutionPreset) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller.value.isInitialized;
      });
    }
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

    controller = CameraController(_cameras[0], currentResolutionPreset);
    controller.initialize().then((_) {
      if (!mounted) {
        // controller.setFlashMode(FlashMode.off);
        return;
      }
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
