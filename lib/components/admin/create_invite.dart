// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class CreateInviteAdmin extends StatefulWidget {
  @override
  State<CreateInviteAdmin> createState() => _CreateInviteAdminState();
}

enum SingingCharacter { pro, user }

class _CreateInviteAdminState extends State<CreateInviteAdmin> {
  SingingCharacter? _character = SingingCharacter.pro;
  final nbUserController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> sendReq(BuildContext context) async {
    String accountType;

    if (_character == SingingCharacter.pro) {
      accountType = "pro";
    }
    else {
      accountType = "user";
    }

    final res = await http.post(
      Uri.parse(Conf.uri + 'createInvite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': Data.id,
        'role': accountType,
        'nbUser': nbUserController.text,
        'name': nameController.text,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['res'] == "ok") {
        Navigator.of(context).pop();
        Clipboard.setData(ClipboardData(text: data['token']));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Style.bgPopup,
            content: Text(
              "Invitation copié dans le presse papier",
              textScaleFactor: 2,
            ),
          ),
        );
      }
    }
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
      body: Column(
        children: [
          ListTile(
            title: Text('Professionnel'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.pro,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Joueur'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.user,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom de l\'utilisateur',
            ),
          ),
          TextField(
            controller: nbUserController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre d\'utilisateur (seulement pour le professionnel)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendReq(context);
            },
            child: Text("Créer"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: Style.bgSecondary,
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}