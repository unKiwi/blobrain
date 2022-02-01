import 'package:adn2/pages/loading.dart';
import 'package:adn2/pages/verif_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:flutter/services.dart';
void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      debugShowCheckedModeBanner: false,
    );
  }
}