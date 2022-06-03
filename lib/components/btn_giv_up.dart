// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/ps_work/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BtnGivUp extends StatelessWidget {
  Future<void> req(BuildContext context) async {
    final res = await http.post(
      Uri.parse(Conf.uri + 'giveUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      Navigator.of(context).pop();
      if (data['res'] == "newGame") {
        Data.updateGameState(data["game"]);
        
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(routeTo(Game()));
      }
    }
    else {
      // relaunch req
      // req(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double _fontSize = constraints.maxHeight * 0.5;
          
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height)),
              textStyle: TextStyle(fontSize: _fontSize),
            ),
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Style.bgPopup,
                    title: Text(
                      'Attention !',
                      textScaleFactor: 2,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    content: Text(
                      "Etes-vous sûr de vouloir abandonner ?",
                      textScaleFactor: 2,
                      style: TextStyle(color: Color.fromARGB(255, 235, 76, 76)),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Annuler', textScaleFactor: 2,),
                      ),
                      TextButton(
                        onPressed: () {
                          req(context);
                        },
                        child: Text('Continuer', textScaleFactor: 2,),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Abandonner'),
          );
        }
      ),
    );
  }
}