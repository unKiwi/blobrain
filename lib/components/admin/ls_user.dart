import 'package:adn2/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LsUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DataRow> _users = [];
    Data.lsUser.forEach((user) {
      _users.add(DataRow(cells: [
        DataCell(Text(user["prenom"] ?? ""),),
        DataCell(Text(user["email"] ?? ""),),
        DataCell(IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete),
        ),),
      ]));
    });

    return Center(
      child: DataTable(
        columns: [
          DataColumn(label: Text("Nom")),
          DataColumn(label: Text("Mail")),
          DataColumn(label: Text("Supprimer")),
        ],
        rows: _users,
      ),
    );
  }
}