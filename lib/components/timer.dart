// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = Duration(seconds: 1);

  late Timer _timer;

  String get timerText =>
      ' ${((Data.timerSeconds) ~/ 60).toString().padLeft(2, '0')}:${((Data.timerSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      if (Data.inGame) {
        setState(() {
          Data.timerSeconds++;
        });
      }
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _radius = constraints.maxHeight / 10;
        return Container(
          padding: EdgeInsets.all(constraints.maxHeight * 0.1),
          decoration: BoxDecoration(
            color: Style.bgCase,
            borderRadius: BorderRadius.all(Radius.circular(_radius)),
            border: Border.all(
              color: Colors.white70,
              width: constraints.maxHeight * 0.05,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // timer icon
              Icon(
                Icons.timer,
                size: constraints.maxHeight * 0.5,
              ),
              // timer value
              Text(
                timerText,
                style: TextStyle(
                  fontSize: constraints.maxHeight * 0.5,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ]
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}