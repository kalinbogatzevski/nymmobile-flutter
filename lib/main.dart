import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutterwhatsapp/whatsapp_home.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;

List<CameraDescription> cameras;
WebSocketChannel channel;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  channel = await connectWS();

  // "praise you muffin lion enable neck grocery crumble super myself license ghost";
  var mnemonic = bip39.generateMnemonic();
  var seed = bip39.mnemonicToSeed(mnemonic);
  var root = bip32.BIP32.fromSeed(seed);
  print(seed);
  print(root.derivePath("m/0'/0/0"));

  globals.address = globals.getAddress(root.derivePath("m/0'/0/0"));
  globals.bip39 = mnemonic;

  runApp(new MyApp());
}

Future<WebSocketChannel> connectWS() async {
  channel = IOWebSocketChannel.connect('ws://127.0.0.1:9001/');

  channel.stream.listen((data) {
    // parse from json
    Map<String, dynamic> decode = jsonDecode(data);
    print(data);
    // check message type
//      decode["clients"]
//      decode["fetch"]

    if (decode["clients"] != null) {
      globals.clients = decode["clients"];
    }
    print(data);
    // base64url.decode()
  }, onError: (err) {
    print("err: $err");
  }, onDone: () {
    print("onDone. ");
  });

  channel.sink.add('{"type" : "getClients" }');
  //  channel.sink.add('{"fetch" : {}}');

  return channel;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Messaging",
        theme: new ThemeData(
          primaryColor: new Color(0xff075E54),
          accentColor: new Color(0xff25D366),
        ),
        debugShowCheckedModeBanner: false,
        home: new WhatsAppHome(cameras: cameras, channel: channel));
  }
}
