import 'package:onu3_server/packet/outgoing_packet.dart';

class GameStartedPacket implements OutgoingPacket {
  @override
  String get type => "game_started";

  GameStartedPacket();

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
    };
  }
}
