import 'package:adn2/data/data.dart';
import 'package:flutter/material.dart';

class LsInvite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DataRow> _invites = [];
    Data.lsInvite.forEach((user) {
      _invites.add(DataRow(cells: [
        DataCell(Text(user["name"] ?? ""),),
        DataCell(Text(user["token"] ?? ""),),
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
          DataColumn(label: Text("Invitation")),
          DataColumn(label: Text("Supprimer")),
        ],
        rows: _invites,
      ),
    );
  }
}