import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/src/channel.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class MessageScreen extends StatefulWidget {

  MessageScreen();

  @override
  MessageScreenState createState() {
    return new MessageScreenState();
  }
}

class MessageScreenState extends State<MessageScreen> {
  String destination;
  String barcode = "";

  @override
  void initState() {
    super.initState();
    destination = "none";
    print(globals.selected_client);
    print(globals.clients[globals.selected_client]);
    // set clients on the state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: new Text(
            "My Nym Address: " +
                " \r\n " +
                globals.me +
                "Address: " +
                globals.address +
                " \r\n "
                    "BIP39: " +
                globals.mnemonic,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            softWrap: true,
          ),
        ),
        new Container(
          child: new MaterialButton(onPressed: scan, child: new Text("Scan")),
          padding: const EdgeInsets.all(8.0),
        ),
        new Text(barcode),
      ],
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
