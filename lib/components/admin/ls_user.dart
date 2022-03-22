import 'dart:convert';

import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LsUser extends StatelessWidget {
  Future<void> sendReq(String email) async {
    var res = await Http.req(
      "deleteInvite",
      {
        "id": Data.id,
        "email": email,
      },
    );

    if (res != "ko") {
      final data = jsonDecode(res.body);
      if (data['res'] == "ok") {
        print(1);
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
              DataColumn(label: Text("Supprimer")),
            ],
            rows: _users,
          ),
        ),
      ]
    );
  }
}