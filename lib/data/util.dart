import 'package:adn2/data/data.dart';
import 'package:adn2/pages/buy.dart';
import 'package:adn2/pages/loading.dart';
import 'package:adn2/pages/no_game.dart';
import 'package:adn2/pages/ps_work/admin.dart';
import 'package:adn2/pages/ps_work/game.dart';
import 'package:adn2/pages/ps_work/pro.dart';
import 'package:adn2/pages/account/verif_mail.dart';
import 'package:flutter/material.dart';

Route routeTo(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void nextPage(context, [data]) {
  if (data == null) {
    Navigator.of(context).pushReplacement(routeTo(Loading()));
  }
  else if (data['res'] == "verifAccount") {
    Navigator.of(context).pushReplacement(routeTo(VerifMail()));
  }
  else if (data['res'] == "adminInfo") {
    Data.updateGameState(data["game"]);
    Data.lsUser = data["user"];
    Data.lsInvite = data["invite"];
    Navigator.of(context).pushReplacement(routeTo(Admin()));
  }
  else if (data['res'] == "proInfo") {
    Data.updateGameState(data["game"]);

    Navigator.of(context).pushReplacement(routeTo(Pro()));
  }
  else if (data['res'] == "userInfo") {
    Data.updateGameState(data["game"]);

    Navigator.of(context).pushReplacement(routeTo(Game()));
  }
  else if (data['res'] == "noGame") {
    Data.timeToReset = data["timeToReset"];
    Navigator.of(context).pushReplacement(routeTo(NoGame()));
  }
  else if (data['res'] == "testOver") {
    Navigator.of(context).pushReplacement(routeTo(Buy()));
  }
  else {
    Navigator.of(context).pushReplacement(routeTo(Loading()));
  }
}