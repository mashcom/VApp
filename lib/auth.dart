import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:MSU_Voter_App/config.dart';
import 'package:MSU_Voter_App/tabs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  final dynamic message;

  const AuthScreen({Key? key, this.message}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(
              size: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "MSU Voter App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "To get started please scan the QR on the back of your National ID Card",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "${widget.message}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: _scan, child: Text("TAP TO SCAN YOUR NATIONAL ID")),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "red", "Cancel ", true, ScanMode.QR);
    log(barcodeScanRes.toString());

    var url = Uri.http(
        API_BASE, '/api/ballot/verify_id', {'scan': barcodeScanRes.toString()});
    print("SCAN RESULTS");
    print(url.toString());
    var response = await http.get(url);
    var result = jsonDecode(response.body);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      var national_id = result["data"]["national_id"];
      var voter_id = result["data"]["id"];

      prefs.setInt('national_id', voter_id);
      prefs.setInt('voter_id', voter_id);

      return Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (BuildContext context) => TabsPage()));
    }
    if (result['success'] == false) {
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => AuthScreen(
            message: result['message'],
          ),
        ),
      );
    }
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AuthScreen(
          message: "Request could not be processed. Network Error encountered!",
        ),
      ),
    );
  }
}
