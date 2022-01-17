import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:MSU_Voter_App/ballot.dart';
import 'package:MSU_Voter_App/config.dart';
import 'package:MSU_Voter_App/tabs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CandidateList extends StatefulWidget {
  final dynamic product;
  final String title;

  const CandidateList({Key? key, required this.title, required this.product})
      : super(key: key);

  @override
  State<CandidateList> createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  TextEditingController editingController = TextEditingController();
  bool _productListReady = false;
  var productList; // = List();
  var select_candidate;

  @override
  void initState() {
    super.initState();
    populateProducts();
  }

  Future getProducts() async {
    var url = Uri.http(API_BASE, '/api/ballot');

    var response = await http.get(url);
    return response.body;
  }

  void populateProducts() {
    print("getting started");
    print(widget.product["candidates"]);
    setState(() {
      _productListReady = true;
    });
    return;
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

  Future<void> _showMyDialog(candidate) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("CONFIRM VOTE"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          border: Border.all(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 0)),
                      child: SizedBox(
                          width: 5,
                          height: 5,
                          child: Image.network("http://" +
                              API_BASE +
                              "/images/" +
                              candidate["image"])),
                    ),
                  ),
                ),
                Text(
                  "${candidate["name"]}",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  "PARTY: ${candidate["party"]["name"]}",
                  style: TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CONFIRM VOTE'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var voter_id = prefs.get("voter_id").toString();
                var url = Uri.http(API_BASE, '/api/ballot/cast_vote', {
                  'candidate_id': candidate["id"].toString(),
                  'voter_id': voter_id,
                  'portfolio_id': candidate["portfolio_id"].toString(),
                });
                print("VOTE RESULTS");
                print(url.toString());
                var response = await http.get(url);
                var result = jsonDecode(response.body);
                print(result);
                if (result["success"]) {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TabsPage(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product["name"])),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _productListReady
                  ? ListView.builder(
                      padding: new EdgeInsets.all(18.0),
                      reverse: false,

                      // Let the ListView know how many items it needs to build.
                      itemCount: widget.product["candidates"].length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        final item = widget.product["candidates"][index];

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
      onTap: () {
        _showMyDialog(product);
      },
      trailing: (widget.product["voted"] !=false)?((widget.product["voted"] == product["id"])
          ? Icon(
              Icons.check_box,
              color: Colors.teal,
            )
          : Icon(
              Icons.whatshot,
              color: Colors.red,
            )):Icon(
        Icons.pending_actions,
        color: Colors.black12,
      ),
      leading: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 200,
                width: 100,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    border: Border.all(
                        color: Color.fromRGBO(0, 0, 0, 0.1), width: 0)),
                child: SizedBox(
                    width: 5,
                    height: 5,
                    child: Image.network(
                        "http://" + API_BASE + "/images/" + product["image"])),
              ),
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
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PARTY: ${product["party"]["name"]}"),
          //ElevatedButton(onPressed: , child: Text("Vote Candidate"))
        ],
      ),
      contentPadding: EdgeInsets.all(10),
    );
  }
}
