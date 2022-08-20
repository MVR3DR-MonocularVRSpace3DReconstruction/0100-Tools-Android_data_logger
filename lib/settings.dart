import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends StatefulWidget{
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Directory downloadDir = Directory('/storage/emulated/0/Download/Logger/');
  var file;
  void _listofFiles() async {
    // directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      downloadDir = Directory('/storage/emulated/0/Download/Logger/');
      file = downloadDir.listSync();
    });
  }



  @override
  Widget build(BuildContext context) {
    _listofFiles();

    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.center,
      // color: Colors.deepOrange,
      child: ListView(
        children: [
          Container(
            height: 200,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10,bottom: 10),
            color: Colors.black26,
            child: ListView.builder(
                itemCount: file.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(file[index].toString());
            }),
          ),

          RaisedButton(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          })
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

  }
}