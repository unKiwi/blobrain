// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/util.dart';
import 'package:adn2/pages/account/login.dart';
import 'package:adn2/pages/ps_work/admin.dart';
import 'package:adn2/pages/ps_work/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Future<void> req(BuildContext context) async {
    final res = await http.post(
      Uri.parse(Conf.uri + 'logOut'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
      }),
    );

    if (res.statusCode == 200) {
      Data.type = "user";
      // Data.lsInvite.clear();
      // Data.lsUser.clear();

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(routeTo(Login()));
    }
    else {
      // relaunch req
      // req(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFf7e7bd),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4096b6),
        automaticallyImplyLeading: false,
        title: const Text("Paramètres"),
        centerTitle: true,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent
            ),
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              color: Color(0xFF304650),
              size: 36.0,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              child: Opacity(
                opacity: 0.3,
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  color: Colors.white,
                  
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (Data.type == "admin" || Data.type == "pro") {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(routeTo(Game()));
                        },
                        child: Text("Jouer"),
                      ),
                      SizedBox(height: 40,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(routeTo(Admin()));
                        },
                        child: Text("Mon espace"),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // deconnexion
          req(context);
        },
        backgroundColor: Colors.red[700],
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}