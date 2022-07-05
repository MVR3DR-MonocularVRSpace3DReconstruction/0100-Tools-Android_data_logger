import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:permission_handler/permission_handler.dart';


late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

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

  //log
  String log = '';



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
            child: Column(
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Text(
                    log,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                CameraPreview(
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
                          child: Icon(recording ? Icons.circle : Icons.camera, color: recording ? Colors.white: Colors.red,),
                          onPressed: () async {
                            recording = !recording;

                            while(recording) {
                              var time = DateTime.now();
                            // ,(await getApplicationSupportDirectory()).path
                              var path = join('/storage/emulated/0/Download/', 'img_$time.png');
                              var data = join('/storage/emulated/0/Download/', 'imu_$time.txt');
                              print('$path  =  $data');

                              setState(() {
                                log = 'image path: $path\nimu data path: $data';
                              });

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

                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                          child: Icon(Icons.clear_all),
                          onPressed: () {

                          }),

                    ],
                  ),
                )
              ],
            )
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


    controller = CameraController(_cameras[0], ResolutionPreset.low);
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


