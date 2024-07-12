import 'package:onu3_server/packet/outgoing_packet.dart';

class GameInvalidPacket implements OutgoingPacket {
  @override
  String get type => "game_invalid";

  final String gameCode;

  GameInvalidPacket({
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
