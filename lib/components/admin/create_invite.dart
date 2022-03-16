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
  SingingCharacter? _character = SingingCharacter.pro;
  final nbUserController = TextEditingController();
  final nameController = TextEditingController();

  List<Widget> _form = [];

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
    _form = [];
    _form.add(
      Center(
        child: Text('Créer un utilisateur', textScaleFactor: 1.5, style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
    if (Data.type == "admin") _form.add(
      Text("Type d'utilisateur"),
    );
    if (Data.type == "admin") _form.add(
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
              });
            },
          ),
        ),
      ),
    );
    if (Data.type == "admin") _form.add(
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
              });
            },
          ),
        ),
      ),
    );
    _form.add(
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
    );
    if (Data.type == "admin") _form.add(
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: nbUserController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre d\'utilisateur',
          ),
        ),
      ),
    );
    _form.add(
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
              // Navigator.pop(context);
              sendReq(context);
            },
            child: Text('Créer'),
          ),
        ],
      )
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _form,
    );
  }
}