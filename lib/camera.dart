import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class VideoRecorderExample extends StatefulWidget {
  String timestamp;
  List<List<double>?> imuData;
  VideoRecorderExample({Key? key,
    required this.timestamp,
    required this.imuData,
  }) : super(key: key);

  @override
  VideoRecorderExampleState createState() {
    return VideoRecorderExampleState();
  }
}

class VideoRecorderExampleState extends State<VideoRecorderExample> {

  // camera
  late CameraController controller;
  late String videoPath;
  late String logPath;
  List<CameraDescription>? cameras;
  late int selectedCameraIdx;

  // imu
  late String timestamp;
  late String strAccelerometer;
  late String strUserAccelerometer;
  late String strGyroscope;
  late String strMagnetometer;

  late String strOrientation;
  late String strAbsoluteOrientation;
  late String strAbsoluteOrientation2;

  late String strAbsoluteOrientationDegree;

  late String strIntegratedOrientation;
  late String strIntegratedOrientationDirectionPredict;
  static List<double> baseOrientation = [0, 0, 0];


  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      controller = CameraController(cameras![0], ResolutionPreset.low);
      setState(() {
        selectedCameraIdx = 0;
      });
      _onCameraSwitched(cameras![selectedCameraIdx]);
    });
  }


  @override
  Widget build(BuildContext context) {

    setState(() {
      // imuData: [
      //   accelerometerValues,       0
      //   userAccelerometerValues,   1
      //   gyroscopeValues,           2
      //   magnetometerValues,        3
      //   orientationValues,         4
      //   absoluteOrientationValues, 5
      //   integratedOrientationValues,6
      //   absoluteOrientationValues2 7
      // ],
      timestamp = widget.timestamp;
      strAccelerometer = widget.imuData[0]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strUserAccelerometer = widget.imuData[1]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strGyroscope = widget.imuData[2]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strMagnetometer = widget.imuData[3]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');

      strOrientation = widget.imuData[4]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strAbsoluteOrientation = widget.imuData[5]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');

      strIntegratedOrientation = widget.imuData[6]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strIntegratedOrientationDirectionPredict = widget.imuData[6]!.map((double v) => ((v * (180/pi))%360).toStringAsFixed(decimalPoints)).toList().join(' ');

      strAbsoluteOrientation2 = widget.imuData[7]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
    });

    if (controller.value.isRecordingVideo) {
      File imuFile = File(logPath);
      IOSink imuSink = imuFile.openWrite(mode: FileMode.append);
      imuSink.write('$timestamp\n'
          '$strAccelerometer\n'
          '$strUserAccelerometer\n'
          '$strGyroscope\n'
          '$strMagnetometer\n'

          '$strOrientation\n'
          '$strAbsoluteOrientationDegree\n'
          '$strIntegratedOrientation\n'
          '\n');
      imuSink.close();
    }

    final downloadDir = Directory('/storage/emulated/0/Download/Logger/');
    downloadDir.exists().then((value) {
      if (!value) {
        downloadDir.create();
      }
    } );

    // _onSwitchCamera();
    // MyAppState.setUpdateInterval(1, Duration.microsecondsPerSecond ~/ 60);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMERA'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: _cameraPreviewWidget(
                  '$timestamp\n'
                  'Accelerometer:\t$strAccelerometer\n'
                  'UserAccelerometer:\t$strUserAccelerometer\n'
                  'Gyroscope:\t$strGyroscope\n'
                  'Magnetometer:\t$strMagnetometer\n\n'

                  'Orientation:\n$strOrientation\n'
                  'AbsoluteOrientationDegree:\n$strAbsoluteOrientationDegree\n'
                  'AbsoluteOrientation2:\n$strAbsoluteOrientation2\n'
                  'IntegratedOrientation:\n$strIntegratedOrientation\n'
                  'IntegratedOrientationDirectionPredict:\n$strIntegratedOrientationDirectionPredict\n'
                  // 'BaseOrientation:\t${baseOrientation.map((double v) => (v * (180/pi)).toStringAsFixed(decimalPoints)).toList().join(' ')}'
                      '\n\n'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
                IconButton(
                  icon: const Icon(Icons.stop),
                  color: Colors.deepOrange,
                  onPressed: controller.value.isInitialized &&
                      controller.value.isRecordingVideo
                      ? _onStopButtonPressed
                      : null,
                ),

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
  Widget _cameraPreviewWidget(logs) {
    if (!controller.value.isInitialized) {
      print("Isn't initialized");
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
        child: Text(logs, style: const TextStyle(color: Colors.white30)),
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

            // Log Base Orientation
            IconButton(
              icon: const Icon(Icons.pages),
              color: Colors.white,
              onPressed: _resetOrientation,
            ),
          ],
        ),
      ),
    );
  }

  _resetOrientation() {
    setState(() {
      // baseOrientation = widget.imuData[5]!;
      MyAppState.integratedOrientationValues = [0, 0, 0];
    });
    Fluttertoast.showToast(
        msg: 'Integrated Orientation Reset into: \n${MyAppState.integratedOrientationValues}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white
    );
  }

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
