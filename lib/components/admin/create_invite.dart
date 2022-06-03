// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class CreateInvite extends StatefulWidget {
  @override
  State<CreateInvite> createState() => _CreateInviteState();
}

enum SingingCharacter { pro, user }

class _CreateInviteState extends State<CreateInvite> {
  SingingCharacter? _character = SingingCharacter.user;
  double nbUserOpacity = 0;
  final isAdmin = Data.type == "admin";
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
        Data.lsInvite.add({"name": nameController.text, "token": data['token']});

        Navigator.of(context).pop();
        Clipboard.setData(ClipboardData(text: "${Conf.url}register?${data['token']}"));
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text('Créer un utilisateur', textScaleFactor: 1.5, style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
        ),
        Visibility(
          visible: isAdmin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Type d'utilisateur"),
              Container(
                color: Colors.grey[200],
                margin: EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Text('Joueur'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.user,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                        nbUserOpacity = 0;
                      });
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                margin: EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Text('Professionnel'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.pro,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                        nbUserOpacity = 1;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom',
            ),
          ),
        ),
        Visibility(
          visible: isAdmin,
          child: Opacity(
            opacity: nbUserOpacity,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: nbUserController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre d\'utilisateurs',
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                sendReq(context);
              },
              child: Text('Créer'),
            ),
          ],
        ),
      ],
    );
  }
}