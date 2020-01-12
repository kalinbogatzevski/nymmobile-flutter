import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/pages/message_screen.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutterwhatsapp/whatsapp_home.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;

List<CameraDescription> cameras;
WebSocketChannel channel;

// websocket

// current chats from storage

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  channel = await connectWS();

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

    if(decode["clients"] != null) {
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
