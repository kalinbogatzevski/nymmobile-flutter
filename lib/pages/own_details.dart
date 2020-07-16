import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;

class DetailScreen extends StatefulWidget {
  DetailScreen();

  @override
  DetailScreenState createState() {
    return new DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      globals.check_messages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text("NYM ADDRESS"),
        new Text(
          globals.nym_address,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          softWrap: true,
        ),
        new Text("MIXNODE IP ADDRESS"),
        new Text(
          globals.ipAddress,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          softWrap: true,
        ),
        new Text("Working in Progress ..."),
        new Text(
          "",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          softWrap: true,
        ),
      ],
    );
  }
}
