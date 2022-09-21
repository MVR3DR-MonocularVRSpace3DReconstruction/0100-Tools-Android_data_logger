import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';

class Settings extends StatefulWidget{
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Directory downloadDir = Directory('/storage/emulated/0/Download/Logger/');
  var _file;
  int? _groupValue=3;
  void _listOfFiles() async {
    // directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      downloadDir = Directory('/storage/emulated/0/Download/Logger/');
      _file = downloadDir.listSync();
    });
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _listOfFiles();
    });

    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      // color: Colors.deepOrange,
      child: ListView(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            color: Colors.black26,
            child: ListView.builder(
                itemCount: _file.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(_file[index].toString().split('/')[6].substring(0,_file[index].toString().split('/')[6].length-1));
            }),
          ),

          RaisedButton(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.delete),
                Text('   Clear Log data')
              ],
            ),
            color: Colors.white60,
              onPressed: () {
                _deleteFile('/storage/emulated/0/Download/Logger/');
                Fluttertoast.showToast(
                    msg: 'Data Cleared',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white
                );
          }),
          Text('\n\n   Set IMU refresh frequency:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (dynamic value) => (() {
                  MyAppState.setUpdateInterval(Duration.microsecondsPerSecond ~/ 1);
                  setState(() {
                    _groupValue = value;
                  });
                }),
              ),
              const Text("1 FPS"),
              Radio(
                value: 2,
                groupValue: _groupValue,
                onChanged: (dynamic value) => (() {
                  MyAppState.setUpdateInterval(Duration.microsecondsPerSecond ~/ 30);
                  setState(() {
                    _groupValue = value;
                  });
                }),
              ),
              const Text("30 FPS"),
              Radio(
                value: 3,
                groupValue: _groupValue,
                onChanged: (dynamic value) => (() {
                  MyAppState.setUpdateInterval(Duration.microsecondsPerSecond ~/ 60);
                  setState(() {
                    _groupValue = value;
                  });
                }),
              ),
              const Text("60 FPS"),
            ],
          ),
        ],
      ),
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
    setState(() {
      _listOfFiles();
    });
  }
}