// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:adn2/components/level.dart';
import 'package:adn2/components/settings.dart';
import 'package:adn2/components/timer.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _radius = constraints.maxHeight / 10;
        double _margin = constraints.maxHeight / 10;
        double _textHeight = constraints.maxHeight * 0.2;

        return Container(
          decoration: BoxDecoration(
            color: Style.bgSecondary,
            borderRadius: BorderRadius.all(Radius.circular(_radius)),
          ),
          margin: EdgeInsets.all(_margin),
          padding: EdgeInsets.all(_margin * 0.7),
          child: Column(
            children: [
              Expanded(
                flex: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Blobrain",
                        style: TextStyle(
                          color: Color(0xFF00B177),
                          fontSize: _textHeight,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      // AspectRatio(
                      //   aspectRatio: 1 / 1,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.blue[700],
                      //       padding: const EdgeInsets.all(0),
                      //     ),
                      //     onPressed: () {
                      //       showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) => SuccesPopup(),
                      //       );
                      //     },
                      //     child: LayoutBuilder(
                      //       builder: (BuildContext context, BoxConstraints constraints) {
                      //         return Icon(
                      //           Icons.star,
                      //           color: Colors.amber,
                      //           size: constraints.maxWidth * 0.7,
                      //         );
                      //       }
                      //     ),
                      //   ),
                      // ),
                    ),
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[700],
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(routeTo(Settings()));
                          },
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return Icon(
                                Icons.settings,
                                color: Style.borderCase,
                                size: constraints.maxWidth * 0.7,
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 10,),
              Expanded(
                flex: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Level(),
                      ),
                    ),
                    Flexible(
                      child: OtpTimer(),
                    ),
                  ],
                ),
              ),
            ],
          )
        );
      }
    );
  }
}