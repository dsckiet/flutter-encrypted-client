import 'dart:convert';
import 'package:encrypt/encrypt.dart' as en;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() async {
  Map _data = await getJSON("https://floating-sierra-36981.herokuapp.com/api/index");
  final key = en.Key.fromUtf8("LOVE_MURADNAGAR.................");
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
//  final encrypted= en.Encrypted(_data['data']);
//  final encrypted = encrypter.encrypt(_data['data'], iv: iv);
  final decrypted = encrypter.decrypt(_data['data'], iv: iv);
  print("Encryped Data=> $_data");
  print("Decryped Data=> $decrypted");
  runApp(MaterialApp(
    home: SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Text(_data['data'].toString()),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Text(decrypted),
            ],
          ),
        ),
      ),
    ),
  ));
}

getJSON(String str) async {
  http.Response response = await http.get(str);

  print(response.body);
  print(json.decode(response.body));
  return (response.body);
}

