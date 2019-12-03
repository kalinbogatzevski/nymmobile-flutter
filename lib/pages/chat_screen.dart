import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/src/channel.dart';
import '../models/chat_model.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;

import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  final WebSocketChannel channel;

  ChatScreen(this.channel);

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    // TODO create a model
//    {
//      content: message,
//    senderProviderPublicKey: this.ownDetails.provider.pubKey,
//    senderPublicKey: this.ownDetails.pubKey,
//    };

//    print(globals.clients);
    // set clients on the state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: globals.clients.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          new ListTile(
            onTap: () {
              globals.selected_client = i;

            },
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
//              backgroundImage: new NetworkImage(""),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: new Text(
                    globals.clients[i]['pubKey'],
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                globals.clients[i]['provider']['pubKey'],
                style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                softWrap: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
