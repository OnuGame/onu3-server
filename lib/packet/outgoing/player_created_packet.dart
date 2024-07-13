import 'package:onu3_server/packet/outgoing_packet.dart';

class PlayerCreatedPacket implements OutgoingPacket {
  @override
  String get type => "player_created";

  final String username;

  PlayerCreatedPacket({
    required this.username,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "username": username,
    };
  }
}
