// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:adn2/components/admin/create_invite.dart';
import 'package:adn2/components/admin/ls_invite.dart';
import 'package:adn2/components/settings.dart';
import 'package:adn2/data/style.dart';
import 'package:adn2/data/util.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _Admin();
}

class _Admin extends State<Admin> {
  int _selectedIndex = 0;
  static TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    LsInvite(),
    Text(
      'Arrive plus tard',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.bgPrimary,
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[700],
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.of(context).push(routeTo(Settings()));
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Icon(
                    Icons.settings,
                    color: Style.borderCase,
                    size: constraints.maxWidth * 0.7,
                  );
                }
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(routeTo(CreateInvite()));
        },
        backgroundColor: Style.bgSecondary,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Invitation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Utilisateur',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}