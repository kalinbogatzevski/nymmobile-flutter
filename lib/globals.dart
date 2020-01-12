library globals;

import 'package:bitcoin_flutter/src/payments/index.dart' show PaymentData;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';

List<dynamic> clients = new List<dynamic>();
int selected_client = 0;
var address = "none";
var bip39 = "";

String getAddress (node, [network]) {
  return P2PKH(data: new PaymentData(pubkey: node.publicKey), network: network).data.address;
}
