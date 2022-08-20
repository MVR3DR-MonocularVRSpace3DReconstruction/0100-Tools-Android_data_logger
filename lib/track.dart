import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class Track extends StatefulWidget{
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Text('能力有限，开发中（咕咕咕）\n _(:з」∠)_'),
      ),
    );
  }
}