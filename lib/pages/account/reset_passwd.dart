// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPassword createState() {
    return _ResetPassword();
  }
}

class _ResetPassword extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<void> sendReq(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var res = await Http.req(
        "resetPassword",
        {
          "id": Data.id,
          "token": window.location.href.split('?')[1],
          "password": passwordController.text,
        },
      );

      if (res != "ko") {
        final data = jsonDecode(res.body);
        if (data["res"] != "ko") {
          nextPage(context, data);
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Style.bgPopup,
              content: Text(
                "Le lien que vous utilisez est invalide",
                textScaleFactor: 2,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Style.bgPrimary,
              Color(0xFF485272),
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Réinitialiser mon mot de passe", style: TextStyle(color: Colors.white, fontSize: 40),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(49, 57, 84, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Saisisez votre mot de passe';
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "Mot de passe",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty || passwordConfirmController.text != passwordController.text) {
                                        return 'Saisisez votre mot de passe';
                                      }
                                      return null;
                                    },
                                    controller: passwordConfirmController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "Confirmez votre mot de passe",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.all(10),
                          child: RaisedButton(
                            onPressed: () {
                              sendReq(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            padding: EdgeInsets.all(0.0),
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
                                  "Réinitialiser mon mot de passe",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Connexion", style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}