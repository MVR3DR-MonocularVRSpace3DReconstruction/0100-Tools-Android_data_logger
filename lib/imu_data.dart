import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'main.dart';
import 'package:flutter/material.dart';


const int decimalPoints = 11;

class IMUData extends StatefulWidget {
  String timestamp;
  List<double>? accelerometerValues = [0, 0, 0];
  List<double>? userAccelerometerValues = [0, 0, 0];
  List<double>? gyroscopeValues = [0, 0, 0];
  List<double>? magnetometerValues = [0, 0, 0];
  List<double>? orientationValues = [0, 0, 0];
  List<double>? absoluteOrientationValues = [0, 0, 0];
  IMUData({Key? key,
    required this.timestamp,
    required this.accelerometerValues,
    required this.userAccelerometerValues,
    required this.gyroscopeValues,
    required this.magnetometerValues,
    required this.orientationValues,
    required this.absoluteOrientationValues,
  }) : super(key: key);

  @override
  IMUDataState createState() => IMUDataState();
}

class IMUDataState extends State<IMUData> {

  // imu
  late String timestamp;
  late String strAccelerometer;
  late String strUserAccelerometer;
  late String strGyroscope;
  late String strMagnetometer;
  late String strOrientation;
  late String strAbsoluteOrientation;

  late String strAbsoluteOrientationDegree;

  @override
  Widget build(BuildContext context) {
    setState(() {
      timestamp = widget.timestamp;
      strAccelerometer = widget.accelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strUserAccelerometer = widget.userAccelerometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strGyroscope = widget.gyroscopeValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strMagnetometer = widget.magnetometerValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strOrientation = widget.orientationValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strAbsoluteOrientation = widget.absoluteOrientationValues!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');

      strAbsoluteOrientationDegree = widget.absoluteOrientationValues!.map((double v) => (v * (180/pi)).toStringAsFixed(decimalPoints)).toList().join(' ');
    });

    // print('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
    String log = 'Timestamp: \n\t$timestamp\n'
        'Accelerometer: \n\t$strAccelerometer\n'
        'UserAccelerometer: \n\t$strUserAccelerometer\n'
        'Gyroscope: \n\t$strGyroscope\n'
        'Magnetometer: \n\t$strMagnetometer\n'
        'OrientationValues: \n\t$strOrientation\n'
        'AbsoluteOrientation(-π,π): \n\t$strAbsoluteOrientation\n'
        'AbsoluteOrientation(-180,180): \n\t$strAbsoluteOrientationDegree\n\n';
    // MyAppState.setUpdateInterval(1, Duration.microsecondsPerSecond ~/ 60);

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Colors.red,
          title: const Text(
            'IMU Data',
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          // color: Colors.black,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,

              child: Text(log),
            ),
          ],
        ),
    );
  }

}
