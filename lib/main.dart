// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:adn2/data/http.dart';
import 'package:adn2/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:flutter/services.dart';
void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
}

class MyApp extends StatelessWidget {
  static var materialKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A D N ²',
      onGenerateRoute: (settings) {
        // final args = settings.arguments as ScreenArguments;

        return MaterialPageRoute(
          builder: (context) {
            // return PassArgumentsScreen(
            //   title: args.title,
            //   message: args.message,
            // );
            return Loading();
          },
        );
      },
      navigatorKey: MyApp.materialKey,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RaisedButton(
        onPressed: () async {
          var res = await Http.req(
            "test",
            {
              
            },
          );

          print("test");
        },
      ),
    );
  }
}