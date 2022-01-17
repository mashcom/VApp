import 'package:MSU_Voter_App/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'tabs_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return Timer(duration, () {

      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AuthScreen(message: "",)));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
            height: 400,
            child: Column(
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
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 2,
                ),
              ],
            ),
          )),
    );
  }
}
