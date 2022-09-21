import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'camera.dart';

class Track extends StatefulWidget{

  List<double>? orientationValues = [0, 0, 0];
  List<double>? absoluteOrientationValues = [0, 0, 0];

  Track({Key? key,
    required this.orientationValues,
    required this.absoluteOrientationValues,
  }) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {


  late double x = 0;
  late double y = 0;
  late double z = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      x = widget.orientationValues![0] - VideoRecorderExampleState.baseOrientation[0];
      y = widget.orientationValues![1] - VideoRecorderExampleState.baseOrientation[1];
      z = widget.orientationValues![2] - VideoRecorderExampleState.baseOrientation[2];
    });

    return Container(
      color: Colors.black26,
      child: Center(
        // child: Text('能力有限，开发中（咕咕咕）\n _(:з」∠)_'),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003) // col = 2, row = 3 & 0.003 = depth perception in the Z direction
            ..rotateX((x>0?y:-y)/2 + pi/2)
            ..rotateY(-x),
            // ..rotateZ(pi/2+y),
          // transform: Matrix4(
          //   1, 0, 0, 0,
          //   0, 1, 0, 0,
          //   0, 0, 1, 0.003,
          //   0, 0, 0, 1,
          // )..rotateX(x),
          alignment: FractionalOffset.center,
          child: Container(
              height: 200.0,
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.all( Radius.circular(4.0)),
                border: Border.all(width: 2, color: Colors.white),
              ),
            ),
          ),

      ),
    );
  }
}