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
      debugShowCheckedModeBanner: false,
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
  bool isLoading = false;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Message for Encryption/Decryption:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 100,
              width: MediaQuery.of(context).size.width / 1.2,
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
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    "Encrypted/Decrypted Message: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white60,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.only(top: 20),
                    child: SelectableText(
                      _displayValue,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.autorenew),
          onPressed: () async {
            setState(() {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Text(
                            "Loading",
                            style: TextStyle(
                                color: redColor, fontWeight: FontWeight.bold),
                          ),
                          new CircularProgressIndicator()
                        ],
                      ),
                    );
                  });
              new Future.delayed(new Duration(seconds: 2), () {
                Navigator.pop(context); //pop dialog
              });
            });
            _displayValue = await _getEnc(_encryptionMessage.text);
            setState(() => isLoading = false);
          }),
      backgroundColor:
          redColor, // This trailing comma makes auto-formatting nicer for build methods.
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
