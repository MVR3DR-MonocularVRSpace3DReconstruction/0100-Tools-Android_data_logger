import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:path_provider/path_provider.dart';

const int decimalPoints = 11;

class IMUData extends StatefulWidget {
  const IMUData({Key? key}) : super(key: key);

  @override
  _IMUDataState createState() => _IMUDataState();
}

class _IMUDataState extends State<IMUData> {
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
    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final gyroscope = _gyroscopeValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();
    final magnetometer = _magnetometerValues?.map((double v) => v.toStringAsFixed(decimalPoints)).toList();

    String timestamp = DateTime.now().toString();
    String strAccelerometer = accelerometer!.join(' ');
    String strUserAccelerometer = userAccelerometer!.join(' ');
    String strGyroscope = gyroscope!.join(' ');
    String strMagnetometer = magnetometer!.join(' ');

    log = '$timestamp\n$strAccelerometer\n$strUserAccelerometer\n$strGyroscope\n$strMagnetometer\n\n' + log;

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

              child: ListView(
                children: [
                  Text(log),
                ],
              )
            ),
          ],
        ),
    );
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
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
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
}
