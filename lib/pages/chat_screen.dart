import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/models/clients_model.dart';
import 'package:web_socket_channel/src/channel.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;

import 'message_screen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen();

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
//    globals.channel.sink.add('{"type" : "getClients" }');
    setState(() {});
  }

  void filterSearchResults(String query) {
    if (query.length > 3) {
      List<String> dummyListData = List<String>();
      globals.clients.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        globals.clients.clear();
        globals.clients.addAll(dummyListData);
      });
      return;
    } else if (query.length == 0) {
      setState(() {
        globals.clients.clear();
        globals.channel.sink.add('{"type" : "getClients" }');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();

    return new Container(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            filterSearchResults(value);
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      ),
      Expanded(
          child: new ListView.builder(
        itemCount: globals.clients.length,
        itemBuilder: (context, i) => new Column(
          children: <Widget>[
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              onTap: () {
                globals.selected_client = globals.clients.elementAt(i);
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
                      globals.clients != null
                          ? globals.clients.elementAt(i)
                          : "",
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
                  globals.clients != null ? globals.clients.elementAt(i) : "",
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  softWrap: true,
                ),
              ),
            )
          ],
        ),
      ))
    ]));
  }
}
