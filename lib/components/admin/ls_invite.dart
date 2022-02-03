// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LsInvite extends StatelessWidget {
  const LsInvite({Key? key}) : super(key: key);

  Future<void> req(BuildContext context) async {
    final res = await http.post(
      Uri.parse(Conf.uri + 'loading'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
    }
    else {
      // relaunch req
      // req(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    Data.lsInvite.forEach((invite) => {
      _children.add(ListEntity())
    });

    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: _children,
      ),
    );
  }
}

class ListEntity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF485272),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("invite"),
              Text("role"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("nom"),
              Text("nbUser"),
            ],
          ),
        ],
      ),
    );
  }
}