// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:adn2/components/game/grid.dart';
import 'package:adn2/components/game/information.dart';
import 'package:adn2/components/game/interaction.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return Column(
                children: [
                  Expanded(
                    flex: 20,
                    child: Information(),
                  ),
                  Expanded(
                    flex: 50,
                    child: Grid(),
                  ),
                  Expanded(
                    flex: 30,
                    child: Interaction(),
                  ),
                ],
              );
            }
            else {
              return Row(
                children: [
                  Expanded(
                    child: Grid(),
                  ),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 40,
                              child: Information(),
                            ),
                            Expanded(
                              flex: 60,
                              child: Interaction(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      )
    );
  }
}