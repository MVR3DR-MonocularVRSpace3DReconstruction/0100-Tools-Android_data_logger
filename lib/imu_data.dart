import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'package:flutter/material.dart';

const int decimalPoints = 11;

class IMUData extends StatefulWidget {
  final String timestamp;
  final String strAccelerometer;
  final String strUserAccelerometer;
  final String strGyroscope;
  final String strMagnetometer;
  const IMUData({Key? key, required this.timestamp,required this.strAccelerometer,required this.strUserAccelerometer,required this.strGyroscope,required this.strMagnetometer}) : super(key: key);

  @override
  IMUDataState createState() => IMUDataState();
}

class IMUDataState extends State<IMUData> {

  get timestamp => widget.timestamp;
  get strUserAccelerometer => widget.strUserAccelerometer;
  get strAccelerometer => widget.strAccelerometer;
  get strGyroscope => widget.strGyroscope;
  get strMagnetometer => widget.strMagnetometer;

  @override
  Widget build(BuildContext context) {


    // print('$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n');
    String log = '$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n';

    MyAppState.setUpdateInterval(1, Duration.microsecondsPerSecond ~/ 60);

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
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,

              child: Text(log),
            ),
          ],
        ),
    );
  }

}
