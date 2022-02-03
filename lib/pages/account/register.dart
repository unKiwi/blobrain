// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:html';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _Register createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final inviteController = TextEditingController();

  Future<void> req(BuildContext context) async {
    final res = await http.post(
      Uri.parse(Conf.uri + 'register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
        'prenom': firstNameController.text,
				'email': emailController.text,
				'password': passwordController.text,
				'inviteLink': inviteController.text
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['res'] != "error") {
        Navigator.of(context).pop();
        nextPage(context, data);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['lsError'].join('\n')),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // define _lsInput
    var _lsInput = <Widget>[];
    _lsInput.add(Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Saisisez votre prénom';
          }
          return null;
        },
        controller: firstNameController,
        decoration: InputDecoration(
          labelText: "Prénom",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        ),
      ),
    ));
    _lsInput.add(Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Saisisez votre email';
          }
          return null;
        },
        controller: emailController,
        decoration: InputDecoration(
          labelText: "Email",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        ),
      ),
    ));
    _lsInput.add(Container(
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
    ));
    _lsInput.add(Container(
      padding: const EdgeInsets.all(10),
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
        controller: passwordConfirmController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Confirmez votre mot de passe",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        ),
      ),
    ));
    if (window.location.pathname != "/register") {
      _lsInput.add(Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))
        ),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Saisisez votre invitation';
            }
            return null;
          },
          controller: inviteController,
          decoration: InputDecoration(
            labelText: "Invitation",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none
          ),
        ),
      ));
    }
    else {
      inviteController.text = window.location.href.split('?')[1];
    }

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
                  Text("Inscription", style: TextStyle(color: Colors.white, fontSize: 40),),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(
                              color: Color.fromRGBO(49, 57, 84, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: _lsInput,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40,),
                        Container(
                          height: 50.0,
                          margin: const EdgeInsets.all(10),
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (passwordController.text == passwordConfirmController.text) {
                                  req(context);
                                }
                                else {
                                  await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Erreur !'),
                                        content: Text(
                                          "Mot de passe non identique",
                                          style: TextStyle(color: Colors.red.shade500),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "M'inscrire",
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