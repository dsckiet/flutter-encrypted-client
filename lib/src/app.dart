import 'package:flutter/material.dart';
import 'secure.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Secure"),
        ),
        body: SecureScreen(),
      ),
    );
  }
}
