// ignore_for_file: use_key_in_widget_constructors

import 'package:adn2/components/btn_giv_up.dart';
import 'package:adn2/components/connection_status.dart';
import 'package:adn2/components/pion_selector.dart';
import 'package:flutter/material.dart';

class Interaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _margin = constraints.maxHeight / 10;

        return Stack( //////////////////////////////////// truc rouge dans la console
          children: [
            Container(
              margin: EdgeInsets.all(_margin),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: PionSelector(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: BtnGivUp(),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   right: 0,
            //   bottom: 0,
            //   child: ConnectionStatus(),
            // ),
          ],
        );
      }
    );
  }
}