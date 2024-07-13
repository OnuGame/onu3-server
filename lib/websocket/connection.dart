import 'dart:convert';

import 'package:onu3_server/onu/event/disconnect_event.dart';
import 'package:onu3_server/onu/player.dart';
import 'package:onu3_server/packet/incoming_packet.dart';
import 'package:onu3_server/packet/outgoing/error_packet.dart';
import 'package:onu3_server/packet/outgoing_packet.dart';
import 'package:onu3_server/packet/packet.dart';
import 'package:web_socket_channel/io.dart';

class Connection {
  final IOWebSocketChannel webSocket;
  final Map<Type, List<Function>> callbacks = {};
  Player? player;

  Connection(this.webSocket) {
    webSocket.stream.listen((message) {
      print("↙️ $message");

      final Map<String, dynamic> jsonMessage = json.decode(message as String);

      try {
        Packet packet = IncomingPacket.fromJson(jsonMessage);
        // get type of packet
        Type type = packet.runtimeType;
        if (callbacks.containsKey(type)) {
          for (var callback in callbacks[type]!) {
            callback(packet);
          }
        }
      } catch (error) {
        print("❗ Error: $error");
        send(ErrorPacket(errorMessage: error.toString()));
      }
    });

    webSocket.stream.handleError((error) {
      print("❗ Error: $error");
      triggerDisconnectEvent();
    });

    webSocket.sink.done.then((value) {
      print(
          "❌ Connection closed: ${webSocket.closeCode} ${webSocket.closeReason}");
      triggerDisconnectEvent();
    });
  }

  void send(OutgoingPacket packet) {
    String message = json.encode(packet.toJson());

    print("↗️ $message");

    webSocket.sink.add(message);
  }

  void close() {
    webSocket.sink.close();
    triggerDisconnectEvent();
  }

  void triggerDisconnectEvent() {
    if (callbacks.containsKey(DisconnectEvent)) {
      for (var callback in callbacks[DisconnectEvent]!) {
        callback(DisconnectEvent());
      }
    }
  }

  void on<T>(Function(T) callback) {
    if (!callbacks.containsKey(T)) {
      callbacks[T] = [];
    }
    callbacks[T]!.add(callback);
  }
}
