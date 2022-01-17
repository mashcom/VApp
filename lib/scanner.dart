import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:MSU_Voter_App/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;


class MyScanner extends StatefulWidget {
  const MyScanner({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyScanner> createState() => _MyScannerState();
}

class _MyScannerState extends State<MyScanner> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: _scan, child: Text("TAP TO SCAN YOUR NATIONAL ID")),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "red", "Cancel ", true, ScanMode.QR);
    log(barcodeScanRes.toString());

    var url = Uri.http(API_BASE, '/api/ballot/verify_id',{'scan':barcodeScanRes.toString()});
    print("SCAN RESULTS");
    print(url.toString());
    var response = await http.get(url);
    print(response.body);
  }

}
