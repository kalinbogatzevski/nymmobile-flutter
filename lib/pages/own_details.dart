import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/src/channel.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';

import 'message_screen.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text("Nym Public Address"),
        QrImage(
          data: globals.address,
          version: QrVersions.auto,
          size: 200.0,
        ),
        new Text(
          globals.address,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          softWrap: true,
        ),
      ],
    );
  }
}
