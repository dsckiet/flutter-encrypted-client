import 'dart:convert';
import 'package:encrypt/encrypt.dart' as en;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  Map _data = await getJSON("https://floating-sierra-36981.herokuapp.com/api/index");
//  Encrypted test = _data['data'];
  final key = en.Key.fromUtf8("LOVE_MURADNAGAR");
  final test = en.Key.fromUtf8(_data['data']);

  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  final decrypted = encrypter.decrypt(test, iv: iv);
  print("Data=> $_data");
  runApp(MaterialApp(
    home: SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Text(decrypted),
            ],
          ),
        ),
      ),
    ),
  ));
}

getJSON(String str) async {
//  String apiUrl = str ;
  http.Response response = await http.get(str);

  print(response.body);
  return json.decode(response.body);
}
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text(_data[0]),
//    );
//  }
//}
