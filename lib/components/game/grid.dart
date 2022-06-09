// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/account/login.dart';
import 'package:adn2/pages/no_game.dart';
import 'package:adn2/pages/ps_work/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // fill _cases
    List<Widget> _column = [];
    for (int i = 0; i < Data.cote; i++) {
      List<Widget> _row = [];
      for (int j = 0; j < Data.cote; j++) {
        _row.add(Expanded(
            child: Case(i, j),
          ),
        );
      }
      _column.add(
        Expanded(child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _row,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        color: Style.bgCase,
        child: Column(
          children: _column,
        ),
      ),
    );
  }
}

class Case extends StatefulWidget {
  late int x;
  late int y;

  Case(this.x, this.y, {Key? key}) : super(key: key);

  @override
  _Case createState() => _Case(x, y);
}
class _Case extends State<Case> {
  late int x;
  late int y;
  late int color;
  late int shape;
  double _angle = Random().nextInt(360) * pi / 180;
  late bool isPionFix;
  late bool isPionVar;
  late bool inError;
  late Color _bgColor;
  late Widget _pion;
  late Timer timer;

  _Case(this.x, this.y);

  Future<void> reqSave(BuildContext context) async {
    // convert pionVar to string
    var movePlayed = [];
    for (var p in Data.pionVar) {
      movePlayed.add("${p['x'] + 1}${p['y'] + 1}${p['color']}${p['shape']}");
    }

    final res = await http.post(
      Uri.parse(Conf.uri + 'save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
        'grid': Data.grid,
        'movePlayed': movePlayed.join(" "),
        'gridTime': Data.timerSeconds,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['res'] == "noConnected") {
        Navigator.of(context).pushReplacement(routeTo(Login()));
      }
      else if (data["res"] == "oldGame") {
        Data.inGame = false;
        Data.updateGameState(data["game"]);
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Style.bgPopup,
              content: Text(
                "Vous avez déjà fini cette grille",
                textScaleFactor: 2,
                style: TextStyle(
                  color: Color.fromARGB(255, 87, 168, 91),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Data.inGame = true;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(routeTo(Game()));
                  },
                  child: Text(
                    'Continuer',
                    textScaleFactor: 2,
                  ),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
      }
      else if (data["res"] == "gridError") {
        playSound("error.mp3");
        Data.error = {
          "type": data["type"],
          "num": data["num"],
        };
        update();
        setState(() {});
        Timer(Duration(milliseconds: 75), () => {
          Data.error = null
        });
      }
      else if (data["res"] == "newGame" || data["res"] == "noGame") {
        Data.error = {
          "type": "rien",
        };
        
        int lastTimer = Data.timerSeconds;
        Data.inGame = false;

        if (data["res"] == "newGame") {
          Data.updateGameState(data["game"]);
        }
        else {
          Data.timeToReset = data["timeToReset"];
        }
        
        playSound("victory.mp3");
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Style.bgPopup,
              title: Text(
                'C\'est gagné !',
                textScaleFactor: 2,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Félicitations, vous avez réussi cette grille en ${((lastTimer) ~/ 60).toString()} minutes et ${((lastTimer) % 60).toString()} secondes",
                textScaleFactor: 2,
                style: TextStyle(
                  color: Color.fromARGB(255, 87, 168, 91),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (data["res"] == "newGame") {
                      Data.inGame = true;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).pushReplacement(routeTo(Game()));
                    }
                    else {
                      Navigator.of(context).pushReplacement(routeTo(NoGame()));
                    }
                  },
                  child: Text(
                    'Continuer',
                    textScaleFactor: 2,
                  ),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
      }
    }
  }

  void update() {
    isPionFix = false;
    isPionVar = false;
    inError = false;

    // define _bgColor
    // define isPionFix
    for (var p in Data.pionFix) {
      if (p['x'] == x && p['y'] == y) {
        isPionFix = true;
        color = p['color'];
        shape = p['shape'];
        break;
      }
    }

    // define inError
    if (Data.error != null && (Data.error["type"] == "row" && Data.error["num"] == y || Data.error["type"] == "column" && Data.error["num"] == x)) {
      inError = true;
    }
    
    if (isPionFix) {
      _bgColor = Colors.blueGrey.shade200;
    }
    else {
      // define isPionVar
      for (var p in Data.pionVar) {
        if (p['x'] == x && p['y'] == y) {
          isPionVar = true;
          color = p['color'];
          shape = p['shape'];
          break;
        }
      }

      if (inError) {
        _bgColor = Colors.red.shade100;
      }
      else {
        _bgColor = Style.bgCase;
      }
    }

    // define _pion
    if (isPionFix || isPionVar) {
      _pion = Center(
        child: Transform.rotate(
          angle: _angle,
          child: FractionallySizedBox(
            heightFactor: 0.7,
            widthFactor: 0.7,
            child: SvgPicture.asset(
              "assets/shapes/${Data.lsShape[shape]}/${Data.lsColor[color]}.svg",
            ),
          ),
        ),
      );
    }
    else {
      _pion = Container();
    }
    if (!isPionFix) {
      _pion = ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          primary: Colors.transparent,
          shadowColor: Colors.transparent
        ),
        onPressed: () {
          // case is empty
          if (!isPionVar) {
            playSound("place.mp3");

            Data.pionVar.add({'x': x, 'y': y, 'color': Data.currentColor, 'shape': Data.currentShape});
          }
          // case is not empty
          else {
            for (var p in Data.pionVar) {
              if (p['x'] == x && p['y'] == y) {
                if (p["color"] != Data.currentColor || p["shape"] != Data.currentShape) {
                  if (Data.currentColor == 0 && Data.currentShape == 0) {
                    // remove pion
                    playSound("fac.mp3");

                    Data.pionVar.removeWhere((e) => e == p);
                    Data.error = {
                      "type": "rien",
                    };
                  }
                  else {
                    // update pion
                    playSound("fac.mp3");
                    playSound("place.mp3");

                    p['color'] = Data.currentColor;
                    p['shape'] = Data.currentShape;
                  }
                }
                break;
              }
            }
          }

          update();
          setState(() {});
          reqSave(context);
        },
        child: _pion,
      );
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (Data.error != null && !isPionFix) {
        update();
        setState(() {});
      }
    });

    update();
    reqSave(context);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: BoxDecoration(
            color: _bgColor,
            border: Border.all(
              color: Style.borderCase,
              width: constraints.maxHeight / 100,
            ),
          ),
          child: _pion,
        );
      },
    );
  }
}