import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutterwhatsapp/models/clients_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutterwhatsapp/whatsapp_home.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;
import 'dart:convert';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  cameras = await availableCameras();
//  await globals.loadWallet();
  runApp(new MyApp());

  await connectWS();
}

Future<void> check_messages() async {
  new Future.delayed(const Duration(seconds: 6), () {
    globals.channel.sink.add('{"type" : "fetch" }');
    check_messages();
  });
}

Future<void> connectWS() async {
  try {
    // TODO add a loading screen
    await Future.delayed(Duration(seconds: 20));

    globals.channel = IOWebSocketChannel.connect('ws://127.0.0.1:1707');

    globals.channel.stream.listen((data) {
      Map<String, dynamic> decode = jsonDecode(data);
      print(decode);
      if (decode["type"] == "getClients") {
        final list = decode["clients"];
        for (final x in list) {
          globals.clients.add(x);
        }
        globals.clients.sort();
      } else if (decode["type"] == "ownDetails") {
        globals.address = decode['address'];

        check_messages();
      } else if (decode["type"] == "fetch") {
        print(decode["messages"]);
        for (final x in decode["messages"]) {
          globals.messages.add(x);
        }
      }
    }, onError: (err) {
      print("err: $err");

      globals.triesCount++;
      if (globals.triesCount <= 3) {
        print("trying " + globals.triesCount.toString());
        connectWS();
      }
    }, onDone: () {
      print("onDone. ");
    });

    globals.channel.sink.add('{"type" : "ownDetails" }');
    globals.channel.sink.add('{"type" : "getClients" }');
    globals.channel.sink.add('{"type" : "fetch" }');
  } catch (e) {
    print('Error connecting to ws: $e');
    globals.triesCount++;
    if (globals.triesCount <= 3) {
      print("trying " + globals.triesCount.toString());

      await connectWS();
    }
  }
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
        home: new WhatsAppHome(cameras: cameras));
  }
}
