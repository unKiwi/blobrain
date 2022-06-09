import 'package:flutter/material.dart';
import 'package:dart_ping/dart_ping.dart';

class ConnectionStatus extends StatefulWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  State<ConnectionStatus> createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  void startPing() async {
    // Create ping object with desired args
    final ping = Ping('google.com', count: 5);

    // Begin ping process and listen for output
    ping.stream.listen((event) {
      print(event);
    });
  }

  @override
  void initState() {
    startPing();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("12");
  }
}