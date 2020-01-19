class Client {
  final String pubkey;
  final String name;
  List<dynamic> messages = new List<dynamic>();

  Client({this.pubkey, this.name});

  void set addMessage(String message) {
    this.messages.add(message);
  }

  List<dynamic> getMessages() {
    return this.messages;
  }
}

