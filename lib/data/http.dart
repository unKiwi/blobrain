// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:adn2/data/conf.dart';
import 'package:http/http.dart' as http;

class Http {
  static Future<http.Response> req(path, body) async {
    final res = await http.post(
      Uri.parse(Conf.uri + path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    return res;
  }
}