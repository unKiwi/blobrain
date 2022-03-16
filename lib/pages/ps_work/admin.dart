// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, curly_braces_in_flow_control_structures

import 'package:adn2/components/admin/create_invite.dart';
import 'package:adn2/components/settings.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

enum SingingCharacter { pro, user }

class _AdminState extends State<Admin> {
  SingingCharacter? _character = SingingCharacter.pro;
  final nbUserController = TextEditingController();
  final nameController = TextEditingController();
  List<Widget> _form = [];

  Widget _lsInvite = Container(
    color: Colors.blueGrey,
    height: 100,
    width: 100,
  );
  Widget _lsUser = Container(
    color: Colors.red,
    height: 100,
    width: 100,
  );

  late Widget _body;

  @override
  void initState() {
    super.initState();

    _body = _lsUser;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    nbUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Data.type[0].toUpperCase()}${Data.type.substring(1).toLowerCase()}"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              setState(() {
                _body = _lsUser;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add_alt_sharp),
            onPressed: () {
              setState(() {
                _body = _lsInvite;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                Navigator.of(context).pushReplacement(routeTo(Settings()));
              });
            },
          )
        ],
      ),
      body: _body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: CreateInvite(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}