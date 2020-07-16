import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/whatsapp_home.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;
import 'dart:convert';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  cameras = await availableCameras();
//  await globals.loadWallet();
  await globals.connectWS();

  runApp(new MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Messaging",
        theme: new ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black12,
        ),
        debugShowCheckedModeBanner: false,
        home: new WhatsAppHome());
  }
}
