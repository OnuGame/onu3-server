import 'package:onu3_server/packet/incoming/create_game_packet.dart';
import 'package:onu3_server/packet/incoming/join_game_packet.dart';
import 'package:onu3_server/packet/packet.dart';

abstract class IncomingPacket implements Packet {
  factory IncomingPacket.fromJson(Map<String, dynamic> json) {
    // We only need to map incoming packets
    switch (json["type"]) {
      case "join_game":
        return JoinGamePacket.fromJson(json);
      case "create_game":
        return CreateGamePacket.fromJson(json);

      default:
        throw Exception("Invalid packet type");
    }
  }
}
