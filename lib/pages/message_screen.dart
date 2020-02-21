import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/src/channel.dart';
import 'package:flutterwhatsapp/globals.dart' as globals;
import 'package:flutter/services.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen();

  @override
  MessageScreenState createState() {
    return new MessageScreenState();
  }
}

class MessageScreenState extends State<MessageScreen> {
  String destination;
  final TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    destination = "none";
    if (globals.selected_client != null) {
      destination = globals.selected_client;
    }

    globals.channel.sink.add('{"type" : "fetch" }');
    // set clients on the state
    setState(() {
      globals.messages.insert(0, "send to: " + destination);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new Flexible(
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => new Text(globals.messages[index]),
            itemCount: globals.messages.length,
          )),
      new Divider(height: 1.0),
      new Container(
        decoration: new BoxDecoration(color: Theme
            .of(context)
            .cardColor),
        child: _buildTextComposer(),
      ),
    ]);
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {});
                },
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme
                    .of(context)
                    .platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                  child: new Text("Send"),
                  onPressed: () => _handleSubmitted(_textController.text),
                )
                    : new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                )),
          ]),
          decoration: Theme
              .of(context)
              .platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border:
              new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if(text.isNotEmpty) {
      globals.sendMessage(destination, text);
      setState(() {
        globals.messages.add("you: " + text);
      });
    }
  }
}
