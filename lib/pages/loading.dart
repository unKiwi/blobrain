// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, avoid_print, unused_field

import 'dart:async';

import 'package:adn2/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatefulWidget {
  @override
  _Loading createState() => _Loading();
}

class _Loading extends State<Loading> {
  double _opacity = 0;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () => {
      setState(() => _opacity = 1),
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgPrimary,
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: _opacity,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1 / 2,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "A D N ²",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}