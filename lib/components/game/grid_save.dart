// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:math';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/account/login.dart';
import 'package:adn2/pages/ps_work/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Grid extends StatefulWidget {
  @override
  _Grid createState() => _Grid();
}
class _Grid extends State<Grid> {
  late List<Widget> _grid;
  
  @override
  void initState() {
    update();
    super.initState();
  }

  void update() {
    _grid = [];

    // fill grid
    for (int i = 0; i < Data.cote; i++) {
      List<Widget> _row = [];

      for (int j = 0; j < Data.cote; j++) {
        _row.add(Case(j, i, this));
      }

      _grid.add(
        Expanded(child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _row,
          ),
        ),
      );
    }

    setState(() {
      _grid;
    });
  }

  @override
	Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          color: Style.bgCase,
          width: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width / 2 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width / 2 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.height,
          child: Column(children: _grid,),
        ),
      ),
    );
  }
}

class Case extends StatefulWidget {
  late int x;
  late int y;
  late var parent;

  Case(this.x, this.y, this.parent, {Key? key}) : super(key: key);

  @override
  _Case createState() => _Case(x, y, parent);
}

class _Case extends State<Case> {
  late int x;
  late int y;
  late var parent;

  Widget pion = Container();

  _Case(this.x, this.y, this.parent);

  @override
  void initState() {
    update();
    super.initState();
  }

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
        Navigator.of(context).pushReplacement(routeTo(Game()));
      }
      else if (data["res"] == "gridError") {
        Data.error = {
          "type": data["type"],
          "num": data["num"],
        };
        print("parent.update();");
        parent.update();
        // Data.error = null;
      }
      else if (data["res"] == "newGame") {
        int lastTimer = Data.timerSeconds;
        Data.inGame = false;
        Data.updateGameState(data["game"]);
        
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
                    Data.inGame = true;
                    Navigator.of(context).pop();
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
        ).then((val) {
          Data.inGame = true;
          Navigator.of(context).pushReplacement(routeTo(Game()));
        });
      }
    }
  }
  
  void update() {
    // play sound


    // update grid
    pion = Container();
    for (var p in Data.pionFix) {
      if (p['x'] == x && p['y'] == y) {
        var angle = Random().nextInt(360) * pi / 180;
        pion = Container(
          color: Colors.blueGrey[200],
          child: Center(
            child: Transform.rotate(
              angle: angle,
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: 0.7,
                child: SvgPicture.asset(
                  "assets/shapes/${Data.lsShape[p['shape']]}/${Data.lsColor[p['color']]}.svg",
                ),
              ),
            ),
          ),
        );
        break;
      }
    }

    for (var p in Data.pionVar) {
      if (p['x'] == x && p['y'] == y) {
        var _bgColor;
        print(Data.error);
        if (Data.error != null) {
          if (Data.error["type"] == "row") {
            if (Data.error["num"] == y) {
              _bgColor = Colors.red.shade100;
            }
          }
          else {
            if (Data.error["num"] == x) {
              _bgColor = Colors.red.shade100;
            }
          }
        }
        pion = Container(
          color: _bgColor,
          child: Center(
            child: Transform.rotate(
              angle: Random().nextInt(360) * pi / 180,
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: 0.7,
                child: SvgPicture.asset(
                  "assets/shapes/${Data.lsShape[p['shape']]}/${Data.lsColor[p['color']]}.svg",
                ),
              ),
            ),
          ),
        );
        break;
      }
    }

    setState(() {
      pion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Style.borderCase,
                width: constraints.maxHeight / 100,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                primary: Colors.transparent,
                shadowColor: Colors.transparent
              ),
              onPressed: () {
                // case can not be update
                for (var p in Data.pionFix) {
                  if (p['x'] == x && p['y'] == y) {
                    return;
                  }
                }

                

                // case can be update
                for (var p in Data.pionVar) {
                  if (p['x'] == x && p['y'] == y) {
                    p['color'] = Data.currentColor;
                    p['shape'] = Data.currentShape;

                    if (Data.currentColor == 0 && Data.currentShape == 0) {
                      // remove pion
                      Data.pionVar.removeWhere((e) => e == p);
                    }

                    update();
                    reqSave(context);
        
                    return;
                  }
                }

                // case not used
                if (Data.currentColor != 0 || Data.currentShape != 0) {
                  // don't add pion
                  Data.pionVar.add({'x': x, 'y': y, 'color': Data.currentColor, 'shape': Data.currentShape});
                  update();
                  reqSave(context);
                }
              },
              child: pion,
            ),
          );
        }
      ),
    );
  }
}