// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/account/forgot_password.dart';
import 'package:adn2/pages/account/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _Login createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> req(BuildContext context) async {
    final res = await http.post(
      Uri.parse(Conf.uri + 'login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
        'email': emailController.text,
        'password': passwordController.text
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['res'] != "error") {
        nextPage(context, data);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error']),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
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
            const SizedBox(height: 80,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("Connexion", style: TextStyle(color: Colors.white, fontSize: 40),),
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
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
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
                                    decoration: const InputDecoration(
                                      labelText: "Email",
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
                                      if (value == null || value.isEmpty) {
                                        return 'Saisisez votre mot de passe';
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Mot de passe',
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
                              if (_formKey.currentState!.validate()) {
                                // send req
                                req(context);
                              }
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
                                  "Me connecter",
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
                            Navigator.of(context).push(routeTo(Register()));
                          },
                          child: Text("Inscription", style: TextStyle(color: Colors.grey),),
                        ),
                        SizedBox(height: 20,),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(routeTo(ForgotPassword()));
                          },
                          child: Text("Mot de passe oublié", style: TextStyle(color: Colors.grey),),
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