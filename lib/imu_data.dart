import 'dart:async';
import 'dart:io';
import 'main.dart';
import 'package:flutter/material.dart';

const int decimalPoints = 11;

class IMUData extends StatefulWidget {
  const IMUData({Key? key}) : super(key: key);

  @override
  IMUDataState createState() => IMUDataState();
}

class IMUDataState extends State<IMUData> {

  String timestamp = MyAppState.timestamp;
  String strAccelerometer = MyAppState.strAccelerometer;
  String strUserAccelerometer = MyAppState.strUserAccelerometer;
  String strGyroscope = MyAppState.strGyroscope;
  String strMagnetometer = MyAppState.strMagnetometer;

  @override
  void initState() {
    super.initState();
    timestamp = MyAppState.timestamp;
    strAccelerometer = MyAppState.strAccelerometer;
    strUserAccelerometer = MyAppState.strUserAccelerometer;
    strGyroscope = MyAppState.strGyroscope;
    strMagnetometer = MyAppState.strMagnetometer;
  }
  @override
  Widget build(BuildContext context) {

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
