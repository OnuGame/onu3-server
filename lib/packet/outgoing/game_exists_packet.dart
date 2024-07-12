import 'package:onu3_server/packet/outgoing_packet.dart';

class GameExistsPacket implements OutgoingPacket {
  @override
  String get type => "game_exists";

  final String gameCode;

  GameExistsPacket({
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
