// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, prefer_final_fields

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

class Grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // fill _cases
    List<Widget> _column = [];
    for (int i = 0; i < Data.cote; i++) {
      List<Widget> _row = [];
      for (int j = 0; j < Data.cote; j++) {
        _row.add(Expanded(
            child: Case(j, i),
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
  bool isPionFix = false;
  bool isPionVar = false;
  bool inError = false;
  late Color _bgColor;

  _Case(this.x, this.y);

  @override
  void initState() {
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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

        return Container(
          decoration: BoxDecoration(
            color: _bgColor,
            border: Border.all(
              color: Style.borderCase,
              width: constraints.maxHeight / 100,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // define pion
              Widget pion = Center(
                child: Transform.rotate(
                  angle: Random().nextInt(360) * pi / 180,
                  child: FractionallySizedBox(
                    heightFactor: 0.7,
                    widthFactor: 0.7,
                    child: SvgPicture.asset(
                      "assets/shapes/${Data.lsShape[shape]}/${Data.lsColor[color]}.svg",
                    ),
                  ),
                ),
              );

              if (!isPionFix) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent
                  ),
                  onPressed: () {},
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      if (!isPionVar) {
                        return pion;
                      }

                      return Container();
                    }
                  ),
                );
              }
              
              return pion;
            }
          ),
        );
      },
    );
  }
}