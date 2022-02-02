// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, avoid_print, unused_field, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:convert';

import 'package:adn2/components/settings.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/loading.dart';
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
                        SizedBox(height: 40,),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.all(10),
                          child: RaisedButton(
                            onPressed: () async {
                              var res = await Http.req(
                                "resendMail",
                                {
                                  "id": Data.id,
                                },
                              );

                              if (res != "ko") {
                                final data = jsonDecode(res.body);
                                if (data["res"] == "ok") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Email envoyé"),
                                    ),
                                  );
                                }
                                else {
                                  Navigator.of(context).pushReplacement(routeTo(Loading()));
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints:
                                  BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Renvoyer l'email",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(routeTo(Settings()));
        },
        backgroundColor: Style.bgSecondary,
        child: const Icon(Icons.settings),
      ),
    );
  }
}