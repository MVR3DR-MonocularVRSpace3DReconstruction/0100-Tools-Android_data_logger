import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sensors_plus/sensors_plus.dart';

const int decimalPoints = 7;

class VideoRecorderExample extends StatefulWidget {
  const VideoRecorderExample({Key? key}) : super(key: key);

  @override
  _VideoRecorderExampleState createState() {
    return _VideoRecorderExampleState();
  }
}

class _VideoRecorderExampleState extends State<VideoRecorderExample> {

  //imu
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  //camera
  late CameraController controller;
  late String videoPath;
  late String logPath;

  List<CameraDescription>? cameras;
  late int selectedCameraIdx;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




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



    availableCameras().then((value) {
      cameras = value;
      // print(cameras!.length);
      controller = CameraController(cameras![0], ResolutionPreset.low);
      setState(() {
        selectedCameraIdx = 0;
      });
      _onCameraSwitched(cameras![selectedCameraIdx]);
    });

  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }



  @override
  Widget build(BuildContext context) {

    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final magnetometer = _magnetometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();

    String timestamp = DateTime.now().toString();
    String strAccelerometer = accelerometer!.join(' ');
    String strUserAccelerometer = userAccelerometer!.join(' ');
    String strGyroscope = gyroscope!.join(' ');
    String strMagnetometer = magnetometer!.join(' ');

    if (controller.value.isRecordingVideo) {
      // print('recording!!');
      File imuFile = File(logPath);
      IOSink imuSink = imuFile.openWrite(mode: FileMode.append);
      imuSink.write('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
      imuSink.close();

    }



    final downloadDir = Directory('/storage/emulated/0/Download/Logger/');
    downloadDir.exists().then((value) {
      if (!value) {
        downloadDir.create();
      }
    } );


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('首先你要考虑怎么把它变成RGBD'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                  child: _cameraPreviewWidget(timestamp,strAccelerometer,strUserAccelerometer,strGyroscope,strMagnetometer),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget(timestamp,strAccelerometer,strUserAccelerometer,strGyroscope,strMagnetometer) {
    if (!controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(
          controller,
        child: Text('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n'),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    CameraDescription selectedCamera = cameras![selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(
                _getCameraLensIcon(lensDirection)
            ),
            label: Text(lensDirection.toString()
                .substring(lensDirection.toString().indexOf('.')+1))
        ),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.videocam),
              color: Colors.blueAccent,
              onPressed: controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
                  ? _onRecordButtonPressed
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              color: Colors.deepOrange,
              onPressed: controller.value.isInitialized &&
                  controller.value.isRecordingVideo
                  ? _onStopButtonPressed
                  : null,
            )
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    await controller.dispose();

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras!.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((f) {
      if (f != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white
        );
      }
    });
  }



  void _onStopButtonPressed() {
    _stopVideoRecording().then((XFile? F) async {

      try {
        F!.saveTo(videoPath);
        // await GallerySaver.saveVideo(F!.path);
        // File(F.path).deleteSync();

        Fluttertoast.showToast(
            msg: 'Video recorded to $videoPath \n IMU recorded to $logPath',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white
        );
      } catch (e) {
        String errorText = 'Error: $e';
        print("==================================");
        print(errorText);
        print("==================================");
      }

    });
  }

  Future<String?> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );

      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '/storage/emulated/0/Download/Logger/$currentTime.mp4';
    final String imuPath = '/storage/emulated/0/Download/Logger/$currentTime.txt';

    try {
      await controller.startVideoRecording();
      videoPath = filePath;
      logPath = imuPath;

    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<XFile?> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      XFile file = await controller.stopVideoRecording();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
  }
}
