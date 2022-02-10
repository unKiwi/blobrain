// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:adn2/components/settings.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoGame extends StatefulWidget {
  @override
  State<NoGame> createState() => _NoGame();
}

class _NoGame extends State<NoGame> {
  late Timer _timer;
  String get timerText =>
    '${(Data.timeToReset ~/ 3600).toString().padLeft(2, '0')}:${((Data.timeToReset % 3600) ~/ 60).toString().padLeft(2, '0')}:${((Data.timeToReset) % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (Data.timeToReset <= 1) {
          Data.timeToReset = 3600 * 24;
          nextPage(context);
        }
        else {
          Data.timeToReset--;
        }
      });
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
    return Scaffold(
      backgroundColor: Style.bgPrimary,
      body: Center(
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
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Vous avez assez joué aujourd'hui...\nMais revenez dans $timerText pour vos prochaines grilles quotidiennes ... ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: '😀', // emoji characters
                            style: TextStyle(
                              fontFamily: 'EmojiOne',
                            ),
                          ),
                        ],
                      ),
                      textScaleFactor: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(routeTo(Settings()));
        },
        backgroundColor: Style.bgSecondary,
        child: const Icon(Icons.settings),
      ),
    );
  }
}