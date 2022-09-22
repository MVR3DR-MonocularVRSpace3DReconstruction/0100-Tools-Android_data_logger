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
  late String strOrientation;

  @override
  Widget build(BuildContext context) {
    setState(() {
      x = widget.orientationValues![0] - VideoRecorderExampleState.baseOrientation[0];
      y = widget.orientationValues![1] - VideoRecorderExampleState.baseOrientation[1];
      z = widget.orientationValues![2] - VideoRecorderExampleState.baseOrientation[2];
      strOrientation = widget.orientationValues!.map((double v) => (v * (180/pi)).toStringAsFixed(7)).toList().join(' ');
    });

    return Container(
      color: Colors.black26,
      child: Stack(
        children: [
          Text('\n\n\n\t   $strOrientation\n\n   X: ${x+pi/2}\n   Y: ${(x>0?y-pi/2:-y+pi/2)}\n   Z: ${z+pi/2}'),
          Center(
            // child: Text('能力有限，开发中（咕咕咕）\n _(:з」∠)_'),
            child: Transform(
              transform:
              // Matrix4(
              //   cos(x)*cos(z)-cos(y)*sin(x)*sin(z), -cos(y)*cos(z)*sin(x), sin(x)*sin(y), 0,
              //   cos(y)*sin(x)+cos(x)*cos(y)*cos(z), cos(x)*cos(y)*cos(z)-sin(x)*sin(z),-cos(x)*sin(y),0,
              //   sin(y)*sin(z), cos(y)*cos(z), cos(y), 0,
              //   0, 0, 0, 1
              // ),
              Matrix4.identity()
                ..setEntry(3, 2, 0.003) // col = 2, row = 3 & 0.003 = depth perception in the Z direction
                ..rotateX((x>0?y-pi/2:-y+pi/2))
                ..rotateY(-x-pi/2)
                ..rotateZ(z-pi),
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
                  color: Colors.black38,
                  borderRadius: const BorderRadius.all( Radius.circular(4.0)),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child:const Center(child:  Text('囧', style: TextStyle(fontSize: 90, fontWeight: FontWeight.w700),),)
              ),
            ),

          ),
        ],
      )
    );
  }
}