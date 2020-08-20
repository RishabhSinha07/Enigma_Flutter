import 'package:flutter/material.dart';
import './models/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enigma Encryption',
      home: MyHomePage(title: 'Enigma Encryption'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _displayValue = "NA";
  bool _isLoading = false;

  TextEditingController _encryptionMessage = TextEditingController();

  Future<dynamic> _getEnc(String _encryptionMessage) async {
    String url =
        "https://ksylxps6w0.execute-api.ap-northeast-1.amazonaws.com/Dev/enigma";
    final response =
        await http.get(url, headers: {'encoading_string': _encryptionMessage});
    return LoadData.fromJson(json.decode(response.body)).encVal;
  }

  @override
  Widget build(BuildContext context) {
    print(_displayValue);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please type the message to Encrypt/Decrypt:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: darkGreyColor),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: false,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  controller: _encryptionMessage,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Message',
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "Encrypted/Decrypted Message from server: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: SelectableText(
                    _displayValue,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: redColor,
          child: Icon(Icons.get_app),
          onPressed: () async {
            setState(() => _isLoading = true);
            _displayValue = await _getEnc(_encryptionMessage.text);
            setState(() => _isLoading = false);
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoadData {
  final String encVal;
  LoadData({this.encVal});
  factory LoadData.fromJson(Map<String, dynamic> json) {
    return LoadData(encVal: json["Encoded/Decoded String: "]);
  }
}
