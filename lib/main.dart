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
  cameras = await availableCameras();
  await globals.loadWallet();
  await connectWS();

  runApp(new MyApp());
}

Future<void> connectWS() async {
  sleep(const Duration(seconds: 5));
  try {
    globals.channel = IOWebSocketChannel.connect('ws://127.0.0.1:9001/');

    globals.channel.stream.listen((data) {
      Map<String, dynamic> decode = jsonDecode(data);
      print(decode);
      if (decode["type"] == "getClients") {
        final list = decode["clients"];
        for (final x in list) {
          globals.clients[x] = new Client(name: x, pubkey: x);
        }
      } else if (decode["type"] == "ownDetails") {
        globals.me = decode['address'];
      } else if (decode["type"] == "fetch") {
//      base64.encode(bytes);
      }
    }, onError: (err) {
      print("err: $err");
    }, onDone: () {
      print("onDone. ");
    });

    globals.channel.sink.add('{"type" : "ownDetails" }');
    globals.channel.sink.add('{"type" : "getClients" }');
    globals.channel.sink.add('{"type" : "fetch" }');
    globals.sendMessage(
        "Np8qdePpksIIvkCx26yspj1LMynfgERAYRqT4q1TMng=", "test message");

  } catch (e) {
    print('Error connecting to ws: $e');
    globals.triesCount++;
    if (globals.triesCount <= 3) {
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
