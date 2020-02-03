import 'dart:io';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SecureScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SecureState();
  }
}

class SecureState extends State<SecureScreen> {
  String _content;
  Digest _fileDigest;

  @override
  void initState() {
    super.initState();
    checkPermission().then((bool value) {
      if (!value) {
        requestPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[inputField(), writeButton(), verifyButton()],
      ),
    );
  }

  inputField() {
    return TextField(
      decoration: InputDecoration(
          labelText: "Sensitive Data", hintText: "Sensitive Data"),
      onSubmitted: (value) {
        _content = value;
      },
      onChanged: (newValue) {
        print(newValue);
      },
    );
  }

  verifyButton() {
    return RaisedButton(
        child: Text("Verify"),
        onPressed: () {
          readCounter().then((String value) {
            Digest digest = hmac(
                value); //The final digest which will be used for verification
            if (digest.toString() == _fileDigest.toString()) {
              //Content is same
              snackbar('Data is correct.');
            } else {
              //Someone changed the content
              snackbar('You trying to cheat.');
            }
          });
        });
  }

  void snackbar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(context).showSnackBar(snackBar);
  }

  writeButton() {
    return RaisedButton(
        child: Text("Save"),
        onPressed: () {
          print("Write Button $_content");
          String body = """
          {"user_details":{"name":"Sagar","age": "25""email":"sagarsuri56@gmail.com","current_level": $_content}}
          """;
          _content = body;
          writeCounter(_content);
          Digest digest = hmac(
              _content); //The final digest which will be used for verification
          _fileDigest = digest;
        });
  }

  Digest hmac(String data) {
    var key = utf8.encode("p@ssw0rd"); //Secret key used for authentication
    var bytes = utf8.encode(data);
    var hmacSha256 = new Hmac(sha256, key);
    Digest digest = hmacSha256
        .convert(bytes); //The final digest which will be used for verification
    return digest;
  }
}

Future<String> get _localPath async {
  final directory = await getExternalStorageDirectory();
  print("directory ${directory.path}");
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/config.txt');
}

writeCounter(String content) async {
  final file = await _localFile;
  // Write the file
  await file.writeAsString('$content');
}

Future<String> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If we encounter an error, return empty string
    return "";
  }
}

Future<bool> checkPermission() async {
  bool res =
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
  return res;
}

requestPermission() async {
  await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
}
