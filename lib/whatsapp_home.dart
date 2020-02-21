import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/pages/message_screen.dart';
import 'package:flutterwhatsapp/pages/camera_screen.dart';
import 'package:flutterwhatsapp/pages/chat_screen.dart';
import 'package:flutterwhatsapp/pages/own_details.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WhatsAppHome extends StatefulWidget {
  final List<CameraDescription> cameras;

  WhatsAppHome({this.cameras});

  @override
  _WhatsAppHomeState createState() => _WhatsAppHomeState();
}

class _WhatsAppHomeState extends State<WhatsAppHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        showFab = true;
      } else {
        showFab = false;
      }


      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("nym project - demo chat"),
          elevation: 0.7,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[Tab(text: "Contacts"), Tab(text: "Chat"), Tab(text: "Info")],
          ),
          actions: <Widget>[
            Icon(Icons.search),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
            Icon(Icons.more_vert)
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[ChatScreen(), MessageScreen(), DetailScreen()],
        )
//      ,
//      floatingActionButton: showFab
//          ? FloatingActionButton(
//        backgroundColor: Theme
//            .of(context)
//            .accentColor,
//        child: Icon(
//          Icons.send,
//          color: Colors.white,
//        ),
//        onPressed: () => print("Send !"),
//      )
        );
  }
}
