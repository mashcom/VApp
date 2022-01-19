import 'package:MSU_Voter_App/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'ballot.dart';

class TabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSU Voter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "AirbnbCereal",
        platform: TargetPlatform.iOS,
        accentColor: Colors.blueAccent,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(Icons.ballot_rounded),
                  text: "Ballot",
                ),
                Tab(
                  icon: Icon(Icons.info),
                  text: "About",
                ),
//                Tab(
//                  icon: Icon(Icons.camera_enhance),
//                  text: "Scan",
//                ),
              ],
            ),
            title: Text('MSU Voter App'),

          ),
          body: TabBarView(
            children: [
              MyBallot(title: "title"),
              //MyBallot(title: "title"),
              InfoPage(title: "Scanner"),
            ],
          ),

        ),
      ),
    );
  }
}
