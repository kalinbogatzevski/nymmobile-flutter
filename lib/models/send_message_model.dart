class SendMessagePayload {
  String type;
  String message;
  String recipient_address;

  SendMessagePayload(String t, String m, String d) {
    type = t;
    message = m;
    recipient_address= d;
  }
}
