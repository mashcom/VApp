import 'dart:developer';
import 'dart:ui';

import 'package:MSU_Voter_App/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Total Fuel Finder',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: "AirbnbCereal",
        platform: TargetPlatform.iOS,
        accentColor: Colors.indigoAccent,
      ),
      home: SplashScreen(),
    );
  }
}
