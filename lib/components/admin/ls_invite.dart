import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:adn2/data/data.dart';
import 'package:adn2/data/http.dart';
import 'package:adn2/data/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LsInvite extends StatefulWidget {
  @override
  State<LsInvite> createState() => _LsInviteState();
}

class _LsInviteState extends State<LsInvite> {
  Future<void> sendReq(String invite) async {
    var res = await Http.req(
      "deleteInvite",
      {
        "id": Data.id,
        "invite": invite,
      },
    );

    if (res != "ko") {
      final data = jsonDecode(res.body);
      if (data['res'] == "ok") {
        setState(() {
          Data.lsInvite.removeWhere((element) => element["token"] == invite);
        });
      }
    }
  }
    
  @override
  Widget build(BuildContext context) {
    List<DataRow> _invites = [];
    Data.lsInvite.forEach((user) {
      _invites.add(DataRow(cells: [
        DataCell(Text(user["name"] ?? ""),),
        DataCell(TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: "${Conf.url}register?${user["token"] ?? ""}"));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Style.bgPopup,
                content: Text(
                  "Invitation copié dans le presse papier",
                  textScaleFactor: 2,
                ),
              ),
            );
          },
          child: Text(user["token"] ?? ""),
        ),),
        DataCell(Center(
          child: IconButton(
            onPressed: () {
              sendReq(user["token"] ?? "");
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
              DataColumn(label: Text("Invitation")),
              DataColumn(label: Text("Supprimer")),
            ],
            rows: _invites,
          ),
        ),
      ]
    );
  }
}