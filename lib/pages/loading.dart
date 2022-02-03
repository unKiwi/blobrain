// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, avoid_print, unused_field, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/account/login.dart';
import 'package:adn2/pages/account/register.dart';
import 'package:adn2/pages/account/reset_passwd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _Loading createState() => _Loading();
}

class _Loading extends State<Loading> {
  late SharedPreferences prefs;
  double _opacity = 0;
  final now = DateTime.now().millisecondsSinceEpoch;

  int _timeOut = 0; // 500
  int _animationDuration = 0; // 1000
  late int _totalDuration;

  @override
  void initState() {
    _totalDuration = _timeOut + _animationDuration + 0; // 500

    Timer(Duration(milliseconds: _timeOut), () => {
      setState(() => _opacity = 1),
    });

    init();

    super.initState();
  }

  Future<void> init() async {
    // get id
    prefs = await SharedPreferences.getInstance();
    Data.id = prefs.getString('id') ?? '';

    if (window.location.pathname == "/register") {
      Navigator.of(context).push(routeTo(Login()));
      Navigator.of(context).push(routeTo(Register()));
    }
    else if (window.location.pathname == "/resetPassword") {
      Navigator.of(context).push(routeTo(Login()));
      Navigator.of(context).push(routeTo(ResetPassword()));
    }
    else {
      sendReq();
    }
    
  }

  Future<void> sendReq() async {
    var res = await Http.req(
      "loading",
      {
        "id": Data.id,
      },
    );

    if (res != "ko") {
      int duration =  now + _totalDuration - DateTime.now().millisecondsSinceEpoch;
      Timer(Duration(milliseconds: duration), () {
        setState(() => _opacity = 0);
      });
      Timer(Duration(milliseconds: duration + _animationDuration), () {
        final data = jsonDecode(res.body);
        if (data['res'] == "newId") {
          prefs.setString('id', data['newId']);
          Data.id = data['newId'];

          Navigator.of(context).pushReplacement(routeTo(Login()));
        }
        else {
          nextPage(context, data);
        }
      });
    }
    // cannot join the server
    else {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.blueGrey[800],
          title: Text(
            "Erreur de connection",
            textScaleFactor: 2,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Impossible de se connecter au serveur",
            textScaleFactor: 2,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [TextButton(
            onPressed: () {
              Navigator.pop(context);
              sendReq();
            },
            child: const Text(
              'Réessayer',
              textScaleFactor: 2,
            ),
          )],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgPrimary,
      body: AnimatedOpacity(
        duration: Duration(milliseconds: _animationDuration),
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