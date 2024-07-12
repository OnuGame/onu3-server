import 'dart:convert';

import 'package:onu3_server/packet/incoming_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';
import 'package:onu3_server/packet/packet.dart';
import 'package:web_socket_channel/io.dart';

class Connection {
  final IOWebSocketChannel webSocket;
  final Map<Type, List<Function>> callbacks = {};

  Connection(this.webSocket) {
    webSocket.stream.listen((message) {
      print("↙️ $message");

      final Map<String, dynamic> jsonMessage = json.decode(message as String);

      Packet packet = IncomingPacket.fromJson(jsonMessage);
      // get type of packet
      Type type = packet.runtimeType;
      if (callbacks.containsKey(type)) {
        for (var callback in callbacks[type]!) {
          callback(packet);
        }
      }
    });
  }

  void send(OutgoingPacket packet) {
    String message = json.encode(packet.toJson());

    print("↗️ $message");

    webSocket.sink.add(message);
  }

  void close() {
    webSocket.sink.close();
  }

  void on<T>(Function(T) callback) {
    if (!callbacks.containsKey(T)) {
      callbacks[T] = [];
    }
    callbacks[T]!.add(callback);
  }
}
