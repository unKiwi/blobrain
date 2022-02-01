// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, avoid_print, unused_field, prefer_const_literals_to_create_immutables

import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';

class VerifMail extends StatelessWidget {
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
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: constraints.maxWidth,
                        ),
                      );
                    }
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          "Vérifiez votre mail",
                          textScaleFactor: 2,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => {},
                              child: Text(
                                "Renvoyer l'email",
                                textScaleFactor: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}