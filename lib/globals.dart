library globals;

import 'dart:collection';
import 'dart:convert';

import 'package:bitcoin_flutter/src/payments/index.dart' show PaymentData;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:flutterwhatsapp/models/clients_model.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Create storage
final storage = new FlutterSecureStorage();

List<String> clients = new List<String>();
String selected_client = null;
var btcaddr = "none";
var mnemonic = "";
var address = "";
var triesCount = 0;
List<String> messages = new List<String>();
WebSocketChannel channel;

String getAddress(node, [network]) {
  return P2PKH(data: new PaymentData(pubkey: node.publicKey), network: network)
      .data
      .address;
}

String sendMessage(String destination, String message) {
  var payload = {
    "type": "send",
    "message": message,
    "recipient_address": destination
  };
  var jsonPayload = json.encode(payload);
  channel.sink.add(jsonPayload);
}

Future<void> loadWallet() async {
  // check if exists
  var words = await storage.read(key: "bip39Words");
  if (words == null) {
    // generate wallet
    words = bip39.generateMnemonic();
    // save wallet
    await storage.write(key: "bip39Words", value: words);
  }

  var seed = bip39.mnemonicToSeed(mnemonic);
  var root = bip32.BIP32.fromSeed(seed);

  // save address
  btcaddr = getAddress(root.derivePath("m/0'/0/0"));
  mnemonic = words;
}
