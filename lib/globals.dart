library globals;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Create storage
final storage = new FlutterSecureStorage();

List<String> clients = new List<String>();
List<String> messages = new List<String>();
String selected_client = null;
String nym_address = "";
String ipAddress = "";
var triesCount = 0;
WebSocketChannel channel;

String sendMessage(String destination, String message) {
  var payload = {
    "type": "send",
    "message": message,
    "recipient_address": destination
  };
  var jsonPayload = json.encode(payload);
  channel.sink.add(jsonPayload);
}

Future selectFirtIPv4Address() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (!addr.isLoopback) {
        if (addr.type.name == "IPv4") {
          ipAddress = addr.address;
          break;
        }
      }
    }
  }
}

Future<void> check_messages() async {
  print("check messages");
  new Future.delayed(const Duration(seconds: 6), () {
    print('fetching info ...');

    channel.stream.listen((data) {
      print(data);
      Map<String, dynamic> decode = jsonDecode(data);
      print(decode);
      if (decode["type"] == "getClients") {
        final list = decode["clients"];
        for (final x in list) {
          clients.add(x);
        }
        clients.sort();
      } else if (decode["type"] == "ownDetails") {
        nym_address = decode['address'];

        check_messages();
      } else if (decode["type"] == "fetch") {
        print(decode["messages"]);
        for (final x in decode["messages"]) {
          messages.add(x);
        }
      }
    }, onError: (err) {
      print("err: $err");
    }, onDone: () {});

//    channel.sink.add('{"type" : "selfAddress" }');
//    channel.sink.add('{"type" : "getClients" }');
//    channel.sink.add('{"type" : "SelfAddress" }');
//    channel.sink.add('{"type" : "GetClients" }');
    check_messages();
  });
}

Future<void> connectWS() async {
  await selectFirtIPv4Address();
  try {
    await Future.delayed(Duration(seconds: 5));
    var webSocketAddress = 'ws://' + ipAddress + ':1789';
    print(webSocketAddress);
    channel = IOWebSocketChannel.connect(webSocketAddress);

    channel.stream.listen((data) {
      print(data);
    }, onError: (err) {
      print("err: $err");
    }, onDone: () {});

    channel.sink.add('{"type" : "selfAddress" }');
  } catch (e) {
    print('Error connecting to ws: $e');
    triesCount++;
    if (triesCount <= 3) {
      print("trying " + triesCount.toString());

      await connectWS();
    }
  }
}
