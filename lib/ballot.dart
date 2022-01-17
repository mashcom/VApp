import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:MSU_Voter_App/candidate_list.dart';
import 'package:MSU_Voter_App/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyBallot extends StatefulWidget {
  const MyBallot({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyBallot> createState() => _MyBallotState();
}

class _MyBallotState extends State<MyBallot> {
  TextEditingController editingController = TextEditingController();
  bool _productListReady = false;
  var productList; // = List();

  @override
  void initState() {
    super.initState();
    populateProducts();
  }

  Future getProducts() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final voter_id = prefs.get('voter_id').toString();
    print("VOTER ID");
    print(prefs.get('voter_id'));
    var url = Uri.http(API_BASE, '/api/ballot', {'voter_id': voter_id});
    print(url);
    var response = await http.get(url);
    return response.body;
  }

  void populateProducts() {
    print("getting started");
    getProducts().then((resp) {
      var result = jsonDecode(resp);

      if (result['success']) {
        productList = result['data'];
      }
      print("PRODUCT LIST");
      print(productList);
      setState(() {
        _productListReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _productListReady
                  ? ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: false,

                      // Let the ListView know how many items it needs to build.
                      itemCount: productList.length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        final item = productList[index];

                        return productWidget(context, item);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productWidget(BuildContext context, product) {
    return ListTile(
      iconColor: (product["voted"]==false)?Colors.black26:Colors.teal,
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CandidateList(
              product: product,
              title: product["name"],
            ),
          ),
        );
      },
      leading: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  border: Border.all(
                      color: Color.fromRGBO(0, 0, 0, 0.0), width: 0)),
              child: SizedBox(
                  width: 5, height: 5, child: (product["voted"]==false)?Icon(Icons.pending_actions):Icon(Icons.assignment_turned_in)),
            ),
          )
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${product["name"]}",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward),
      subtitle: Text(
        "${product["candidates"].length} CANDIDATES",
      ),
    );
  }
}
