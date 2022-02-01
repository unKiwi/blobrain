// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, avoid_print, unused_field

import 'dart:async';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

    // init();

    super.initState();
  }

  Future<void> init() async {
    // get id
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    Data.id = prefs.getString('id') ?? '';
    
    var res = await Http.req(
      "loading",
      {
        "id": Data.id,
      },
    );

    if (res != "ko") {
      print("ok");
    }
    // cannot join the server
    else {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Erreur de connection"),
          content: Text("Impossible de se connecter au serveur"),
          actions: [TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Réessayer'),
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
                        child: TextButton(
          onPressed: () {init();},
          child: const Text('Réessayer'),
        )
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