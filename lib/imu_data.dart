import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'main.dart';
import 'package:flutter/material.dart';


const int decimalPoints = 11;

class IMUData extends StatefulWidget {
  String timestamp;
  List<List<double>?> imuData;
  IMUData({Key? key,
    required this.timestamp,
    required this.imuData,
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

  late String strAbsoluteOrientationDegreeRebase;
  late String strAbsoluteOrientationDegree;

  late String strIntegratedOrientation;
  late String strIntegratedOrientationDirectionPredict;

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
      // ],
      timestamp = widget.timestamp;
      strAccelerometer = widget.imuData[0]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strUserAccelerometer = widget.imuData[1]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strGyroscope = widget.imuData[2]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strMagnetometer = widget.imuData[3]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');

      strOrientation = widget.imuData[4]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strAbsoluteOrientation = widget.imuData[5]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strAbsoluteOrientationDegree = widget.imuData[5]!.map((double v) => (v * (180/pi)).toStringAsFixed(decimalPoints)).toList().join(' ');
      strIntegratedOrientation = widget.imuData[6]!.map((double v) => v.toStringAsFixed(decimalPoints)).toList().join(' ');
      strIntegratedOrientationDirectionPredict = widget.imuData[6]!.map((double v) => ((v * (180/pi))%360).toStringAsFixed(decimalPoints)).toList().join(' ');
    });

    // print('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
    String log = 'Timestamp: \n\t$timestamp\n'
        'Accelerometer: \n\t$strAccelerometer\n'
        'UserAccelerometer: \n\t$strUserAccelerometer\n'
        'Gyroscope: \n\t$strGyroscope\n'
        'Magnetometer: \n\t$strMagnetometer\n'
        'OrientationValues: \n\t$strOrientation\n'
        'AbsoluteOrientation(-π,π): \n\t$strAbsoluteOrientation\n'
        'AbsoluteOrientation(-180,180): \n\t$strAbsoluteOrientationDegree\n'
        'IntegratedOrientation(π): \n\t$strIntegratedOrientation\n'
        'IntegratedOrientationDirectionPredict(0,360): \n\t$strIntegratedOrientationDirectionPredict\n'
        '\n';
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
