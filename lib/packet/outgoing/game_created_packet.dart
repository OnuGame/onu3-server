import 'package:onu3_server/packet/outgoing_packet.dart';

class GameCreatedPacket implements OutgoingPacket {
  @override
  String get type => "game_created";

  final String gameCode;

  GameCreatedPacket({
    required this.gameCode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "gameCode": gameCode,
    };
  }
}
