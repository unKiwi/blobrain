import 'dart:convert';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:flutter/material.dart';

class LsUser extends StatefulWidget {
  @override
  State<LsUser> createState() => _LsUserState();
}

class _LsUserState extends State<LsUser> {
  Future<void> sendReq(String email) async {
    var res = await Http.req(
      "deleteUser",
      {
        "id": Data.id,
        "email": email,
      },
    );

    if (res != "ko") {
      final data = jsonDecode(res.body);
      if (data['res'] == "ok") {
        setState(() {
          Data.lsUser.removeWhere((user) => user["email"] == email);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> _users = [];
    Data.lsUser.forEach((user) {
      _users.add(DataRow(cells: [
        DataCell(Text(user["prenom"] ?? ""),),
        DataCell(Text(user["email"] ?? ""),),
        DataCell(Text(user["nbGameByDay"].toString() ?? ""),),
        DataCell(Text('${((user["avgTimeByGrid"]) ~/ 60).toString().padLeft(2, '0')}:${((user["avgTimeByGrid"]) % 60).toString().padLeft(2, '0')}' ?? ""),),
        DataCell(Center(
          child: IconButton(
            onPressed: () {
              sendReq(user["email"] ?? "");
            },
            icon: Icon(Icons.delete),
          ),
        ),),
      ]));
    });

    return ListView(
      children: [
        Center(
          child: DataTable(
            columns: [
              DataColumn(label: Text("Nom")),
              DataColumn(label: Text("Mail")),
              DataColumn(label: Text("Partie")),
              DataColumn(label: Text("Temps")),
              DataColumn(label: Text("Supprimer")),
            ],
            rows: _users,
          ),
        ),
      ]
    );
  }
}